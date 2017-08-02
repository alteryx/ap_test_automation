module MergedToITB exposing (..)

import Html exposing (Html, input, label, td, text, th, thead, tr)
import Html.Attributes exposing (checked, class, style, title, type_)
import Html.Events exposing (onClick)
import Model exposing (Model)
import Msg exposing (Msg)
import UserStory


mergedToITBTable : Model -> UserStory.Result -> Html Msg
mergedToITBTable { selectedTeam, mergeAllCRT } { formattedID, owner, c_TestingStatus, blocked, blockedReason, ref } =
    tr
        [ class "system-sans-serif f7" ]
        [ td [ class "m0 pl3 pa2 truncate", title selectedTeam ] [ text selectedTeam ]
        , td [ class "m0 pl3 truncate", title formattedID ]
            [ text formattedID ]
        , td
            [ style
                [ ( "padding-left", "3em" )
                , ( "min-width", "3em" )
                ]
            ]
            [ input [ checked mergeAllCRT, onClick (Msg.MergeToCRT ref), type_ "checkbox" ] [] ]
        , td [ class "m0 pl3 truncate", title owner.refObjectName ] [ text owner.refObjectName ]
        , td [ class "m0 pl3 truncate", title c_TestingStatus ] [ text c_TestingStatus ]
        , td [ class "m0 pl3 truncate", title <| toString blocked ] [ text <| toString blocked ]
        , td [ class "m0 pl3 truncate", title blockedReason ] [ text blockedReason ]
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
            [ th [ class "tl pa2 pl3 arrow w-10", style [ ( "min-width", "12em" ) ] ] [ text "TEAM" ]
            , th [ class "tl pa2 pl3 arrow w-10", style [ ( "min-width", "12em" ) ] ] [ text "STORY/DEFECT" ]
            , th [ class "tl pa2 pl3 w-10", style [ ( "min-width", "12em" ) ] ]
                [ text "READY FOR CRT"
                , input [ checked model.mergeAllCRT, class "ml2 mr2 merge-all", type_ "checkbox", onClick Msg.MergeAllCRT ] []
                , label [] [ text "Select All" ]
                ]
            , th [ class "tl pa2 pl3 arrow w-10", style [ ( "min-width", "14em" ) ] ] [ text "OWNER" ]
            , th [ class "tl pa2 pl3 w-15", style [ ( "min-width", "12em" ) ] ] [ text "TEST STATUS" ]
            , th [ class "tl pa2 pl3 w-10", style [ ( "min-width", "12em" ) ] ] [ text "BLOCKED" ]
            , th [ class "tl pa2 pl3 w-15", style [ ( "min-width", "10em" ) ] ] [ text "BLOCKED REASON" ]
            ]
        ]
