module Model exposing (..)

import Paginate exposing (PaginatedList)
import UserStory exposing (UserStory)


type alias Model =
    { selected : String
    , tabs : List String
    , cards : List String
    , listOfLinks : List String
    , sortCategory : String
    , userStory : UserStory
    , listOfTeams : List String
    , selectedTeam : String
    , paginated : PaginatedList UserStory.Result
    , reversed : Bool
    , query : String
    , pageSize : Int
    , releases : String
    , csvString : List String
    , mergeAll : Bool
    , mergeAllCRT : Bool
    , refs : List String
    }
