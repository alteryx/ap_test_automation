module Portal exposing (onChange, add)

import Html exposing (Html)
import Html.Events
import Json.Decode
import Msg exposing (Msg)


selectedTeamDecoder : Json.Decode.Decoder Msg
selectedTeamDecoder =
    Json.Decode.map Msg.SetSelectedTeam Html.Events.targetValue


onChange : (String -> msg) -> Html.Attribute msg
onChange tagger =
    Html.Events.on "change" (Json.Decode.map tagger Html.Events.targetValue)


add : number -> number -> number
add x y =
    x + y
