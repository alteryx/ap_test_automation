module Pagination exposing (..)

import DefectStatus exposing (defectStatusTable, defectStatusTableHeader)
import FeatureStatus exposing (featureStatusTable, featureStatusTableHeader)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import MergedToITB exposing (mergedToITBTable, mergedToITBTableHeader)
import Model exposing (..)
import Msg exposing (..)
import Paginate exposing (..)
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
        [ text "show"
        , select [ class "dib w3 pa2 relative outline-0 br0 ma1 bn", onInput ChangePageSize ]
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
        -- displayInfoView =
        -- div []
        -- [ div []
        -- [ text <|
        --     String.join " " <|
        --         [ "showing"
        --         , (toString <| List.length <| Paginate.page filteredSortedThings)
        --         , "of"
        --         , (toString <| Paginate.length filteredSortedThings)
        --         , "items"
        --         ]
        -- , u [ onClick <| AddItem, style [ ( "cursor", "pointer" ) ] ] [ text " (add more!)" ]
        -- ]
        -- , text <|
        --     String.join " "
        --         [ "page"
        --         , toString <| Paginate.currentPage filteredSortedThings
        --         , "of"
        --         , toString <| Paginate.totalPages filteredSortedThings
        --         ]
        -- div [] []
        -- [ text <|
        --     String.join " "
        --         [ "including"
        --         , Paginate.foldMap
        --             (List.filter (String.contains "new item") >> List.length >> toString)
        --             filteredSortedThings
        --         , "new items"
        --         ]
        -- ]
        -- ]
        -- itemView item =
        --     li []
        --         [ span [] [ text item ]
        --         , u [ onClick <| DeleteItem item, style [ ( "cursor", "pointer" ) ] ] [ text " (delete)" ]
        --         ]
        mergeInfo model list =
            table []
                [ div [ classList [ ( "dn", model.selected /= "Ready to Merge" ) ] ]
                    [ readyToMergeTableHeader model
                    , tbody []
                        (List.map (readyToMergeTable model) model.userStory.results)
                    ]
                , div [ classList [ ( "dn", model.selected /= "Merged to ITB" ) ] ]
                    [ mergedToITBTableHeader model
                    , tbody []
                        (List.map (mergedToITBTable model) model.userStory.results)
                    ]
                , div [ classList [ ( "dn", model.selected /= "Defect Status" ) ] ]
                    [ defectStatusTableHeader model
                    , tbody []
                        (List.map (defectStatusTable model) model.userStory.results)
                    ]
                , div [ classList [ ( "dn", model.selected /= "Feature Status" ) ] ]
                    [ featureStatusTableHeader model
                    , tbody []
                        (List.map (featureStatusTable model) model.userStory.results)
                    ]
                ]

        prevButtons =
            [ button [ class "dib w2 pa2 relative outline-0 br0 ma1", onClick First, disabled <| Paginate.isFirst filteredSortedThings ] [ text "<<" ]
            , button [ class "dib w2 pa2 relative outline-0 br0 ma1", onClick Prev, disabled <| Paginate.isFirst filteredSortedThings ] [ text "<" ]
            ]

        nextButtons =
            [ button [ class "dib w2 pa2 relative outline-0 br0 ma1", onClick Next, disabled <| Paginate.isLast filteredSortedThings ] [ text ">" ]
            , button [ class "dib w2 pa2 relative outline-0 br0 ma1", onClick Last, disabled <| Paginate.isLast filteredSortedThings ] [ text ">>" ]
            ]

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
    in
    div [] <|
        [ --displayInfoView
          -- button [ class "dib w4 pa2 relative outline-0 br0 ma1", onClick Reverse ] [ text "Reverse list" ]
          ul [] (List.map (mergeInfo model) <| Paginate.page filteredSortedThings)
        , span [ class "paging-btns tc" ] <|
            []
                ++ prevButtons
                ++ [ span [] <| Paginate.pager pagerButtonView filteredSortedThings ]
                ++ nextButtons
        ]



-- ++ prevButtons
-- ++ [ span [] <| Paginate.pager pagerButtonView filteredSortedThings ]
-- ++ nextButtons
