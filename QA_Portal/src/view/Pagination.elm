module Pagination exposing (..)

import Paginate exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- import UserStory exposing (UserStory)

import Model exposing (..)
import Msg exposing (..)


filterAndSortThings : Model -> PaginatedList String
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


paginatedButtonView : PaginatedList String -> Html Msg
paginatedButtonView filteredSortedThings =
    let
        displayInfoView =
            div []
                [ div []
                    [ text <|
                        String.join " " <|
                            [ "showing"
                            , (toString <| List.length <| Paginate.page filteredSortedThings)
                            , "of"
                            , (toString <| Paginate.length filteredSortedThings)
                            , "items"
                            ]
                    , u [ onClick <| AddItem, style [ ( "cursor", "pointer" ) ] ] [ text " (add more!)" ]
                    ]
                , text <|
                    String.join " "
                        [ "page"
                        , toString <| Paginate.currentPage filteredSortedThings
                        , "of"
                        , toString <| Paginate.totalPages filteredSortedThings
                        ]
                , div []
                    [ text <|
                        String.join " "
                            [ "including"
                            , Paginate.foldMap
                                (List.filter (String.contains "new item") >> List.length >> toString)
                                filteredSortedThings
                            , "new items"
                            ]
                    ]
                ]

        itemView item =
            li []
                [ span [] [ text item ]
                , u [ onClick <| DeleteItem item, style [ ( "cursor", "pointer" ) ] ] [ text " (delete)" ]
                ]

        itemsPerPageSelector =
            div []
                [ text "show"
                , select [ onInput ChangePageSize ]
                    [ option [ value "10" ] [ text "10" ]
                    , option [ value "20" ] [ text "20" ]
                    , option [ value "30" ] [ text "30" ]
                    ]
                , text "items per page"
                ]

        prevButtons =
            [ button [ onClick First, disabled <| Paginate.isFirst filteredSortedThings ] [ text "<<" ]
            , button [ onClick Prev, disabled <| Paginate.isFirst filteredSortedThings ] [ text "<" ]
            ]

        nextButtons =
            [ button [ onClick Next, disabled <| Paginate.isLast filteredSortedThings ] [ text ">" ]
            , button [ onClick Last, disabled <| Paginate.isLast filteredSortedThings ] [ text ">>" ]
            ]

        pagerButtonView index isActive =
            button
                [ style
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
            [ displayInfoView
            , itemsPerPageSelector
            , button [ onClick Reverse ] [ text "Reverse list" ]
            , input [ placeholder "Search...", onInput Find ] []
            , ul [] (List.map itemView <| Paginate.page filteredSortedThings)
            ]
                ++ prevButtons
                ++ [ span [] <| Paginate.pager pagerButtonView filteredSortedThings ]
                ++ nextButtons
