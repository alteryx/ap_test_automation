module View exposing (..)

import Model exposing (..)
import Msg exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Portal exposing (..)
import Navigation exposing (navigation)
import Card exposing (card)
import Banner exposing (banner)
import MergeInfo exposing (mergeInfo)


view : Model -> Html Msg
view model =
    div [ class "outer-container" ]
        [ banner model
        , div [ class "container vh-100 relative aliceblue" ]
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
