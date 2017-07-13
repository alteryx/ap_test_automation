module Init exposing (..)

import Debug
import Model exposing (Model)
import Paginate exposing (PaginatedList)
import UserStory


userStory : UserStory.UserStory
userStory =
    UserStory.UserStory "0" "0" 0 0 0 []


model : Model
model =
    Model "Ready to Merge"
        [ "Ready to Merge", "Merged to ITB", "ITB Defects", "Feature Status" ]
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
        (Paginate.fromList 5 <| (List.map identity <| Debug.log "results: " userStory.results))
        False
        ""
        5


init : ( Model, Cmd msg )
init =
    ( model, Cmd.none )
