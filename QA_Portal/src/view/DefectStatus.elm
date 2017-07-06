module DefectStatus exposing (..)

import Html exposing (tr, td, thead, text, Html, th)
import Html.Attributes exposing (class, style)
import Msg exposing (Msg)
import Model exposing (Model)
import UserStory


defectStatusTable : Model -> UserStory.Result -> Html Msg
defectStatusTable model result =
    tr
        [ class "system-sans-serif f7" ]
        [ td
            [ class "m0 pl3 pa2 truncate"
            , style [ ( "min-width", "8em" ) ]
            ]
            [ text model.selectedTeam ]
        , td [ class "m0 pl3 truncate" ] [ text result.formattedID ]
        , td [ class "m0 pl3 truncate" ] [ text result.owner.refObjectName ]
        , td [ class "m0 pl3 truncate" ] [ text "string" ]
        , td [ class "m0 pl3 truncate" ] [ text "string" ]
        , td
            [ class "m0 pl3 truncate"
            , style [ ( "min-width", "16em" ) ]
            ]
            [ text result.description ]
        , td [ class "m0 pl3 truncate" ] [ text "string" ]
        ]


defectStatusTableHeader : Model -> Html Msg
defectStatusTableHeader model =
    thead
        [ class "system-sans-serif f7 bg-white"
        , style
            [ ( "color", "#5A5A5A" )
            , ( "font-weight", "100" )
            ]
        ]
        [ tr []
            [ th [ class "tl pa2 pl3 w4 arrow" ] [ text "TEAM" ]
            , th [ class "tl pa2 pl3 arrow", style [ ( "width", "12em" ) ] ] [ text "STORY/DEFECT" ]
            , th [ class "tl pa2 pl3 w3 arrow" ] [ text "OWNER" ]
            , th [ class "tl pa2 pl3 w4" ] [ text "CREATED" ]
            , th [ class "tl pa2 pl3 w5" ] [ text "SOURCE" ]
            , th [ class "tl pa2 pl3 w5" ] [ text "DESCRIPTION" ]
            , th [ class "tl pa2 pl3 w4" ] [ text "SEVERITY" ]
            ]
        ]
