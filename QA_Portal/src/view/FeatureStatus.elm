module FeatureStatus exposing (..)

import Html exposing (Html, li, td, text, th, thead, tr, ul)
import Html.Attributes exposing (class, classList, style, title)
import Html.Events exposing (onClick)
import Model exposing (Model)
import Msg exposing (Msg)
import UserStory


featureStatusTable : Model -> UserStory.Result -> Html Msg
featureStatusTable { selectedTeam } { feature, formattedID, owner, createdAt, name } =
    tr
        [ class "system-sans-serif f7" ]
        [ td [ class "m0 pl3 pa2 truncate mw4", title selectedTeam ] [ text selectedTeam ]
        , td
            [ class "m0 pl3 truncate mw4"
            , title
                (case feature of
                    Just a ->
                        a.formattedID

                    _ ->
                        formattedID
                )
            ]
            [ text
                (case feature of
                    Just a ->
                        a.formattedID

                    _ ->
                        formattedID
                )
            ]
        , td [ class "m0 pl3 truncate mw4", title owner.refObjectName ] [ text owner.refObjectName ]
        , td [ class "m0 pl3 truncate mw4", title createdAt ] [ text createdAt ]
        , td [ class "m0 pl3 truncate mw4", title name ] [ text name ]
        , td
            [ class "m0 pl3 truncate mw4"
            , title
                (case feature of
                    Just a ->
                        a.c_PriorityTier

                    _ ->
                        ""
                )
            ]
            [ text
                (case feature of
                    Just a ->
                        a.c_PriorityTier

                    _ ->
                        ""
                )
            ]
        , td
            [ class "m0 pl3 truncate mw4"
            , title
                (case feature of
                    Just a ->
                        a.c_ReleaseTrainBoardingStatus

                    _ ->
                        ""
                )
            ]
            [ text
                (case feature of
                    Just a ->
                        a.c_ReleaseTrainBoardingStatus

                    _ ->
                        ""
                )
            ]
        , td [ class "m0 pl3 truncate mw4" ]
            [ text <|
                String.append
                    (toString <|
                        case feature of
                            Just a ->
                                a.percentDoneByStoryCount * 100

                            _ ->
                                0
                    )
                    "%"
            ]
        , td [ class "m0 pl3 truncate mw4" ]
            [ text <|
                toString <|
                    case feature of
                        Just a ->
                            a.directChildrenCount

                        _ ->
                            0
            ]
        ]


featureStatusTableHeader : Model -> Html Msg
featureStatusTableHeader model =
    thead
        [ class "system-sans-serif f7 bg-white"

        -- , onClick <| Msg.GetRelease ""
        , style
            [ ( "color", "#5A5A5A" )
            , ( "font-weight", "100" )
            ]
        ]
        [ tr []
            [ th
                [ class "tl pa2 pl3 w-10 arrow"
                , style [ ( "min-width", "8em" ) ]
                ]
                [ text "TEAM"
                , ul [ classList [ ( "dn", model.sortCategory /= "TEAM" ) ] ]
                    [ li [] [ text "Ascending" ]
                    , li [] [ text "Descinding" ]
                    ]
                ]
            , th
                [ class "tl pa2 pl3 w-10 arrow"
                , style [ ( "min-width", "8em" ) ]
                ]
                [ text "FEATURE" ]
            , th
                [ class "tl pa2 pl3 w-10 arrow"
                , style [ ( "min-width", "10em" ) ]
                ]
                [ text "OWNER" ]
            , th
                [ class "tl pa2 pl3 w-10"
                , style [ ( "min-width", "10em" ) ]
                ]
                [ text "CREATED" ]
            , th
                [ class "tl pa2 pl3 w-10"
                , style [ ( "min-width", "10em" ) ]
                ]
                [ text "DESCRIPTION" ]
            , th
                [ class "tl pa2 pl3 w-15"
                , style [ ( "min-width", "10em" ) ]
                ]
                [ text "PRIORITY TIER" ]
            , th
                [ class "tl pa2 pl3 w-20"
                , style [ ( "min-width", "10em" ) ]
                ]
                [ text "RELEASE TRAIN BOARDING STATUS" ]
            , th
                [ class "tl pa2 pl3 w-10"
                , style [ ( "min-width", "10em" ) ]
                ]
                [ text "COMPLETED" ]
            , th
                [ class "tl pa2 pl3 w-10"
                , style [ ( "min-width", "12em" ) ]
                ]
                [ text "STORIES " ]
            ]
        ]
