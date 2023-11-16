module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Parser exposing (..)
import Result exposing (Result(..))
import Char exposing (isDigit)
import Lang

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
        , if model.output == "" then text "" else div [] (Lang.go model.output |> run parseOutput |> Result.withDefault [text "internal parser error!"] |> (\l->[strong [] [text "output "], text " (variables may be renamed): ", div [style "margin" "4pt 2pt", style "font-size" "15pt", style "font-family" "FreeMono, monospace"] l]))
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


standing : String
standing = """
  0
 /|\\
/ | \\
 / \\
|   |
"""