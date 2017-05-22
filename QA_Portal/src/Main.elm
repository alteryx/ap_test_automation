module Main exposing (..)

import Portal exposing (..)
import Html
import TimeTravel.Html as TimeTravel


--uncomment if needed -- import Html.App as App
-- main : Program Never Model Msg


main =
    -- TimeTravel.program
    Html.program
        -- Platform.program
        { init = Portal.init
        , view = Portal.view
        , update = Portal.update
        , subscriptions = Portal.subscriptions
        }
