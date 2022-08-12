module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

main : Program () Model Update
main = Browser.sandbox { 
      init = init
    , view = view
    , update = update
    }

type alias Model = {}

init : Model
init = {}

type Update = Unit

update : Update -> Model -> Model
update msg _ = case msg of
    Unit -> {}

view : Model -> Html Update
view _ = div [] 
    [ nav [] 
        [ text "Ryan Brewer" 
        ]
    , text "hello elm"
    ]
