module Init exposing (..)

import Model exposing (Model)
import UserStory
import Paginate exposing (PaginatedList)


userStory : UserStory.UserStory
userStory =
    UserStory.UserStory "0" "0" 0 0 0 []


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
        (Paginate.fromList 10 <| List.map (\s -> s.formattedID) <| userStory.results)
        False
        ""


init : ( Model, Cmd msg )
init =
    ( model, Cmd.none )
