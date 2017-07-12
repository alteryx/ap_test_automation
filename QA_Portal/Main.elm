module Main exposing (..)

import Html
import Init
import Subscriptions
-- import TimeTravel.Html as TimeTravel
import Update
import View


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
