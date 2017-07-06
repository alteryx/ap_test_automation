module Banner exposing (banner)

import Model exposing (Model)
import Html exposing (Html, div)
import Msg exposing (Msg)
import Html.Attributes exposing (class, style)


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
