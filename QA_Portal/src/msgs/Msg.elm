module Msg exposing (..)

import UserStory exposing (..)


type Msg
    = SetActive String
    | ChooseSortOrder String
    | GetUserStory UserStory
    | FailedToParseUserStory String
    | SetSelectedTeam String
