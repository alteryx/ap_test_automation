module Main exposing (..)

import Html


-- import TimeTravel.Html as TimeTravel

import Init
import Update
import View
import Subscriptions


--uncomment if needed -- import Html.App as App
-- main : Program Never Model Msg


main =
    -- TimeTravel.program
    Html.program
        -- Platform.program
        { init = Init.init
        , view = View.view
        , update = Update.update
        , subscriptions = Subscriptions.subscriptions
        }
