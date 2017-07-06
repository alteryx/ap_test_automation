module Update exposing (update, formatString)

import Model exposing (Model)
import Msg exposing (Msg)
import WebSocket


formatString : String -> String
formatString string =
    String.split " " string
        |> String.join ""
        |> String.append "ws://localhost:1234/qaportal/"
        |> String.toLower


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg.SetActive tabName ->
            ( { model | selected = tabName }, Cmd.none )

        Msg.ChooseSortOrder category ->
            ( { model | sortCategory = category }, Cmd.none )

        Msg.GetUserStory userStory ->
            ( { model | userStory = userStory }, Cmd.none )

        Msg.FailedToParseUserStory msg ->
            (Debug.log msg ( model, Cmd.none ))

        Msg.SetSelectedTeam string ->
            ( { model | selectedTeam = string }, WebSocket.send (formatString model.selected) string )
