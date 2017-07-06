module Card exposing (card)

import Html exposing (div, span, text, option, select, Html)
import Html.Attributes exposing (class, selected, style)
import Msg exposing (Msg)


card : String -> Html Msg
card statusType =
    div
        [ class "bg-white dib fl h-100 card-shadow ma2"
        , style [ ( "width", "31.92%" ) ]
        ]
        [ span [ class "pa3 f4 avenir db gray" ]
            [ text statusType
            , select
                [ class "fr bn bg-white outline-0"
                , style
                    [ ( "background-image", "url(../assets/triangle-down.png)" )
                    , ( "background-repeat", "no-repeat" )
                    , ( "background-size", "8px" )
                    , ( "background-position", "95% 95%" )
                    , ( "width", "75px" )
                    , ( "cursor", "pointer" )
                    ]
                ]
                [ option [ selected True ] [ text "this week" ]
                , option [] [ text "last week" ]
                , option [] [ text "last month" ]
                , option [] [ text "last year" ]
                ]
            ]
        , div
            [ class "pb2"
            , style
                [ ( "background-image", "url(../assets/column3d-chart.svg)" )
                , ( "background-repeat", "no-repeat" )
                , ( "background-position", "center" )
                , ( "background-size", "100% 100%" )
                , ( "width", "100%" )
                , ( "height", "70%" )
                ]
            ]
            []
        ]
