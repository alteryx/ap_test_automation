module Tabs exposing (tabs)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import Msg exposing (..)


tab : Model -> String -> Html Msg
tab model tabName =
    span
        [ classList
            [ ( "pb3 pa4 pointer ", True )
            , ( "tab-focused", model.selected == tabName )
            ]
        , onClick (SetActive tabName)
        ]
        [ text tabName ]


tabs : Model -> Html Msg
tabs model =
    div
        [ class "tabs-container mt3 mb4 f6"
        , style [ ( "color", "#D0D0D0" ) ]
        ]
        (List.map (tab model) model.tabs)
