module FeatureStatus exposing (..)

import Html exposing (Html, tr, td, thead, text, th, ul, li)
import Html.Attributes exposing (class, style, classList)
import Model exposing (Model)
import Msg exposing (Msg)
import UserStory


featureStatusTable : Model -> UserStory.Result -> Html Msg
featureStatusTable model result =
    tr
        [ class "system-sans-serif f7" ]
        [ td [ class "m0 pl3 pa2 truncate" ] [ text model.selectedTeam ]
        , td [ class "m0 pl3 truncate" ] [ text "string" ]
        , td [ class "m0 pl3 truncate" ] [ text result.owner.refObjectName ]
        , td [ class "m0 pl3 truncate" ] [ text "string" ]
        , td [ class "m0 pl3 truncate" ] [ text result.description ]
        , td [ class "m0 pl3 truncate" ] [ text "string" ]
        ]


featureStatusTableHeader : Model -> Html Msg
featureStatusTableHeader model =
    thead
        [ class "system-sans-serif f7 bg-white"
        , style
            [ ( "color", "#5A5A5A" )
            , ( "font-weight", "100" )
            ]
        ]
        [ tr []
            [ th
                [ class "tl pa2 pl3 w-10 arrow"
                , style [ ( "min-width", "12em" ) ]
                ]
                [ text "TEAM"
                , ul [ classList [ ( "dn", model.sortCategory /= "TEAM" ) ] ]
                    [ li [] [ text "Ascending" ]
                    , li [] [ text "Descinding" ]
                    ]
                ]
            , th
                [ class "tl pa2 pl3 w-15 arrow"
                , style [ ( "min-width", "12em" ) ]
                ]
                [ text "FEATURE" ]
            , th
                [ class "tl pa2 pl3 w-10 arrow"
                , style [ ( "min-width", "11em" ) ]
                ]
                [ text "OWNER" ]
            , th
                [ class "tl pa2 pl3 w-20"
                , style [ ( "min-width", "16em" ) ]
                ]
                [ text "CREATED" ]
            , th
                [ class "tl pa2 pl3 w-20"
                , style [ ( "min-width", "20em" ) ]
                ]
                [ text "DESCRIPTION" ]
            , th
                [ class "tl pa2 pl3 w-10"
                , style [ ( "min-width", "16em" ) ]
                ]
                [ text "COMPLETED" ]
            ]
        ]
