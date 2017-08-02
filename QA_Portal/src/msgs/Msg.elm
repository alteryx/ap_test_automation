module Msg exposing (..)

import UserStory exposing (..)


type Msg
    = SetActive String
    | ChooseSortOrder String
    | GetUserStory UserStory
    | FailedToParseUserStory String
    | SetSelectedTeam String
    | Next
    | Prev
    | First
    | Last
    | GoTo Int
    | ChangePageSize String
    | DeleteItem UserStory.Result
    | Reverse
    | Find String
    | MergeToITB String
    | MergeToCRT String
    | GetRelease String
    | FailedToParseRelease String
    | MergeAll
    | MergeAllCRT
