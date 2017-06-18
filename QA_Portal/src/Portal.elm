module Portal exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (..)
import Msg exposing (..)


selectedTeamDecoder : Json.Decode.Decoder Msg
selectedTeamDecoder =
    Json.Decode.map SetSelectedTeam Html.Events.targetValue


onChange : (String -> msg) -> Html.Attribute msg
onChange tagger =
    on "change" (Json.Decode.map tagger Html.Events.targetValue)


add : number -> number -> number
add x y =
    x + y
