module Navigation exposing (navigation)

import Model exposing (Model)
import Html exposing (Html, a, li, div, ul, text)
import Html.Attributes exposing (href, class)
import Msg exposing (Msg)


navigationListItems : String -> Html Msg
navigationListItems string =
    a [ href string, class "link pointer" ]
        [ li [ class "list hover-green white ma3" ] [ text string ] ]


navigation : Model -> Html Msg
navigation model =
    div [ class "fl w-15 alteryx-blue helvetica pl2 pr4 h-100" ]
        [ div [ class "mt3-ns pt2" ]
            [ ul [ class "relative left--2" ]
                (List.map navigationListItems model.listOfLinks)
            ]
        ]
