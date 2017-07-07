module SearchInput exposing (searchInput)

import Model exposing (Model)
import Html exposing (Html, input)
import Msg exposing (Msg)
import Html.Events exposing (onInput)
import Html.Attributes exposing (placeholder, type_, class, style)


searchInput : Model -> Html Msg
searchInput model =
    input
        [ placeholder "Search..."
        , type_ "search"
        , class "fr mr4 pb2 f6 pt2 relative"
        , onInput Msg.Find
        , style
            [ ( "border", "none" )
            , ( "padding-left", "25px" )
            , ( "border-bottom", "2px solid #43D2B0" )
            , ( "outline", "none" )
            , ( "width", "17%" )
            , ( "background-image", "url(../assets/magnifying-glass.png)" )
            , ( "background-repeat", "no-repeat" )
            , ( "background-size", "15px" )
            , ( "height", "15px" )
            , ( "right", "-13px" )
            ]
        ]
        []
