port module Ports exposing (..)


port grabStory : String -> Cmd msg


port sendStory : (List String -> msg) -> Sub msg
