module Subscriptions exposing (..)

import Json.Decode
import Model
import Msg
import Update exposing (formatString)
import UserStory
import WebSocket


subscriptions : Model.Model -> Sub Msg.Msg
subscriptions model =
    Sub.batch
        [ WebSocket.listen (formatString model.selected) parseGetUserStory
        , WebSocket.listen "ws://localhost:1234/qaportal/mergedtoitb/update" parseGetUserStory
        , WebSocket.listen "ws://localhost:1234/qaportal/mergedtocrt/update" parseGetUserStory
        ]


parseGetUserStory : String -> Msg.Msg
parseGetUserStory jsonString =
    case Json.Decode.decodeString UserStory.decodeUserStory jsonString of
        Ok userStory ->
            Msg.GetUserStory userStory

        Err msg ->
            Msg.FailedToParseUserStory msg
