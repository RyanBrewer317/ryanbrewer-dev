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
        , textarea [ placeholder "Write some lambda calculus code! Example: (\\x.\\y.x)(\\x.x)", onInput NewCode ] []
        , br [] []
        , text (run parseExpr model.output |> Result.mapError (\_->"") |> Result.andThen (\expr -> eval Dict.empty expr) |> Result.map (toString) |> Result.withDefault "parsing error!")
        ]
    ]

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
parseExpr = parseLiteral |> andThen (\expr->
        Parser.loop expr (\lit->
            oneOf 
                [ Parser.map (LCall lit) (parenthetical (lazy (\_->parseExpr))) 
                    |. spaces
                    |> Parser.map Loop
                , succeed lit 
                    |. spaces
                    |> Parser.map Done
                ]
        )
    )

eval : Dict.Dict String Expr -> Expr -> Result String Expr
eval scope ast = case ast of
    LVar v -> Result.fromMaybe (v ++ " used out of scope!") <| Dict.get v scope
    LCall foo bar -> 
        case foo of
            LLambda v e -> eval (Dict.insert v bar scope) e
            _ -> Err "calling nonfunction!"
    LLambda v e -> Ok <| LLambda v (sub scope e)
    _ -> Ok ast

sub : Dict.Dict String Expr -> Expr -> Expr
sub scope expr = case expr of
    LVar v -> Maybe.withDefault expr (Dict.get v scope)
    LCall foo bar -> LCall (sub scope foo) (sub scope bar)
    LLambda v e -> LLambda v (sub scope e)
    _ -> expr

toString : Expr -> String
toString expr = case expr of
    LVar v -> v
    LInt i -> String.fromInt i
    LLambda v e -> "\\" ++ v ++ "." ++ toString e
    LCall foo bar -> "(" ++ toString foo ++ ")(" ++ toString bar ++ ")"