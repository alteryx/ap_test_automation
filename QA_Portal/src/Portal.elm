module Portal exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import TimeTravel.Html as TimeTravel
import Json.Encode
import Json.Decode exposing (..)
import Json.Decode.Pipeline
import WebSocket
import Debug


userStory : UserStory
userStory =
    UserStory "0" "0" 0 0 0 []


type alias UserStory =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , totalResultCount : Int
    , startIndex : Int
    , pageSize : Int
    , results : List Result
    }


type alias Result =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , refObjectUUID : String
    , objectVersion : String
    , refObjectName : String
    , formattedID : String
    , directChildrenCount : Int
    , name : String
    , owner : ResultOwner
    , project :
        ResultProject
        -- , parent : Parent
    , rtype : String
    }


type alias ResultOwner =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , refObjectUUID : String
    , objectVersion : String
    , refObjectName : String
    , rtype : String
    }


type alias ResultProjectOwner =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , refObjectUUID : String
    , objectVersion : String
    , refObjectName : String
    , rtype : String
    }


type alias ResultProjectParentOwner =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , refObjectUUID : String
    , objectVersion : String
    , refObjectName : String
    , rtype : String
    }


type alias ResultProjectParent =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , refObjectUUID : String
    , objectVersion : String
    , refObjectName : String
    , name : String
    , owner : ResultProjectParentOwner
    , rtype : String
    }


type alias ResultProject =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , refObjectUUID : String
    , objectVersion : String
    , refObjectName : String
    , description : String
    , name : String
    , owner :
        ResultProjectOwner
        -- , parent : ResultProjectParent
    , rtype : String
    }


type Parent
    = Parent
        { rallyAPIMajor : String
        , rallyAPIMinor : String
        , ref : String
        , refObjectUUID : String
        , objectVersion : String
        , refObjectName : String
        , description : String
        , formattedID : String
        , directChildrenCount : Int
        , name : String
        , owner : ParentOwner
        , project :
            ParentProject
            -- , parent : Parent
        , rtype : String
        }
    | EmptyParent


type alias ParentOwner =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , refObjectUUID : String
    , objectVersion : String
    , refObjectName : String
    , rtype : String
    }


type alias ParentProjectOwner =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , refObjectUUID : String
    , objectVersion : String
    , refObjectName : String
    , rtype : String
    }


type alias ParentProjectParentOwner =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , refObjectUUID : String
    , objectVersion : String
    , refObjectName : String
    , rtype : String
    }


type alias ParentProjectParent =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , refObjectUUID : String
    , objectVersion : String
    , refObjectName : String
    , description : String
    , name : String
    , owner : ParentProjectParentOwner
    , rtype : String
    }


type alias ParentProject =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , refObjectUUID : String
    , objectVersion : String
    , refObjectName : String
    , description : String
    , name : String
    , owner :
        ParentProjectOwner
        -- , parent : ParentProjectParent
    , rtype : String
    }


createParent major minor ref refId ver refName desc format childCount name owner project rtype =
    Parent
        { rallyAPIMajor = major
        , rallyAPIMinor = minor
        , ref = ref
        , refObjectUUID = refId
        , objectVersion = ver
        , refObjectName = refName
        , description = desc
        , formattedID = format
        , directChildrenCount = childCount
        , name = name
        , owner = owner
        , project =
            project
            -- , parent = parent
        , rtype = rtype
        }


decodeParent : Json.Decode.Decoder Parent
decodeParent =
    Json.Decode.Pipeline.decode createParent
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_ref" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectUUID" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_objectVersion" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectName" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "description" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "formattedID" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "directChildrenCount" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "owner" (decodeParentOwner)
        |> Json.Decode.Pipeline.required "project" (decodeParentProject)
        -- |> Json.Decode.Pipeline.optional "parent" (lazy (\_ -> decodeParent)) EmptyParent
        |>
            Json.Decode.Pipeline.required "_type" (Json.Decode.string)


decodeParentOwner : Json.Decode.Decoder ParentOwner
decodeParentOwner =
    Json.Decode.Pipeline.decode ParentOwner
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_ref" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectUUID" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_objectVersion" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectName" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_type" (Json.Decode.string)


decodeParentProjectOwner : Json.Decode.Decoder ParentProjectOwner
decodeParentProjectOwner =
    Json.Decode.Pipeline.decode ParentProjectOwner
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_ref" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectUUID" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_objectVersion" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectName" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_type" (Json.Decode.string)


decodeParentProjectParentOwner : Json.Decode.Decoder ParentProjectParentOwner
decodeParentProjectParentOwner =
    Json.Decode.Pipeline.decode ParentProjectParentOwner
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_ref" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectUUID" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_objectVersion" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectName" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_type" (Json.Decode.string)


decodeParentProjectParent : Json.Decode.Decoder ParentProjectParent
decodeParentProjectParent =
    Json.Decode.Pipeline.decode ParentProjectParent
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_ref" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectUUID" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_objectVersion" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectName" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "description" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "owner" (decodeParentProjectParentOwner)
        |> Json.Decode.Pipeline.required "_type" (Json.Decode.string)


decodeParentProject : Json.Decode.Decoder ParentProject
decodeParentProject =
    Json.Decode.Pipeline.decode ParentProject
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_ref" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectUUID" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_objectVersion" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectName" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "description" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "owner" (decodeParentProjectOwner)
        -- |> Json.Decode.Pipeline.required "parent" (decodeParentProjectParent)
        |>
            Json.Decode.Pipeline.required "_type" (Json.Decode.string)


encodeParent : Parent -> Json.Encode.Value
encodeParent parent =
    case parent of
        Parent record ->
            Json.Encode.object
                [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
                , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
                , ( "_ref", Json.Encode.string <| record.ref )
                , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
                , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
                , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
                , ( "Description", Json.Encode.string <| record.description )
                , ( "FormattedID", Json.Encode.string <| record.formattedID )
                , ( "DirectChildrenCount", Json.Encode.int <| record.directChildrenCount )
                , ( "Name", Json.Encode.string <| record.name )
                , ( "Owner", encodeParentOwner <| record.owner )
                , ( "Project", encodeParentProject <| record.project )
                  -- , ( "Parent", encodeParent <| record.parent )
                , ( "_type", Json.Encode.string <| record.rtype )
                ]

        EmptyParent ->
            Json.Encode.null


encodeParentOwner : ParentOwner -> Json.Encode.Value
encodeParentOwner record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
        , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
        , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
        , ( "_type", Json.Encode.string <| record.rtype )
        ]


encodeParentProjectOwner : ParentProjectOwner -> Json.Encode.Value
encodeParentProjectOwner record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
        , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
        , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
        , ( "_type", Json.Encode.string <| record.rtype )
        ]


encodeParentProjectParentOwner : ParentProjectParentOwner -> Json.Encode.Value
encodeParentProjectParentOwner record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
        , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
        , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
        , ( "_type", Json.Encode.string <| record.rtype )
        ]


encodeParentProjectParent : ParentProjectParent -> Json.Encode.Value
encodeParentProjectParent record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
        , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
        , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
        , ( "Description", Json.Encode.string <| record.description )
        , ( "Name", Json.Encode.string <| record.name )
        , ( "Owner", encodeParentProjectParentOwner <| record.owner )
        , ( "_type", Json.Encode.string <| record.rtype )
        ]


encodeParentProject : ParentProject -> Json.Encode.Value
encodeParentProject record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
        , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
        , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
        , ( "Description", Json.Encode.string <| record.description )
        , ( "Name", Json.Encode.string <| record.name )
        , ( "Owner", encodeParentProjectOwner <| record.owner )
          -- , ( "Parent", encodeParentProjectParent <| record.parent )
        , ( "_type", Json.Encode.string <| record.rtype )
        ]


decodeResult : Json.Decode.Decoder Result
decodeResult =
    Json.Decode.Pipeline.decode Result
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_ref" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectUUID" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_objectVersion" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectName" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "FormattedID" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "DirectChildrenCount" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "Name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "Owner" (decodeResultOwner)
        |> Json.Decode.Pipeline.required "Project" (decodeResultProject)
        -- |> Json.Decode.Pipeline.required "Parent" (decodeParent)
        |>
            Json.Decode.Pipeline.required "_type" (Json.Decode.string)


decodeResultOwner : Json.Decode.Decoder ResultOwner
decodeResultOwner =
    Json.Decode.Pipeline.decode ResultOwner
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_ref" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectUUID" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_objectVersion" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectName" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_type" (Json.Decode.string)


decodeResultProjectOwner : Json.Decode.Decoder ResultProjectOwner
decodeResultProjectOwner =
    Json.Decode.Pipeline.decode ResultProjectOwner
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_ref" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectUUID" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_objectVersion" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectName" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_type" (Json.Decode.string)


decodeResultProjectParentOwner : Json.Decode.Decoder ResultProjectParentOwner
decodeResultProjectParentOwner =
    Json.Decode.Pipeline.decode ResultProjectParentOwner
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_ref" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectUUID" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_objectVersion" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectName" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_type" (Json.Decode.string)


decodeResultProjectParent : Json.Decode.Decoder ResultProjectParent
decodeResultProjectParent =
    Json.Decode.Pipeline.decode ResultProjectParent
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_ref" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectUUID" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_objectVersion" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectName" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "Name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "Owner" (decodeResultProjectParentOwner)
        |> Json.Decode.Pipeline.required "_type" (Json.Decode.string)


decodeResultProject : Json.Decode.Decoder ResultProject
decodeResultProject =
    Json.Decode.Pipeline.decode ResultProject
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_ref" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectUUID" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_objectVersion" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_refObjectName" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "Description" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "Name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "Owner" (decodeResultProjectOwner)
        -- |> Json.Decode.Pipeline.required "Parent" (decodeResultProjectParent)
        |>
            Json.Decode.Pipeline.required "_type" (Json.Decode.string)


encodeResult : Result -> Json.Encode.Value
encodeResult record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
        , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
        , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
        , ( "FormattedID", Json.Encode.string <| record.formattedID )
        , ( "DirectChildrenCount", Json.Encode.int <| record.directChildrenCount )
        , ( "Name", Json.Encode.string <| record.name )
        , ( "Owner", encodeResultOwner <| record.owner )
        , ( "Project", encodeResultProject <| record.project )
          -- , ( "parent", encodeParent <| record.parent )
        , ( "_type", Json.Encode.string <| record.rtype )
        ]


encodeResultOwner : ResultOwner -> Json.Encode.Value
encodeResultOwner record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
        , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
        , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
        , ( "_type", Json.Encode.string <| record.rtype )
        ]


encodeResultProjectOwner : ResultProjectOwner -> Json.Encode.Value
encodeResultProjectOwner record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
        , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
        , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
        , ( "_type", Json.Encode.string <| record.rtype )
        ]


encodeResultProjectParentOwner : ResultProjectParentOwner -> Json.Encode.Value
encodeResultProjectParentOwner record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
        , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
        , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
        , ( "_type", Json.Encode.string <| record.rtype )
        ]


encodeResultProjectParent : ResultProjectParent -> Json.Encode.Value
encodeResultProjectParent record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
        , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
        , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
        , ( "Name", Json.Encode.string <| record.name )
        , ( "Owner", encodeResultProjectParentOwner <| record.owner )
        , ( "_type", Json.Encode.string <| record.rtype )
        ]


encodeResultProject : ResultProject -> Json.Encode.Value
encodeResultProject record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
        , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
        , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
        , ( "Name", Json.Encode.string <| record.name )
        , ( "Owner", encodeResultProjectOwner <| record.owner )
          -- , ( "Parent", encodeResultProjectParent <| record.parent )
        , ( "_type", Json.Encode.string <| record.rtype )
        ]


decodeUserStory : Json.Decode.Decoder UserStory
decodeUserStory =
    Json.Decode.Pipeline.decode UserStory
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "TotalResultCount" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "StartIndex" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "PageSize" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "Results" (Json.Decode.list decodeResult)


encodeUserStory : UserStory -> Json.Encode.Value
encodeUserStory record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "TotalResultCount", Json.Encode.int <| record.totalResultCount )
        , ( "StartIndex", Json.Encode.int <| record.startIndex )
        , ( "PageSize", Json.Encode.int <| record.pageSize )
        , ( "Results", Json.Encode.list <| List.map encodeResult <| record.results )
        ]



--uncomment if needed -- import Html.App as App
-- main : Program Never Model Msg


main =
    -- TimeTravel.program
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { selected : String
    , tabs : List String
    , cards : List String
    , listOfLinks : List String
    , sortCategory : String
    , userStory : UserStory
    , listOfTeams : List String
    , selectedTeam : String
    }


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


init =
    ( model, Cmd.none )


type Msg
    = SetActive String
    | ChooseSortOrder String
    | GetUserStory UserStory
    | FailedToParseUserStory String
    | SetSelectedTeam String



-- | ChangeTabFocus


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetActive tabName ->
            ( { model | selected = tabName }, Cmd.none )

        ChooseSortOrder category ->
            ( { model | sortCategory = category }, Cmd.none )

        GetUserStory userStory ->
            ( { model | userStory = userStory }, Cmd.none )

        FailedToParseUserStory msg ->
            (Debug.log msg ( model, Cmd.none ))

        SetSelectedTeam string ->
            ( { model | selectedTeam = string }, WebSocket.send "ws://localhost:1234/qaportal" string )



-- ChangeTabFocus ->


selectedTeamDecoder : Json.Decode.Decoder Msg
selectedTeamDecoder =
    Json.Decode.map SetSelectedTeam Html.Events.targetValue


onChange : (String -> msg) -> Html.Attribute msg
onChange tagger =
    on "change" (Json.Decode.map tagger Html.Events.targetValue)


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


card : String -> Html Msg
card statusType =
    div
        [ class "bg-white dib fl h-100 card-shadow ma2"
        , style [ ( "width", "31.92%" ) ]
        ]
        [ span [ class "pa3 f4 avenir db gray" ]
            [ text statusType
            , select
                [ class "fr bn bg-white outline-0"
                , style
                    [ ( "background-image", "url(../assets/triangle-down.png)" )
                    , ( "background-repeat", "no-repeat" )
                    , ( "background-size", "8px" )
                    , ( "background-position", "95% 95%" )
                    , ( "width", "75px" )
                    , ( "cursor", "pointer" )
                    ]
                ]
                [ option [ selected True ] [ text "this week" ]
                , option [] [ text "last week" ]
                , option [] [ text "last month" ]
                , option [] [ text "last year" ]
                ]
            ]
        , div
            [ class "pb2"
            , style
                [ ( "background-image", "url(../assets/column3d-chart.svg)" )
                , ( "background-repeat", "no-repeat" )
                , ( "background-position", "center" )
                , ( "background-size", "100% 100%" )
                , ( "width", "100%" )
                , ( "height", "70%" )
                ]
            ]
            []
        ]


tab : Model -> String -> Html Msg
tab model tabName =
    span
        [ classList
            [ ( "pb3 pa4 pointer ", True )
            , ( "tab-focused", model.selected == tabName )
            ]
        , onClick (SetActive tabName)
        ]
        [ text tabName ]


tabs : Model -> Html Msg
tabs model =
    div
        [ class "tabs-container mt3 mb4 f6"
        , style [ ( "color", "#D0D0D0" ) ]
        ]
        (List.map (tab model) model.tabs)


banner : Model -> Html Msg
banner model =
    div
        [ class "banner bg-white h3"
        , style
            [ ( "background-image", "url(../assets/alteryx_QA_portal_logo.png" )
            , ( "background-repeat", "no-repeat" )
            , ( "background-position", "right" )
            , ( "background-size", "275px" )
            , ( "margin", "12px 0px 12px 15px" )
            , ( "width", "275px" )
            , ( "height", "40px" )
            ]
        ]
        []


searchInput : Model -> Html Msg
searchInput model =
    input
        [ placeholder "Search..."
        , type_ "search"
        , class "fr mr4 pb2 f6 pt2 relative"
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


readyToMergeTable : Model -> Result -> Html Msg
readyToMergeTable model result =
    tr
        [ class "system-sans-serif f7" ]
        [ td
            [ class "m0 pl3 pa2 truncate mw4"
            , style [ ( "min-width", "8em" ) ]
            ]
            [ text model.selectedTeam ]
        , td
            [ class "m0 pl3 truncate mw4"
            , style [ ( "min-width", "8em" ) ]
            ]
            [ text result.formattedID ]
        , td
            [ class "m0 pl3 truncate mw4"
            , style [ ( "min-width", "8em" ) ]
            ]
            [ text result.owner.refObjectName ]
        , td
            [ class "m0 pl3 truncate mw3"
            , style [ ( "min-width", "4em" ) ]
            ]
            [ text result.name ]
        , td
            [ class "m0 pl3 truncate mw5"
            , style [ ( "min-width", "16em" ) ]
            ]
            [ text result.name ]
        , td
            [ style
                [ ( "padding-left", "3em" )
                , ( "min-width", "3em" )
                ]
            ]
            [ input [ type_ "checkbox" ] [] ]
        ]


readyToMergeTableHeader : Model -> Html Msg
readyToMergeTableHeader model =
    thead
        [ class "system-sans-serif f7 bg-white"
        , style
            [ ( "color", "#5A5A5A" )
            , ( "font-weight", "100" )
            ]
        ]
        [ tr []
            [ th
                [ class "tl pa2 pl3 w-10 arrow"
                , style [ ( "min-width", "12em" ) ]
                ]
                [ text "TEAM"
                , ul [ classList [ ( "dn", model.sortCategory /= "TEAM" ) ] ]
                    [ li [] [ text "Ascending" ]
                    , li [] [ text "Descinding" ]
                    ]
                ]
            , th
                [ class "tl pa2 pl3 w-15 arrow"
                , style [ ( "min-width", "12em" ) ]
                ]
                [ text "STORY/DEFECT" ]
            , th
                [ class "tl pa2 pl3 w-10 arrow"
                , style [ ( "min-width", "11em" ) ]
                ]
                [ text "OWNER" ]
            , th
                [ class "tl pa2 pl3 w-20"
                , style [ ( "min-width", "16em" ) ]
                ]
                [ text "CHANGESET NAME" ]
            , th
                [ class "tl pa2 pl3 w-20"
                , style [ ( "min-width", "20em" ) ]
                ]
                [ text "DESCRIPTION" ]
            , th
                [ class "tl pa2 pl3 w-10"
                , style [ ( "min-width", "16em" ) ]
                ]
                [ text "MERGED" ]
            ]
        ]


mergedToITBTable : String -> Html Msg
mergedToITBTable string =
    tr
        [ class "system-sans-serif f7" ]
        [ td [ class "m0 pl3 pa2 truncate" ] [ text string ]
        , td [ class "m0 pl3 truncate" ] [ text string ]
        , td [ class "m0 pl3 truncate" ] [ text string ]
        , td [ class "m0 pl3 truncate" ] [ text string ]
        , td [ class "m0 pl3 truncate" ] [ text string ]
        , td [ class "m0 pl3 truncate" ] [ text string ]
        , td [ class "m0 pl3 truncate" ] [ text string ]
        , td [ style [ ( "padding-left", "4em" ) ] ] [ input [ type_ "checkbox" ] [] ]
        ]


mergedToITBTableHeader : Model -> Html Msg
mergedToITBTableHeader model =
    thead
        [ class "system-sans-serif f7 bg-white"
        , style
            [ ( "color", "#5A5A5A" )
            , ( "font-weight", "100" )
            ]
        ]
        [ tr []
            [ th [ class "tl pa2 pl3 w4 arrow" ] [ text "TEAM" ]
            , th [ class "tl pa2 pl3 arrow", style [ ( "width", "12em" ) ] ] [ text "STORY/DEFECT" ]
            , th [ class "tl pa2 pl3 w3 arrow" ] [ text "OWNER" ]
            , th [ class "tl pa2 pl3 w5" ] [ text "ITB QA" ]
            , th [ class "tl pa2 pl3 w4" ] [ text "STATUS" ]
            , th [ class "tl pa2 pl3 w4" ] [ text "DEFECTS FILED" ]
            , th [ class "tl pa2 pl3 w4" ] [ text "TASK" ]
            , th [ class "tl pa2 pl3 w4" ] [ text "AUTOMATION" ]
            ]
        ]


defectStatusTable : String -> Html Msg
defectStatusTable string =
    tr
        [ class "system-sans-serif f7" ]
        [ td [ class "m0 pl3 pa2 truncate" ] [ text string ]
        , td [ class "m0 pl3 truncate" ] [ text string ]
        , td [ class "m0 pl3 truncate" ] [ text string ]
        , td [ class "m0 pl3 truncate" ] [ text string ]
        , td [ class "m0 pl3 truncate" ] [ text string ]
        , td [ class "m0 pl3 truncate" ] [ text string ]
        , td [ class "m0 pl3 truncate" ] [ text string ]
        ]


defectStatusTableHeader : Model -> Html Msg
defectStatusTableHeader model =
    thead
        [ class "system-sans-serif f7 bg-white"
        , style
            [ ( "color", "#5A5A5A" )
            , ( "font-weight", "100" )
            ]
        ]
        [ tr []
            [ th [ class "tl pa2 pl3 w4 arrow" ] [ text "TEAM" ]
            , th [ class "tl pa2 pl3 arrow", style [ ( "width", "12em" ) ] ] [ text "STORY/DEFECT" ]
            , th [ class "tl pa2 pl3 w3 arrow" ] [ text "OWNER" ]
            , th [ class "tl pa2 pl3 w4" ] [ text "CREATED" ]
            , th [ class "tl pa2 pl3 w5" ] [ text "SOURCE" ]
            , th [ class "tl pa2 pl3 w5" ] [ text "DESCRIPTION" ]
            , th [ class "tl pa2 pl3 w4" ] [ text "SEVERITY" ]
            ]
        ]


featureStatusTable : String -> Html Msg
featureStatusTable string =
    tr
        [ class "system-sans-serif f7" ]
        [ td [ class "m0 pl3 pa2 truncate" ] [ text string ]
        , td [ class "m0 pl3 truncate" ] [ text string ]
        , td [ class "m0 pl3 truncate" ] [ text string ]
        , td [ class "m0 pl3 truncate" ] [ text string ]
        , td [ class "m0 pl3 truncate" ] [ text string ]
        , td [ class "m0 pl3 truncate" ] [ text string ]
        ]


featureStatusTableHeader : Model -> Html Msg
featureStatusTableHeader model =
    thead
        [ class "system-sans-serif f7 bg-white"
        , style
            [ ( "color", "#5A5A5A" )
            , ( "font-weight", "100" )
            ]
        ]
        [ tr []
            [ th
                [ class "tl pa2 pl3 w-10 arrow"
                , style [ ( "min-width", "12em" ) ]
                ]
                [ text "TEAM"
                , ul [ classList [ ( "dn", model.sortCategory /= "TEAM" ) ] ]
                    [ li [] [ text "Ascending" ]
                    , li [] [ text "Descinding" ]
                    ]
                ]
            , th
                [ class "tl pa2 pl3 w-15 arrow"
                , style [ ( "min-width", "12em" ) ]
                ]
                [ text "FEATURE" ]
            , th
                [ class "tl pa2 pl3 w-10 arrow"
                , style [ ( "min-width", "11em" ) ]
                ]
                [ text "OWNER" ]
            , th
                [ class "tl pa2 pl3 w-20"
                , style [ ( "min-width", "16em" ) ]
                ]
                [ text "CREATED" ]
            , th
                [ class "tl pa2 pl3 w-20"
                , style [ ( "min-width", "20em" ) ]
                ]
                [ text "DESCRIPTION" ]
            , th
                [ class "tl pa2 pl3 w-10"
                , style [ ( "min-width", "16em" ) ]
                ]
                [ text "COMPLETED" ]
            ]
        ]


mergeInfo : Model -> Html Msg
mergeInfo model =
    div
        [ class "bg-white ml4 fl merge-shadow mt3 mr3 h-100"
        , style
            [ ( "width", "98.6%" ) ]
        ]
        [ tabs model
        , div [ class "merge-info pt4" ]
            [ div [ class "h1 pl4" ]
                [ span
                    [ class "dib resize fr relative"
                    , style
                        [ ( "background-image", "url(../assets/resize-full-screen.png" )
                        , ( "background-repeat", "no-repeat" )
                        , ( "background-position", "50% 50%" )
                        , ( "background-size", "13px" )
                        , ( "width", "13px" )
                        , ( "cursor", "pointer" )
                        , ( "height", "13px" )
                        , ( "top", "-40px" )
                        , ( "left", "-34px" )
                        ]
                    ]
                    []
                , select
                    [ class "dib w5 pa2 relative outline-0 bn br0"
                    , onChange SetSelectedTeam
                    , style
                        [ ( "background-color", "#efefef" )
                        , ( "background-image", "url(../assets/chevron-small-down.png)" )
                        , ( "background-repeat", "no-repeat" )
                        , ( "background-position", "90% 52%" )
                        , ( "cursor", "pointer" )
                          -- , ( "-webkit-appearance", "none" )
                          -- , ( "-moz-appearance", "none" )
                          -- , ( "text-indent", "8px" )
                          -- , ( "text-overflow", "" )
                        , ( "background-size", "10px" )
                        , ( "top", "-12px" )
                        ]
                    ]
                    (List.map
                        (\teamName ->
                            option
                                [ class "pr4"
                                ]
                                [ text teamName ]
                        )
                        model.listOfTeams
                    )
                , searchInput model
                ]
            , div
                [ class "table-container relative ml4 fl mt3"
                , style
                    [ ( "width", "94.3%" )
                    , ( "border-top", "1px solid #eee" )
                    ]
                ]
                [ table []
                    [ div [ classList [ ( "dn", model.selected /= "Ready to Merge" ) ] ]
                        [ readyToMergeTableHeader model
                        , tbody []
                            (List.map (readyToMergeTable model) model.userStory.results)
                        ]
                    , div [ classList [ ( "dn", model.selected /= "Merged to ITB" ) ] ]
                        [ mergedToITBTableHeader model
                        , tbody []
                            (List.map mergedToITBTable model.listOfLinks)
                        ]
                    , div [ classList [ ( "dn", model.selected /= "Defect Status" ) ] ]
                        [ defectStatusTableHeader model
                        , tbody []
                            (List.map defectStatusTable model.listOfLinks)
                        ]
                    , div [ classList [ ( "dn", model.selected /= "Feature Status" ) ] ]
                        [ featureStatusTableHeader model
                        , tbody []
                            (List.map featureStatusTable model.listOfLinks)
                        ]
                    ]
                ]
            ]
        ]


view : Model -> Html Msg
view model =
    div [ class "outer-container" ]
        [ banner model
        , div [ class "container vh-100 relative aliceblue" ]
            [ navigation model
            , div [ class "card-holder w-80 fl ml4 h-25 mt3" ]
                (List.map card model.cards)
            , div
                [ class "merge-info-container mt2 fl ml2 w-80"
                , style [ ( "height", "67%" ) ]
                ]
                [ mergeInfo model
                ]
            , div [] [ text model.sortCategory ]
            ]
        ]


parseGetUserStory : String -> Msg
parseGetUserStory jsonString =
    case decodeString decodeUserStory jsonString of
        Ok userStory ->
            GetUserStory userStory

        Err msg ->
            FailedToParseUserStory msg


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen "ws://localhost:1234/qaportal" parseGetUserStory



-- subscriptions model =
--     Sub.none
