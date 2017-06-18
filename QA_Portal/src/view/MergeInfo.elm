module MergeInfo exposing (..)

import Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Msg exposing (..)
import Tabs exposing (tabs)
import Portal exposing (..)
import FeatureStatus exposing (..)
import DefectStatus exposing (defectStatusTable, defectStatusTableHeader)
import ReadyToMerge exposing (..)
import SearchInput exposing (searchInput)
import MergedToITB exposing (..)


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
                    , onChange SetSelectedTeam
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
                , searchInput model
                ]
            , div
                [ class "table-container relative ml4 fl mt3"
                , style
                    [ ( "width", "94.3%" )
                    , ( "border-top", "1px solid #eee" )
                    ]
                ]
                [ table []
                    [ div [ classList [ ( "dn", model.selected /= "Ready to Merge" ) ] ]
                        [ readyToMergeTableHeader model
                        , tbody []
                            (List.map (readyToMergeTable model) model.userStory.results)
                        ]
                    , div [ classList [ ( "dn", model.selected /= "Merged to ITB" ) ] ]
                        [ mergedToITBTableHeader model
                        , tbody []
                            (List.map mergedToITBTable model.listOfLinks)
                        ]
                    , div [ classList [ ( "dn", model.selected /= "Defect Status" ) ] ]
                        [ defectStatusTableHeader model
                        , tbody []
                            (List.map defectStatusTable model.listOfLinks)
                        ]
                    , div [ classList [ ( "dn", model.selected /= "Feature Status" ) ] ]
                        [ featureStatusTableHeader model
                        , tbody []
                            (List.map featureStatusTable model.listOfLinks)
                        ]
                    ]
                ]
            ]
        ]
