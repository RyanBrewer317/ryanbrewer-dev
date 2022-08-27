module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Parser exposing (..)
import Set
import Dict
import Result exposing (Result(..))

main : Program () Model Update
main = Browser.sandbox { 
      init = init
    , view = view
    , update = update
    }

type alias Model = { output : String }

init : Model
init = { output = "" }

type Update = NewCode String

update : Update -> Model -> Model
update msg model = case msg of
    NewCode code -> { model | output = code }

view : Model -> Html Update
view model = div [] 
    [ nav [] 
        [ text "Ryan Brewer" 
        ]
    , div [ id "body" ] 
        [ text "This is my website. It's hosted by Firebase and written mostly in Elm, and the code is up on " 
        , a [ href "https://github.com/RyanBrewer317/ryanbrewer-dev" ] [ text "my github" ]
        , text "."
        , br [] []
        , textarea 
            [ id "code"
            , placeholder "Write some lambda calculus code! Example: (\\x.\\y.x)(\\x.x)(3)"
            , onInput NewCode 
            ] []
        , br [] []
        , text (if model.output == "" then "" else go model.output)
        ]
    ]

resToString : Result String String -> String
resToString res = case res of
    Ok s -> s
    Err s -> s

type Expr = LInt Int
          | LVar String
          | LLambda String Expr
          | LCall Expr Expr

parseInt : Parser Expr
parseInt = number {int = Just LInt, hex = Nothing, octal = Nothing, binary = Nothing, float = Nothing}

parseVar : Parser Expr
parseVar = variable {start = Char.isLower, inner = Char.isAlphaNum, reserved = Set.fromList([])} |> Parser.map LVar

parseLambda : Parser Expr
parseLambda = succeed LLambda
           |. symbol "\\"
           |. spaces
           |= variable {start = Char.isLower, inner = Char.isAlphaNum, reserved = Set.fromList([])}
           |. spaces
           |. symbol "."
           |. spaces
           |= lazy (\_->parseExpr)

parenthetical : Parser a -> Parser a
parenthetical p = succeed identity
               |. symbol "("
               |= p
               |. symbol ")"

parseLiteral : Parser Expr
parseLiteral = oneOf [parseInt, parseVar, parseLambda, parenthetical (lazy (\_->parseExpr))]

parseExpr : Parser Expr
parseExpr = succeed identity
    |. spaces
    |= parseLiteral 
    |. spaces 
    |> andThen (\lit->
        Parser.loop lit (\expr->
            succeed identity
            |= oneOf 
                [ parenthetical (lazy (\_->parseExpr))
                    |> Parser.map (LCall expr)
                    |> Parser.map Loop
                , succeed expr 
                    |> Parser.map Done
                ]
            |. spaces
        )
    )

type Gen = Gen Int

withFresh : Gen -> (Gen -> String -> (Gen, a)) -> (Gen, a)
withFresh (Gen i) f = f (Gen (i + 1)) (String.fromInt i)

withFreshRes : Gen -> (Gen -> String -> Result e (Gen, a)) -> Result e (Gen, a)
withFreshRes (Gen i) f = f (Gen (i + 1)) (String.fromInt i)

type Type = TInt
          | TLambda Type Type
          | TVar String

type AnnExpr = AnnVar String Type
             | AnnInt Int
             | AnnLambda String AnnExpr Type
             | AnnCall AnnExpr AnnExpr Type

type Constraint = Eq Type Type

typecheck : Dict.Dict String Type -> Gen -> Expr -> Result String (Gen, AnnExpr, List Constraint)
typecheck scope gen expr = case expr of
    LVar v -> 
        case Dict.get v scope of
            Nothing -> Err (v ++ " used out of scope!")
            Just t -> Ok (gen, AnnVar v t, [])
    LCall foo bar ->
        typecheck scope gen foo  |> Result.andThen (\(gen2, annFoo, fooConsts)->
        typecheck scope gen2 bar |> Result.map (\(gen3, annBar, barConsts)->
        withFresh gen3 (\gen4 v->
        let exprType = TVar v in
        let fooType = typeOf annFoo in
        let barType = typeOf annBar in
        (gen4, (AnnCall annFoo annBar exprType, (Eq (TLambda barType exprType) fooType)::fooConsts++barConsts))
        ) |> (\(gen5, (annCall, consts))->(gen5, annCall, consts))))
    LLambda v e -> 
        let (gen3, argType) = withFresh gen (\gen2 v2->(gen2, TVar v2)) in
        typecheck (Dict.insert v argType scope) gen3 e |> Result.map (\(gen4, annE, eConsts)->
        let bodyType = typeOf annE in
        let exprType = TLambda argType bodyType in
        (gen4, AnnLambda v annE exprType, eConsts))
    LInt i -> Ok (gen, AnnInt i, [])

typeOf : AnnExpr -> Type
typeOf ann = case ann of
    AnnVar _ t -> t
    AnnInt _ -> TInt
    AnnLambda _ _ t -> t
    AnnCall _ _ t -> t

eval : Gen -> Dict.Dict String Expr -> Expr -> Result String (Gen, Expr)
eval gen scope expr = case expr of
    LVar v -> Result.fromMaybe (v ++ " used out of scope!") <| Maybe.map (\val->(gen, val)) <| Dict.get v scope
    LCall fooRes barRes -> 
        eval gen scope fooRes |> Result.andThen (\(gen2, foo)->
        eval gen2 scope barRes |> Result.andThen (\(gen3, bar)->
        case foo of
            LLambda v e -> withFreshRes gen (\gen4 var->
                eval gen4 scope (rename v ("x_"++var) foo) |> Result.andThen (\(gen5, foo2)->
                eval gen5 scope bar |> Result.andThen (\(gen6, bar2)->
                eval gen6 (Dict.insert v bar2 scope) e)))
            _ -> Err "calling nonfunction!"))
    _ -> Ok (gen, expr)

rename : String -> String -> Expr -> Expr
rename old new expr = case expr of
    LVar v -> if v == old then LVar new else expr
    LCall foo bar -> LCall (rename old new foo) (rename old new bar)
    LLambda v e -> LLambda (if v == old then new else v) (rename old new e)
    LInt _ -> expr

toString : Expr -> String
toString expr = case expr of
    LVar v -> v
    LInt i -> String.fromInt i
    LLambda v e -> "\\" ++ v ++ "." ++ toString e
    LCall foo bar -> "(" ++ toString foo ++ ")(" ++ toString bar ++ ")"

go : String -> String
go code = run (parseExpr |. end) code |> Result.mapError (\_->"parse error!") |> Result.andThen (\expr -> eval (Gen -1) Dict.empty expr) |> Result.map (\(gen, x)->toString x) |> resToString