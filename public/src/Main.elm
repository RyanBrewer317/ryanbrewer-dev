module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Parser exposing (..)
import Set
import Dict
import Result exposing (Result(..))
import Char exposing (isDigit)

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
        [ p [] 
            [ text "This is my website. It's hosted by Firebase and written mostly in Elm, and the code is up on "
            , a [ href "https://github.com/RyanBrewer317/ryanbrewer-dev" ] [ text "my github" ]
            , text "."
            ]
        , p [] [text "Here's a lambda calculus implementation I made, try writing some expressions!"]
        , textarea 
            [ id "code"
            , placeholder "Write some lambda calculus code! Example: (\\x.\\y.x)(\\x.x)(3)"
            , onInput NewCode 
            ] []
        , br [] []
        , if model.output == "" then text "" else div [] (go model.output |> run parseOutput |> Result.withDefault [text "internal parser error!"] |> (\l->strong [] [text "output "]::text " (variables may be renamed): "::l))
        ]
    ]

subscriptParser : Parser (Html msg)
subscriptParser = succeed identity
               |. symbol "_"
               |. chompWhile isDigit 
               |> getChompedString
               |> Parser.map (\i->sub [style "font-size" "7pt", style "margin-right" "1px"] [text (String.dropLeft 1 i)])

normalParser : Parser (Html msg)
normalParser = succeed () |. chompWhile (\c->c/='_') |> getChompedString |> Parser.map text

parseOutput : Parser (List (Html msg))
parseOutput = Parser.loop [] parseOutputHelp
parseOutputHelp : List (Html msg) -> Parser (Step (List (Html msg)) (List (Html msg)))
parseOutputHelp revHtml = oneOf [succeed (\sub->Loop (sub::revHtml)) |= subscriptParser, succeed () |. end |> Parser.map (\_->Done(List.reverse revHtml)), succeed (\t->Loop (t::revHtml)) |= normalParser]

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
    LCall foo bar ->
        withFreshRes gen (\gen2 var->
        eval gen2 scope foo |> Result.andThen (\(gen3, foo2)->
        eval gen3 scope bar |> Result.andThen (\(gen4, bar2)->
        case foo2 of
            LLambda v e -> 
                let (v2, e2) = (Debug.log "" ("x_"++var), Debug.log "" (rename v ("x_"++var) (beta scope e))) in
                eval gen4 (Dict.insert v2 (Debug.log "" bar2) scope) e2
            _ -> Err "calling nonfunction!")))
    LLambda v e -> 
        Ok <| withFresh gen (\gen2 var->
        (gen2, LLambda ("x_"++var) (rename v ("x_"++var) (beta scope e))))
    _ -> Ok (gen, expr)

beta :Dict.Dict String Expr -> Expr -> Expr
beta scope expr = case expr of
    LVar v -> Maybe.withDefault expr (Dict.get v scope)
    LCall foo bar -> LCall (beta scope foo) (beta scope bar)
    LLambda v e -> LLambda v (beta scope e)
    _ -> expr

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
    LLambda v e -> "λ" ++ v ++ "." ++ toString e
    LCall foo bar -> "(" ++ toString foo ++ ")(" ++ toString bar ++ ")"

go : String -> String
go code = run (parseExpr |. end) code |> Result.mapError (\_->"parse error!") |> Result.andThen (\expr -> eval (Gen 0) Dict.empty expr) |> Result.map (\(gen, x)->toString x) |> resToString