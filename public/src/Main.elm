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
update msg model = case msg of
    Unit -> {}

view : Model -> Html Update
view _ = div [] [ 
        div [] [text "hello elm!"]
    ]
