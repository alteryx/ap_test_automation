module Update exposing (..)

import Model exposing (..)
import Msg exposing (..)
import WebSocket


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetActive tabName ->
            ( { model | selected = tabName }, Cmd.none )

        ChooseSortOrder category ->
            ( { model | sortCategory = category }, Cmd.none )

        GetUserStory userStory ->
            ( { model | userStory = userStory }, Cmd.none )

        FailedToParseUserStory msg ->
            (Debug.log msg ( model, Cmd.none ))

        SetSelectedTeam string ->
            ( { model | selectedTeam = string }, WebSocket.send "ws://localhost:1234/qaportal" string )
