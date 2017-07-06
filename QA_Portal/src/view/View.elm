module View exposing (..)

import Model exposing (Model)
import Msg exposing (Msg)
import Html exposing (div, text, Html)
import Html.Attributes exposing (class, style)
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
