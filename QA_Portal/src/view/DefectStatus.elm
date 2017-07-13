module DefectStatus exposing (defectStatusTable, defectStatusTableHeader)

import Html exposing (Html, td, text, th, thead, tr)
import Html.Attributes exposing (class, style)
import Model exposing (Model)
import Msg exposing (Msg)
import UserStory


defectStatusTable : Model -> UserStory.Result -> Html Msg
defectStatusTable model result =
    tr
        [ class "system-sans-serif f7" ]
        [ td [ class "m0 pl3 pa2 truncate mw4" ] [ text model.selectedTeam ]
        , td [ class "m0 pl3 truncate mw4" ] [ text result.formattedID ]
        , td [ class "m0 pl3 truncate mw4" ] [ text result.owner.refObjectName ]
        , td [ class "m0 pl3 truncate mw4" ] [ text result.createdAt ]
        , td [ class "m0 pl3 truncate mw4" ] [ text result.c_DefectSource ]
        , td [ class "m0 pl3 truncate mw4" ] [ text result.name ]
        , td [ class "m0 pl3 truncate mw4" ] [ text result.severity ]
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
            [ th [ class "tl pa2 pl3 arrow", style [ ( "width", "8%" ) ] ] [ text "TEAM" ]
            , th [ class "tl pa2 pl3 arrow", style [ ( "width", "8%" ) ] ] [ text "STORY/DEFECT" ]
            , th [ class "tl pa2 pl3 arrow", style [ ( "width", "12%" ) ] ] [ text "OWNER" ]
            , th [ class "tl pa2 pl3", style [ ( "width", "11%" ) ] ] [ text "CREATED" ]
            , th [ class "tl pa2 pl3", style [ ( "width", "14%" ) ] ] [ text "SOURCE" ]
            , th [ class "tl pa2 pl3 truncate", style [ ( "width", "21%" ) ] ] [ text "DESCRIPTION" ]
            , th [ class "tl pa2 pl3", style [ ( "width", "14%" ) ] ] [ text "SEVERITY" ]
            ]
        ]
