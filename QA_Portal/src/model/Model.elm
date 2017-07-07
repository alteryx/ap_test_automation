module Model exposing (..)

import UserStory exposing (UserStory)
import Paginate exposing (PaginatedList)


type alias Model =
    { selected : String
    , tabs : List String
    , cards : List String
    , listOfLinks : List String
    , sortCategory : String
    , userStory : UserStory
    , listOfTeams : List String
    , selectedTeam : String
    , paginated : PaginatedList String
    , reversed : Bool
    , query : String
    }
