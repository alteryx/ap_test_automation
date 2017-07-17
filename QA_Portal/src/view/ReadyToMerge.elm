module ReadyToMerge exposing (..)

import Html exposing (Html, a, div, input, li, td, text, th, thead, tr, ul)
import Html.Attributes exposing (class, classList, href, style, type_)
import Html.Events exposing (onClick)
import Model exposing (Model)
import Msg exposing (Msg)
import UserStory


readyToMergeTable : Model -> UserStory.Result -> Html Msg
readyToMergeTable model result =
    tr
        [ class "system-sans-serif f7" ]
        [ td
            [ class "m0 pl3 pa2 truncate mw4"
            , style [ ( "min-width", "8em" ) ]
            ]
            [ text model.selectedTeam ]
        , td
            [ class "m0 pl3 truncate mw4"
            , style [ ( "min-width", "8em" ) ]
            ]
            [ text result.formattedID ]
        , td
            [ class "m0 pl3 truncate mw4"
            , style [ ( "min-width", "8em" ) ]
            ]
            [ text result.owner.refObjectName ]
        , td
            [ class "m0 pl3 truncate mw3"
            , style [ ( "min-width", "4em" ) ]
            ]
            [ a [ href result.changesets.ref ] [ text "click here" ] ]
        , td
            [ class "m0 pl3 truncate mw5"
            , style [ ( "min-width", "16em" ) ]
            ]
            [ text result.name ]
        , td
            [ style
                [ ( "padding-left", "3em" )
                , ( "min-width", "3em" )
                ]
            ]
            [ input [ type_ "checkbox", onClick (Msg.MergeToITB result.ref) ] [] ]
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
                [ text "STORY/DEFECT" ]
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
                [ text "MERGED" ]
            ]
        ]
