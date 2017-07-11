module MergeInfo exposing (..)

import DefectStatus exposing (defectStatusTable, defectStatusTableHeader)
import FeatureStatus exposing (featureStatusTable, featureStatusTableHeader)
import Html exposing (Html, div, option, select, span, table, tbody, text)
import Html.Attributes exposing (class, classList, style)
import MergedToITB exposing (..)
import Model exposing (Model)
import Msg exposing (Msg)
import Pagination exposing (itemsPerPageSelector, pagerButtons, paginatedButtonView)
import Portal exposing (onChange)
import ReadyToMerge exposing (..)
import SearchInput exposing (searchInput)
import Tabs exposing (tabs)


mergeInfo : Model -> Html Msg
mergeInfo model =
    div
        [ class "bg-white ml4 fl merge-shadow mt3 mr3 h-100"
        , style
            [ ( "width", "98.6%" ) ]
        ]
        [ tabs model
        , div [ class "merge-info pt4" ]
            [ div [ class "h1 pl4" ]
                [ span
                    [ class "dib resize fr relative"
                    , style
                        [ ( "background-image", "url(../assets/resize-full-screen.png" )
                        , ( "background-repeat", "no-repeat" )
                        , ( "background-position", "50% 50%" )
                        , ( "background-size", "13px" )
                        , ( "width", "13px" )
                        , ( "cursor", "pointer" )
                        , ( "height", "13px" )
                        , ( "top", "-40px" )
                        , ( "left", "-34px" )
                        ]
                    ]
                    []
                , select
                    [ class "dib w5 pa2 relative outline-0 bn br0"
                    , onChange Msg.SetSelectedTeam
                    , style
                        [ ( "background-color", "#efefef" )
                        , ( "background-image", "url(../assets/chevron-small-down.png)" )
                        , ( "background-repeat", "no-repeat" )
                        , ( "background-position", "90% 52%" )
                        , ( "cursor", "pointer" )
                          -- , ( "-webkit-appearance", "none" )
                          -- , ( "-moz-appearance", "none" )
                          -- , ( "text-indent", "8px" )
                          -- , ( "text-overflow", "" )
                        , ( "background-size", "10px" )
                        , ( "top", "-12px" )
                        ]
                    ]
                    (List.map
                        (\teamName ->
                            option
                                [ class "pr4"
                                ]
                                [ text teamName ]
                        )
                        model.listOfTeams
                    )
                , itemsPerPageSelector
                , searchInput model
                ]
            , div
                [ class "table-container relative ml4 fl mt3"
                , style
                    [ ( "width", "94.3%" )
                    , ( "border-top", "1px solid #eee" )
                    , ( "overflow-x", "auto" )
                    ]
                ]
                [ table []
                    [ div [ classList [ ( "dn", model.selected /= "Ready to Merge" ) ] ]
                        [ readyToMergeTableHeader model
                        , paginatedButtonView model model.paginated
                        ]
                    , div [ classList [ ( "dn", model.selected /= "Merged to ITB" ) ] ]
                        [ mergedToITBTableHeader model
                        , paginatedButtonView model model.paginated
                        ]
                    , div [ classList [ ( "dn", model.selected /= "Defect Status" ) ] ]
                        [ defectStatusTableHeader model
                        , paginatedButtonView model model.paginated
                        ]
                    , div [ classList [ ( "dn", model.selected /= "Feature Status" ) ] ]
                        [ featureStatusTableHeader model
                        , paginatedButtonView model model.paginated
                        ]
                    ]
                ]
            ]
        , pagerButtons model.paginated
        ]
