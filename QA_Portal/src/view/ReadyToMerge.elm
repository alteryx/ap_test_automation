module ReadyToMerge exposing (..)

import Html exposing (Html, a, div, input, label, li, td, text, th, thead, tr, ul)
import Html.Attributes exposing (class, classList, downloadAs, href, style, title, type_)
import Html.Events exposing (onClick)
import Model exposing (Model)
import Msg exposing (Msg)
import UserStory


readyToMergeTable : Model -> UserStory.Result -> Html Msg
readyToMergeTable { selectedTeam } { formattedID, owner, changesets, name, ref } =
    tr
        [ class "system-sans-serif f7" ]
        [ td
            [ class "m0 pl3 pa2 truncate mw4"
            , title selectedTeam
            , style [ ( "min-width", "8em" ) ]
            ]
            [ text selectedTeam ]
        , td
            [ class "m0 pl3 truncate mw4"
            , title formattedID
            , style [ ( "min-width", "8em" ) ]
            ]
            [ text formattedID ]
        , td
            [ class "m0 pl3 truncate mw4"
            , title owner.refObjectName
            , style [ ( "min-width", "8em" ) ]
            ]
            [ text owner.refObjectName ]
        , td
            [ class "m0 pl3 truncate mw3"
            , title changesets.ref
            , style [ ( "min-width", "4em" ) ]
            ]
            [ a [ href changesets.ref ] [ text "click here" ] ]
        , td
            [ class "m0 pl3 truncate mw5"
            , title name
            , style [ ( "min-width", "16em" ) ]
            ]
            [ text name ]
        , td
            [ style
                [ ( "padding-left", "3em" )
                , ( "min-width", "3em" )
                ]
            ]
            [ input [ type_ "checkbox", onClick (Msg.MergeToITB ref) ] [] ]
        ]


readyToMergeTableHeader : Model -> Html Msg
readyToMergeTableHeader model =
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
                [ text "STORY/DEFECT"
                ]
            , th
                [ class "tl pa2 pl3 w-10 arrow"
                , style [ ( "min-width", "11em" ) ]
                ]
                [ text "OWNER" ]
            , th
                [ class "tl pa2 pl3 w-20"
                , style [ ( "min-width", "16em" ) ]
                ]
                [ text "CHANGESET NAME" ]
            , th
                [ class "tl pa2 pl3 w-20"
                , style [ ( "min-width", "20em" ) ]
                ]
                [ text "DESCRIPTION" ]
            , th
                [ class "tl pa2 pl3 w-10"
                , style [ ( "min-width", "16em" ) ]
                ]
                [ text "MERGED"
                , input [ class "ml2 mr2 merge-all", type_ "checkbox" ] []
                , label [] [ text "Merge All" ]
                ]
            ]
        ]
