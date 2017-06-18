module Subscriptions exposing (..)

import WebSocket
import Msg exposing (..)
import Model exposing (..)
import UserStory exposing (..)
import Json.Decode exposing (..)


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen "ws://localhost:1234/qaportal" parseGetUserStory


parseGetUserStory : String -> Msg
parseGetUserStory jsonString =
    case decodeString decodeUserStory jsonString of
        Ok userStory ->
            GetUserStory userStory

        Err msg ->
            FailedToParseUserStory msg
