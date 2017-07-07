module Init exposing (..)

import Model exposing (Model)
import UserStory
import Paginate exposing (PaginatedList)
import Debug


userStory : UserStory.UserStory
userStory =
    UserStory.UserStory "0" "0" 0 0 0 []


getName : UserStory.Result -> String
getName { name } =
    name


model : Model
model =
    Model "Ready to Merge"
        [ "Ready to Merge", "Merged to ITB", "Defect Status", "Feature Status" ]
        [ "Defect Status", "Automated Test Results", "Release Status" ]
        [ "Dashboard", "Defects", "Automated Tests", "Release Status", "Benchmarking", "QA Corner" ]
        ""
        userStory
        [ "All Teams"
        , "Advanced Analytics"
        , "Analytics Products"
        , "Content Engineering"
        , "Core Engine Team"
        , "Creative Services"
        , "Designer Team"
        , "Galileo Team"
        , "Integration Test Team"
        , "Internationalization"
        , "Licensing 2.0"
        , "Prague Team"
        , "Reporting"
        , "Rogue Squadron"
        , "Tool Experience"
        , "Web Team"
        ]
        ""
        -- (Paginate.fromList 5 <| List.map (toString >> (++) "item") <| List.range 1 37)
        (Paginate.fromList 5 <| (List.map getName <| Debug.log "results: " userStory.results))
        False
        ""


init : ( Model, Cmd msg )
init =
    ( model, Cmd.none )
