module ITBDefects exposing (itbDefectsTable, itbDefectsTableHeader)

import Html exposing (Html, td, text, th, thead, tr)
import Html.Attributes exposing (class, style, title)
import Model exposing (Model)
import Msg exposing (Msg)
import UserStory


itbDefectsTable : Model -> UserStory.Result -> Html Msg
itbDefectsTable { selectedTeam } { formattedID, owner, createdAt, c_DefectSource, name, severity } =
    tr
        [ class "system-sans-serif f7" ]
        [ td [ class "m0 pl3 pa2 truncate mw4", title selectedTeam ] [ text selectedTeam ]
        , td [ class "m0 pl3 truncate mw4", title formattedID ] [ text formattedID ]
        , td [ class "m0 pl3 truncate mw4", title owner.refObjectName ] [ text owner.refObjectName ]
        , td [ class "m0 pl3 truncate mw4", title createdAt ] [ text createdAt ]
        , td [ class "m0 pl3 truncate mw4", title c_DefectSource ] [ text c_DefectSource ]
        , td [ class "m0 pl3 truncate mw4", title name ] [ text name ]
        , td [ class "m0 pl3 truncate mw4", title severity ] [ text severity ]
        ]


itbDefectsTableHeader : Model -> Html Msg
itbDefectsTableHeader model =
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
