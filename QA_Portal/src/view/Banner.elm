module Banner exposing (banner)

import Model exposing (..)
import Html exposing (..)
import Msg exposing (..)
import Html.Attributes exposing (..)


banner : Model -> Html Msg
banner model =
    div
        [ class "banner bg-white h3"
        , style
            [ ( "background-image", "url(../assets/alteryx_QA_portal_logo.png" )
            , ( "background-repeat", "no-repeat" )
            , ( "background-position", "right" )
            , ( "background-size", "275px" )
            , ( "margin", "12px 0px 12px 15px" )
            , ( "width", "275px" )
            , ( "height", "40px" )
            ]
        ]
        []
