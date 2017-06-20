module MergedToITB exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Msg exposing (..)
import Model exposing (..)
import UserStory


mergedToITBTable : Model -> UserStory.Result -> Html Msg
mergedToITBTable model result =
    tr
        [ class "system-sans-serif f7" ]
        [ td [ class "m0 pl3 pa2 truncate" ] [ text model.selectedTeam ]
        , td [ class "m0 pl3 truncate" ] [ text result.formattedID ]
        , td [ class "m0 pl3 truncate" ] [ text result.owner.refObjectName ]
        , td [ class "m0 pl3 truncate" ] [ text "string" ]
        , td [ class "m0 pl3 truncate" ] [ text "string" ]
        , td [ class "m0 pl3 truncate" ] [ text "string" ]
        , td [ class "m0 pl3 truncate" ] [ text "string" ]
        , td [ style [ ( "padding-left", "4em" ) ] ] [ input [ type_ "checkbox" ] [] ]
        ]


mergedToITBTableHeader : Model -> Html Msg
mergedToITBTableHeader model =
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
            , th [ class "tl pa2 pl3 w5" ] [ text "ITB QA" ]
            , th [ class "tl pa2 pl3 w4" ] [ text "STATUS" ]
            , th [ class "tl pa2 pl3 w4" ] [ text "DEFECTS FILED" ]
            , th [ class "tl pa2 pl3 w4" ] [ text "TASK" ]
            , th [ class "tl pa2 pl3 w4" ] [ text "AUTOMATION" ]
            ]
        ]
