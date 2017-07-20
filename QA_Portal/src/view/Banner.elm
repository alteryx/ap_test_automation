module Banner exposing (banner)

import Html exposing (Html, div)
import Html.Attributes exposing (class, style)
import Model exposing (Model)
import Msg exposing (Msg)


banner : Model -> Html Msg
banner model =
    div
        [ class "banner h3"
        ]
        []
