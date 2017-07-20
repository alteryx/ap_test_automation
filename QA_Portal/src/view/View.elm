module View exposing (..)

import Banner exposing (banner)
import Card exposing (card)
import Html exposing (Html, div, text)
import Html.Attributes exposing (class, style)
import MergeInfo exposing (mergeInfo)
import Model exposing (Model)
import Msg exposing (Msg)
import Navigation exposing (navigation)


view : Model -> Html Msg
view model =
    div [ class "outer-container" ]
        [ banner model
        , div [ class "container aliceblue" ]
            [ navigation model
            , div [ class "card-holder w-80 fl ml4 h-25 mt3" ]
                (List.map card model.cards)
            , div
                [ class "merge-info-container mt2 fl ml2 w-80"
                , style [ ( "height", "67%" ) ]
                ]
                [ mergeInfo model
                ]
            , div [] [ text model.sortCategory ]
            ]
        ]
