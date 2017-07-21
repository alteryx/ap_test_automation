module Pagination exposing (..)

import Debug
import FeatureStatus exposing (featureStatusTable, featureStatusTableHeader)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Keyed as Keyed
import ITBDefects exposing (itbDefectsTable, itbDefectsTableHeader)
import MergedToITB exposing (mergedToITBTable, mergedToITBTableHeader)
import Model exposing (..)
import Msg exposing (..)
import Paginate exposing (..)
import Random
import ReadyToMerge exposing (readyToMergeTable, readyToMergeTableHeader)
import UserStory exposing (UserStory)


filterAndSortThings : Model -> PaginatedList UserStory.Result
filterAndSortThings model =
    let
        sort =
            if model.reversed then
                List.reverse
            else
                identity

        filter =
            if model.query == "" then
                identity
            else
                List.filter (\thing -> String.contains model.query (toString thing))
    in
    Paginate.map (filter >> sort) model.paginated


itemsPerPageSelector : Html Msg
itemsPerPageSelector =
    div [ class "dib relative ml5", style [ ( "top", "-11px" ), ( "paddingLeft", "18px" ) ] ]
        [ text "Show"
        , select
            [ class "dib w3 pa2 relative outline-0 br0 ma1 bn"
            , onInput ChangePageSize
            , style
                [ ( "background-color", "rgb(239, 239, 239)" )
                , ( "background-color", "#efefef" )
                , ( "background-image", "url(../assets/chevron-small-down.png)" )
                , ( "background-repeat", "no-repeat" )
                , ( "background-position", "76% 52%" )
                , ( "cursor", "pointer" )
                , ( "background-size", "10px" )
                ]
            ]
            [ option [ value "5" ] [ text "5" ]
            , option [ value "10" ] [ text "10" ]
            , option [ value "20" ] [ text "20" ]
            , option [ value "30" ] [ text "30" ]
            ]
        , text "items per page"
        ]


paginatedButtonView : Model -> PaginatedList UserStory.Result -> Html Msg
paginatedButtonView model filteredSortedThings =
    let
        itemView model result =
            case model.selected of
                "Ready to Merge" ->
                    ( result.ref, readyToMergeTable model result )

                "Merged to ITB" ->
                    ( result.ref, mergedToITBTable model result )

                "ITB Defects" ->
                    ( result.ref, itbDefectsTable model result )

                "Feature Status" ->
                    ( result.ref, featureStatusTable model result )

                _ ->
                    ( result.ref, div [] [] )
    in
    Keyed.node "tbody"
        []
        (List.map (itemView model) <| Paginate.page filteredSortedThings)


pagerButtonView index isActive =
    button
        [ class "dib w2 pa2 relative outline-0 br0 ma1"
        , style
            [ ( "font-weight"
              , if isActive then
                    "bold"
                else
                    "normal"
              )
            ]
        , onClick <| GoTo index
        ]
        [ text <| toString index ]


prevButtons filteredSortedThings =
    [ button [ class "dib w2 pa2 relative outline-0 br0 ma1", onClick First, disabled <| Paginate.isFirst filteredSortedThings ] [ text "<<" ]
    , button [ class "dib w2 pa2 relative outline-0 br0 ma1", onClick Prev, disabled <| Paginate.isFirst filteredSortedThings ] [ text "<" ]
    ]


nextButtons filteredSortedThings =
    [ button [ class "dib w2 pa2 relative outline-0 br0 ma1", onClick Next, disabled <| Paginate.isLast filteredSortedThings ] [ text ">" ]
    , button [ class "dib w2 pa2 relative outline-0 br0 ma1", onClick Last, disabled <| Paginate.isLast filteredSortedThings ] [ text ">>" ]
    ]


pagerButtons filteredSortedThings =
    span [ class "paging-btns tc" ] <|
        []
            ++ prevButtons filteredSortedThings
            ++ [ span [] <| Paginate.pager pagerButtonView filteredSortedThings ]
            ++ nextButtons filteredSortedThings
