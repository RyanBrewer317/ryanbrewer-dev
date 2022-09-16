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
        , br [] []
        , h4 [] [text "An embedded lambda calculus"]
        , p [] [text "Here's a lambda calculus implementation I made, try writing some expressions!"]
        , p [] [text "It's completely statically type-checked (via Hindley-Milner type inference) due to the decidability of type inference for the STLC."]
        , textarea 
            [ id "code"
            , placeholder "Write some lambda calculus code! Example: (\\x.\\y.x)(\\x.x)(3)"
            , onInput NewCode 
            ] []
        , br [] []
        , if model.output == "" then text "" else div [] (go model.output |> run parseOutput |> Result.withDefault [text "internal parser error!"] |> (\l->[strong [] [text "output "], text " (variables may be renamed): ", div [style "margin" "4pt 2pt", style "font-size" "15pt", style "font-family" "FreeMono, monospace"] l]))
        , p [] [text "let-binding notation in the above box is ", pre [] [text "a = b; c"], text "where the usual notation is ", pre [] [text "let a = b in c"]]
        ]
    ]

subscriptParser : Parser (Html msg)
subscriptParser = succeed identity
               |. symbol "_"
               |. chompWhile isDigit 
               |> getChompedString
               |> Parser.map (\i->Html.sub [style "font-size" "9pt", style "margin-right" "1px"] [text (String.dropLeft 1 i)])

normalParser : Parser (Html msg)
normalParser = succeed () |. chompWhile (\c->c/='_') |> getChompedString |> Parser.map text

parseOutput : Parser (List (Html msg))
parseOutput = Parser.loop [] parseOutputHelp
parseOutputHelp : List (Html msg) -> Parser (Step (List (Html msg)) (List (Html msg)))
parseOutputHelp revHtml = oneOf [succeed (\sbscrpt->Loop (sbscrpt::revHtml)) |= subscriptParser, succeed () |. end |> Parser.map (\_->Done(List.reverse revHtml)), succeed (\t->Loop (t::revHtml)) |= normalParser]

resToString : Result String String -> String
resToString res = case res of
    Ok s -> s
    Err s -> s

type Expr = LInt Int
          | LVar String
          | LLambda String Expr
          | LCall Expr Expr
          | LBinding String Expr Expr

parseInt : Parser Expr
parseInt = number {int = Just LInt, hex = Nothing, octal = Nothing, binary = Nothing, float = Nothing}

parseVar : Parser Expr
parseVar = variable {start = Char.isLower, inner = Char.isAlphaNum, reserved = Set.fromList([])} 
        |> andThen (\var->
            oneOf 
                [ succeed (LBinding var) 
                    |. spaces 
                    |. symbol "=" 
                    |= lazy (\_->parseExpr) 
                    |. symbol ";" 
                    |= lazy (\_->parseExpr)
                , succeed (LVar var)
                ])

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
          | Forall (List Type) Type

type AnnExpr = AnnVar String Type
             | AnnInt Int
             | AnnLambda String AnnExpr Type
             | AnnCall AnnExpr AnnExpr Type
             | AnnBinding String AnnExpr AnnExpr Type

type Constraint = Eq Type Type

type Subst = Subst String Type

typeToStringHelper : Type -> String
typeToStringHelper t = case t of
    TInt -> "Int"
    TLambda u v -> "(" ++ typeToStringHelper u ++ " -> " ++ typeToStringHelper v ++ ")"
    TVar n -> "some " ++ n
    Forall vars u -> case vars of
        [] -> typeToStringHelper u
        _ -> 
            let (showVars, showType, _) = List.foldr (\tvar (showvars, typ, supply)->
                    case tvar of 
                        TVar _->case supply of
                            [] -> ("ba"::showvars, sub tvar (TVar "ba") typ, [])
                            x::xs -> (x :: showvars, sub tvar (TVar x) typ, xs)
                        _->("" :: showvars, typ, supply)) ([], u, String.toList "abcdefghijklmnopqrstuvwxyz" |> List.map String.fromChar) vars in
            typeToStringHelper showType

typeToString : Type -> String
typeToString t = case t of
    Forall _ _ -> typeToStringHelper t
    _ -> typeToStringHelper <| generalize (Dict.empty) t (Forall [] t)

typecheck : Dict.Dict String Type -> Gen -> Expr -> Result String (Gen, AnnExpr, List Constraint)
typecheck scope gen expr = case expr of
    LVar v -> 
        case Dict.get v scope of
            Nothing -> Err (v ++ " used out of scope!")
            Just t -> instantiate gen t |> (\(gen2, t2)->Ok (gen2, AnnVar v t2, []))
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
    LBinding n v e -> letTypeOf scope gen v |> Result.andThen (\(scope2, gen2, annotV)->typecheck (Dict.insert n (typeOf annotV) scope2) gen2 e |> Result.map (\(gen3, annotE, eConsts)->(gen3, AnnBinding n annotV annotE (typeOf annotE), eConsts)))

typeOf : AnnExpr -> Type
typeOf ann = case ann of
    AnnVar _ t -> t
    AnnInt _ -> TInt
    AnnLambda _ _ t -> t
    AnnCall _ _ t -> t
    AnnBinding _ _ _ t -> t

occurs : Type -> Type -> Bool
occurs var t = case t of
    TVar _ -> t == var
    TInt -> False
    TLambda a b -> occurs var a || occurs var b
    Forall vars u -> List.any (\v->v==var) vars || occurs var u

solve : List Constraint -> List Subst -> List Constraint -> Result String (List Subst)
solve constraints substitutions skipped = case constraints of
    const::rest -> case const of
        Eq t1 t2 ->
            let continue = \_->solve rest substitutions (const::skipped) in
            let err = \_-> Err <| "Type error, " ++ (typeToString t1 ++ " can't be " ++ typeToString t2) ++ "!" in
            let removeAndContinue = \_->solve rest substitutions skipped in
            let handleVarIsolationAndContinue = \v->solve (substituteAll rest t2 t1) (Subst v t1::substitutions) (substituteAll skipped t2 t1) in
            if t1 == t2 then
                solve rest substitutions skipped
            else case t1 of
                TInt ->
                    case t2 of
                        TVar v -> handleVarIsolationAndContinue v
                        TInt -> removeAndContinue()
                        _ -> err()
                TLambda a b ->
                    case t2 of
                        TLambda c d -> solve (Eq a c :: Eq b d :: rest) substitutions skipped
                        TVar x -> 
                            if occurs t2 t1 then
                                err()
                            else
                                solve (substituteAll rest t2 t1) (Subst x t1::substitutions) (substituteAll skipped t2 t1)
                        _ -> err()
                TVar x ->
                    if occurs t1 t2 then
                        continue()
                    else
                        solve (substituteAll rest t1 t2) (Subst x t2::substitutions) (substituteAll skipped t1 t2)
                Forall _ _ -> Err "something went wrong, Forall found after it should be instantiated"
    [] -> if List.isEmpty skipped then Ok substitutions else solve skipped substitutions []

instantiate : Gen  -> Type -> (Gen, Type)
instantiate gen t = case t of
    TInt -> (gen, t)
    TLambda a b -> 
        let (gen2, a2) = instantiate gen a in 
        let (gen3, b2) = instantiate gen2 b in
            (gen3, (TLambda a2 b2))
    TVar _ -> (gen, t)
    Forall vars u -> List.foldr (\var (genx, typ)->withFresh genx (\genx2 v->(genx2, sub var (TVar v) typ))) (gen, u) vars

substituteAll : List Constraint -> Type -> Type -> List Constraint
substituteAll constraints var val = case constraints of
    [] -> []
    const::rest -> case const of
        Eq u v ->
            let u2 = sub var val u in
            let v2 = sub var val v in
            Eq u2 v2::substituteAll rest var val

sub : Type -> Type -> Type -> Type
sub var val t = case t of
    TVar _ -> if t == var then val else t
    TInt -> t
    TLambda a b -> TLambda (sub var val a) (sub var val b)
    Forall vars u -> Forall vars (sub var val u)

generalize : Dict.Dict String Type -> Type -> Type -> Type
generalize scope t scheme =
    case scheme of
        Forall vars typ ->
            case t of
                TVar x -> 
                    if occursInScope scope x || List.member t vars then 
                        scheme 
                    else 
                        Forall (t::vars) typ
                TInt -> scheme
                TLambda a b -> 
                    let (varsA, _) = Maybe.withDefault ([], a) <| schemeFrom <| generalize scope a scheme in 
                    let (varsB, _) = Maybe.withDefault ([], b) <| schemeFrom <| generalize scope b scheme in 
                    let set = List.foldr (\item l->if List.member item l then l else item :: l) [] (vars++varsA++varsB) in
                    Forall set typ
                Forall _ _ -> t
        _ -> Forall [] t -- this shouldn't happen...

schemeFrom : Type -> Maybe (List Type, Type)
schemeFrom t = case t of
    Forall vars u -> Just (vars, u)
    _ -> Nothing

occursInScope : Dict.Dict String Type -> String -> Bool
occursInScope scope var = Dict.toList scope |> List.any (\(_, t)->occurs (TVar var) t)

preGeneralize : Dict.Dict String Type -> List Constraint -> AnnExpr -> Result String (Dict.Dict String Type, AnnExpr)
preGeneralize scope constraints annotLoc = 
    solve constraints [] [] |> Result.map(\substitutions->
    let env = List.foldr (\(Subst x u) scop->Dict.map (\_ v->sub (TVar x) u v) scop) scope substitutions in
    let annot2 = List.foldr (\(Subst x u) annotx->updateTypes (\t->sub (TVar x) u t) annotx) annotLoc substitutions in 
    let scheme = updateType (\t->generalize scope t (Forall [] t)) annot2 in
    (env, scheme))

updateType : (Type -> Type) -> AnnExpr -> AnnExpr
updateType f ann = case ann of
    AnnInt     _ -> ann
    AnnLambda  arg bod typ -> AnnLambda arg bod (f typ)
    AnnCall    foo bar typ -> AnnCall foo bar (f typ)
    AnnVar     s t         -> AnnVar s (f t)
    AnnBinding n v e t    -> AnnBinding n v e (f t)

updateTypes : (Type -> Type) -> AnnExpr -> AnnExpr
updateTypes f ann = case ann of
    AnnInt     _ -> ann
    AnnLambda  arg bod typ -> AnnLambda arg (updateTypes f bod) (f typ)
    AnnCall    foo bar typ -> AnnCall (updateTypes f foo) (updateTypes f bar) (f typ)
    AnnVar     s t         -> AnnVar s (f t)
    AnnBinding n v e t     -> AnnBinding n (updateTypes f v) (updateTypes f e) (f t)

letTypeOf : Dict.Dict String Type -> Gen -> Expr -> Result String (Dict.Dict String Type, Gen, AnnExpr)
letTypeOf scope gen expr = typecheck scope gen expr |> Result.andThen (\(gen2, annotLoc, constraints)->preGeneralize scope constraints annotLoc|>Result.map(\(s, a)->(s, gen2, a)))

eval : Gen -> Dict.Dict String Expr -> Expr -> Result String (Gen, Expr)
eval gen scope expr = case expr of
    LVar v -> Result.fromMaybe ("internal typechecker error! (nonexistent "++v++")") <| Maybe.map (\val->(gen, val)) <| Dict.get v scope
    LCall foo bar ->
        withFreshRes gen (\gen2 var->
        eval gen2 scope foo |> Result.andThen (\(gen3, foo2)->
        eval gen3 scope bar |> Result.andThen (\(gen4, bar2)->
        case foo2 of
            LLambda v e -> 
                let (v2, e2) = ("x_"++var, rename v ("x_"++var) (beta scope e)) in
                eval gen4 (Dict.insert v2 bar2 scope) e2
            _ -> Err "internal typechecker error! (calling nonfunction)")))
    LLambda v e -> 
        Ok <| withFresh gen (\gen2 var->
        (gen2, LLambda ("x_"++var) (rename v ("x_"++var) (beta scope e))))
    LInt _ -> Ok (gen, expr)
    LBinding n v e -> eval gen scope v |> Result.andThen (\(gen2, val)->eval gen2 (Dict.insert n val scope) e)

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
    LBinding n v e -> LBinding (if n == old then new else n) (rename old new v) (rename old new e)

toString : Expr -> String
toString expr = case expr of
    LVar v -> v
    LInt i -> String.fromInt i
    LLambda v e -> "λ" ++ v ++ "." ++ toString e
    LCall foo bar -> "(" ++ toString foo ++ ")(" ++ toString bar ++ ")"
    LBinding n v e -> "internal compiler error, unevaluated binding! (let "++n++" = "++toString v++" in "++toString e++")"

go : String -> String
go code = run (parseExpr |. end) code |> Result.mapError (\_->"parse error!") |> Result.andThen (\expr -> letTypeOf Dict.empty (Gen 0) expr |> Result.andThen (\(_, gen, _)-> eval gen Dict.empty expr)) |> Result.map (\(_, x)->toString x) |> resToString
typeit : String -> Result String (Dict.Dict String Type, Gen, AnnExpr)
typeit code =run (parseExpr |. end) code |> Result.mapError (\_->"parse error!") |> Result.andThen (\expr -> letTypeOf Dict.empty (Gen 0) expr)
constraintit : String -> Result String (Gen, AnnExpr, List Constraint)
constraintit code = run (parseExpr |. end) code |> Result.mapError (\_->"parse error!") |> Result.andThen (\expr->typecheck Dict.empty (Gen 0) expr)