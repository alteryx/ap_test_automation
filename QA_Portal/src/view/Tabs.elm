module Tabs exposing (tabs)

import Html exposing (Html, span, text, div)
import Html.Attributes exposing (classList, style, class)
import Html.Events exposing (onClick)
import Model exposing (Model)
import Msg exposing (Msg)


tab : Model -> String -> Html Msg
tab model tabName =
    span
        [ classList
            [ ( "pb3 pa4 pointer ", True )
            , ( "tab-focused", model.selected == tabName )
            ]
        , onClick (Msg.SetActive tabName)
        ]
        [ text tabName ]


tabs : Model -> Html Msg
tabs model =
    div
        [ class "tabs-container mt3 mb4 f6"
        , style [ ( "color", "#D0D0D0" ) ]
        ]
        (List.map (tab model) model.tabs)
