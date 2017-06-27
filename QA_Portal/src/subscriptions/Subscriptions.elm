module Subscriptions exposing (..)

import WebSocket
import Msg exposing (..)
import Model exposing (..)
import UserStory exposing (..)
import Json.Decode exposing (..)
import Update exposing (formatString)


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen (formatString model.selected) parseGetUserStory
    


parseGetUserStory : String -> Msg
parseGetUserStory jsonString =
    case decodeString decodeUserStory jsonString of
        Ok userStory ->
            GetUserStory userStory

        Err msg ->
            FailedToParseUserStory msg
