module Subscriptions exposing (..)

import WebSocket
import Msg
import Model
import UserStory
import Json.Decode
import Update exposing (formatString)


subscriptions : Model.Model -> Sub Msg.Msg
subscriptions model =
    WebSocket.listen (formatString model.selected) parseGetUserStory


parseGetUserStory : String -> Msg.Msg
parseGetUserStory jsonString =
    case Json.Decode.decodeString UserStory.decodeUserStory jsonString of
        Ok userStory ->
            Msg.GetUserStory userStory

        Err msg ->
            Msg.FailedToParseUserStory msg
