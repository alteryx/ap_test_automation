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
        , WebSocket.listen "ws://localhost:1234/qaportal/releases" (getRelease model)
        ]


parseGetUserStory : String -> Msg.Msg
parseGetUserStory jsonString =
    case Json.Decode.decodeString UserStory.decodeUserStory jsonString of
        Ok userStory ->
            Msg.GetUserStory userStory

        Err msg ->
            Msg.FailedToParseUserStory msg


getRelease model list =
    Msg.GetRelease list



-- parseRelease : String -> Msg.Msg
-- parseRelease jsonString =
--     case Json.Decode.decodeString UserStory.decodeRelease jsonString of
--         Ok release ->
--             Msg.GetRelease release
--         Err msg ->
--             Msg.FailedToParseRelease msg
