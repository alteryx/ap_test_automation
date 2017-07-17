module UserStory exposing (..)

import Json.Decode exposing (..)
import Json.Decode.Pipeline
import Json.Encode


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
    , createdAt : String
    , severity : String
    , changesets : ResultChangesets
    , description : String
    , formattedID : String
    , name : String
    , owner : ResultOwner
    , project : ResultProject
    , rtype : String
    , c_DefectSource : String
    , feature : Maybe ResultFeature
    , objectId : Int
    , c_TestingStatus : String
    , blocked : Bool
    , blockedReason : String
    }


type alias ResultChangesets =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , rtype : String
    , count : Int
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


type alias ResultProject =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , refObjectUUID : String
    , objectVersion : String
    , refObjectName : String
    , description : String
    , name : String
    , owner : ResultProjectOwner
    , rtype : String
    }


type alias ResultFeature =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , refObjectUUID : String
    , objectVersion : String
    , refObjectName : String
    , creationDate : String
    , createdAt : String
    , workspace : FeatureWorkspace
    , changesets : FeatureChangesets
    , description : String
    , formattedID : String
    , directChildrenCount : Int
    , name : String
    , owner : FeatureOwner
    , project : FeatureProject
    , rtype : String
    }


type alias FeatureWorkspaceOwner =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , refObjectUUID : String
    , objectVersion : String
    , refObjectName : String
    , rtype : String
    }


type alias FeatureWorkspace =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , refObjectUUID : String
    , objectVersion : String
    , refObjectName : String
    , creationDate : String
    , createdAt : String
    , description : String
    , name : String
    , owner : FeatureWorkspaceOwner
    , rtype : String
    }


type alias FeatureChangesets =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , rtype : String
    , count : Int
    }


type alias FeatureOwner =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , refObjectUUID : String
    , objectVersion : String
    , refObjectName : String
    , rtype : String
    }


type alias FeatureProjectOwner =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , refObjectUUID : String
    , objectVersion : String
    , refObjectName : String
    , rtype : String
    }


type alias FeatureProjectWorkspaceOwner =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , refObjectUUID : String
    , objectVersion : String
    , refObjectName : String
    , rtype : String
    }


type alias FeatureProjectWorkspace =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , refObjectUUID : String
    , objectVersion : String
    , refObjectName : String
    , creationDate : String
    , createdAt : String
    , description : String
    , name : String
    , owner : FeatureProjectWorkspaceOwner
    , rtype : String
    }


type alias FeatureProject =
    { rallyAPIMajor : String
    , rallyAPIMinor : String
    , ref : String
    , refObjectUUID : String
    , objectVersion : String
    , refObjectName : String
    , creationDate : String
    , createdAt : String
    , description : String
    , name : String
    , owner : FeatureProjectOwner
    , workspace : FeatureProjectWorkspace
    , rtype : String
    }


decodeFeature : Json.Decode.Decoder ResultFeature
decodeFeature =
    Json.Decode.Pipeline.decode ResultFeature
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_ref" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectUUID" Json.Decode.string
        |> Json.Decode.Pipeline.required "_objectVersion" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectName" Json.Decode.string
        |> Json.Decode.Pipeline.required "CreationDate" Json.Decode.string
        |> Json.Decode.Pipeline.required "_CreatedAt" Json.Decode.string
        |> Json.Decode.Pipeline.required "Workspace" decodeFeatureWorkspace
        |> Json.Decode.Pipeline.required "Changesets" decodeFeatureChangesets
        |> Json.Decode.Pipeline.required "Description" Json.Decode.string
        |> Json.Decode.Pipeline.required "FormattedID" Json.Decode.string
        |> Json.Decode.Pipeline.required "DirectChildrenCount" Json.Decode.int
        |> Json.Decode.Pipeline.required "Name" Json.Decode.string
        |> Json.Decode.Pipeline.required "Owner" decodeFeatureOwner
        |> Json.Decode.Pipeline.required "Project" decodeFeatureProject
        |> Json.Decode.Pipeline.required "_type" Json.Decode.string


decodeFeatureWorkspaceOwner : Json.Decode.Decoder FeatureWorkspaceOwner
decodeFeatureWorkspaceOwner =
    Json.Decode.Pipeline.decode FeatureWorkspaceOwner
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_ref" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectUUID" Json.Decode.string
        |> Json.Decode.Pipeline.required "_objectVersion" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectName" Json.Decode.string
        |> Json.Decode.Pipeline.required "_type" Json.Decode.string


decodeFeatureWorkspace : Json.Decode.Decoder FeatureWorkspace
decodeFeatureWorkspace =
    Json.Decode.Pipeline.decode FeatureWorkspace
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_ref" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectUUID" Json.Decode.string
        |> Json.Decode.Pipeline.required "_objectVersion" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectName" Json.Decode.string
        |> Json.Decode.Pipeline.required "CreationDate" Json.Decode.string
        |> Json.Decode.Pipeline.required "_CreatedAt" Json.Decode.string
        |> Json.Decode.Pipeline.required "Description" Json.Decode.string
        |> Json.Decode.Pipeline.required "Name" Json.Decode.string
        |> Json.Decode.Pipeline.required "Owner" decodeFeatureWorkspaceOwner
        |> Json.Decode.Pipeline.required "_type" Json.Decode.string


decodeFeatureChangesets : Json.Decode.Decoder FeatureChangesets
decodeFeatureChangesets =
    Json.Decode.Pipeline.decode FeatureChangesets
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_ref" Json.Decode.string
        |> Json.Decode.Pipeline.required "_type" Json.Decode.string
        |> Json.Decode.Pipeline.required "Count" Json.Decode.int


decodeFeatureOwner : Json.Decode.Decoder FeatureOwner
decodeFeatureOwner =
    Json.Decode.Pipeline.decode FeatureOwner
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_ref" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectUUID" Json.Decode.string
        |> Json.Decode.Pipeline.required "_objectVersion" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectName" Json.Decode.string
        |> Json.Decode.Pipeline.required "_type" Json.Decode.string


decodeFeatureProjectOwner : Json.Decode.Decoder FeatureProjectOwner
decodeFeatureProjectOwner =
    Json.Decode.Pipeline.decode FeatureProjectOwner
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_ref" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectUUID" Json.Decode.string
        |> Json.Decode.Pipeline.required "_objectVersion" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectName" Json.Decode.string
        |> Json.Decode.Pipeline.required "_type" Json.Decode.string


decodeFeatureProjectWorkspaceOwner : Json.Decode.Decoder FeatureProjectWorkspaceOwner
decodeFeatureProjectWorkspaceOwner =
    Json.Decode.Pipeline.decode FeatureProjectWorkspaceOwner
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_ref" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectUUID" Json.Decode.string
        |> Json.Decode.Pipeline.required "_objectVersion" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectName" Json.Decode.string
        |> Json.Decode.Pipeline.required "_type" Json.Decode.string


decodeFeatureProjectWorkspace : Json.Decode.Decoder FeatureProjectWorkspace
decodeFeatureProjectWorkspace =
    Json.Decode.Pipeline.decode FeatureProjectWorkspace
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_ref" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectUUID" Json.Decode.string
        |> Json.Decode.Pipeline.required "_objectVersion" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectName" Json.Decode.string
        |> Json.Decode.Pipeline.required "CreationDate" Json.Decode.string
        |> Json.Decode.Pipeline.required "_CreatedAt" Json.Decode.string
        |> Json.Decode.Pipeline.required "Description" Json.Decode.string
        |> Json.Decode.Pipeline.required "Name" Json.Decode.string
        |> Json.Decode.Pipeline.required "Owner" decodeFeatureProjectWorkspaceOwner
        |> Json.Decode.Pipeline.required "_type" Json.Decode.string


decodeFeatureProject : Json.Decode.Decoder FeatureProject
decodeFeatureProject =
    Json.Decode.Pipeline.decode FeatureProject
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_ref" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectUUID" Json.Decode.string
        |> Json.Decode.Pipeline.required "_objectVersion" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectName" Json.Decode.string
        |> Json.Decode.Pipeline.required "CreationDate" Json.Decode.string
        |> Json.Decode.Pipeline.required "_CreatedAt" Json.Decode.string
        |> Json.Decode.Pipeline.required "Description" Json.Decode.string
        |> Json.Decode.Pipeline.required "Name" Json.Decode.string
        |> Json.Decode.Pipeline.required "Owner" decodeFeatureProjectOwner
        |> Json.Decode.Pipeline.required "Workspace" decodeFeatureProjectWorkspace
        |> Json.Decode.Pipeline.required "_type" Json.Decode.string


encodeFeature : Maybe ResultFeature -> Maybe Json.Encode.Value
encodeFeature maybeRecord =
    case maybeRecord of
        Just record ->
            Just <|
                Json.Encode.object
                    [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
                    , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
                    , ( "_ref", Json.Encode.string <| record.ref )
                    , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
                    , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
                    , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
                    , ( "CreationDate", Json.Encode.string <| record.creationDate )
                    , ( "_CreatedAt", Json.Encode.string <| record.createdAt )
                    , ( "Workspace", encodeFeatureWorkspace <| record.workspace )
                    , ( "Changesets", encodeFeatureChangesets <| record.changesets )
                    , ( "Description", Json.Encode.string <| record.description )
                    , ( "FormattedID", Json.Encode.string <| record.formattedID )
                    , ( "DirectChildrenCount", Json.Encode.int <| record.directChildrenCount )
                    , ( "Name", Json.Encode.string <| record.name )
                    , ( "Owner", encodeFeatureOwner <| record.owner )
                    , ( "Project", encodeFeatureProject <| record.project )
                    , ( "_type", Json.Encode.string <| record.rtype )
                    ]

        _ ->
            Nothing


encodeFeatureWorkspaceOwner : FeatureWorkspaceOwner -> Json.Encode.Value
encodeFeatureWorkspaceOwner record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
        , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
        , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
        , ( "_type", Json.Encode.string <| record.rtype )
        ]


encodeFeatureWorkspace : FeatureWorkspace -> Json.Encode.Value
encodeFeatureWorkspace record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
        , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
        , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
        , ( "CreationDate", Json.Encode.string <| record.creationDate )
        , ( "_CreatedAt", Json.Encode.string <| record.createdAt )
        , ( "Description", Json.Encode.string <| record.description )
        , ( "Name", Json.Encode.string <| record.name )
        , ( "Owner", encodeFeatureWorkspaceOwner <| record.owner )
        , ( "_type", Json.Encode.string <| record.rtype )
        ]


encodeFeatureChangesets : FeatureChangesets -> Json.Encode.Value
encodeFeatureChangesets record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_type", Json.Encode.string <| record.rtype )
        , ( "Count", Json.Encode.int <| record.count )
        ]


encodeFeatureOwner : FeatureOwner -> Json.Encode.Value
encodeFeatureOwner record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
        , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
        , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
        , ( "_type", Json.Encode.string <| record.rtype )
        ]


encodeFeatureProjectOwner : FeatureProjectOwner -> Json.Encode.Value
encodeFeatureProjectOwner record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
        , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
        , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
        , ( "_type", Json.Encode.string <| record.rtype )
        ]


encodeFeatureProjectWorkspaceOwner : FeatureProjectWorkspaceOwner -> Json.Encode.Value
encodeFeatureProjectWorkspaceOwner record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
        , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
        , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
        , ( "_type", Json.Encode.string <| record.rtype )
        ]


encodeFeatureProjectWorkspace : FeatureProjectWorkspace -> Json.Encode.Value
encodeFeatureProjectWorkspace record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
        , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
        , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
        , ( "CreationDate", Json.Encode.string <| record.creationDate )
        , ( "_CreatedAt", Json.Encode.string <| record.createdAt )
        , ( "Description", Json.Encode.string <| record.description )
        , ( "Name", Json.Encode.string <| record.name )
        , ( "Owner", encodeFeatureProjectWorkspaceOwner <| record.owner )
        , ( "_type", Json.Encode.string <| record.rtype )
        ]


encodeFeatureProject : FeatureProject -> Json.Encode.Value
encodeFeatureProject record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
        , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
        , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
        , ( "CreationDate", Json.Encode.string <| record.creationDate )
        , ( "_CreatedAt", Json.Encode.string <| record.createdAt )
        , ( "Description", Json.Encode.string <| record.description )
        , ( "Name", Json.Encode.string <| record.name )
        , ( "Owner", encodeFeatureProjectOwner <| record.owner )
        , ( "Workspace", encodeFeatureProjectWorkspace <| record.workspace )
        , ( "_type", Json.Encode.string <| record.rtype )
        ]


decodeUserStory : Json.Decode.Decoder UserStory
decodeUserStory =
    Json.Decode.Pipeline.decode UserStory
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" Json.Decode.string
        |> Json.Decode.Pipeline.required "TotalResultCount" Json.Decode.int
        |> Json.Decode.Pipeline.required "StartIndex" Json.Decode.int
        |> Json.Decode.Pipeline.required "PageSize" Json.Decode.int
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


decodeResult : Json.Decode.Decoder Result
decodeResult =
    Json.Decode.Pipeline.decode Result
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_ref" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectUUID" Json.Decode.string
        |> Json.Decode.Pipeline.required "_objectVersion" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectName" Json.Decode.string
        |> Json.Decode.Pipeline.required "_CreatedAt" Json.Decode.string
        |> Json.Decode.Pipeline.optional "Severity" Json.Decode.string ""
        |> Json.Decode.Pipeline.required "Changesets" decodeResultChangesets
        |> Json.Decode.Pipeline.required "Description" Json.Decode.string
        |> Json.Decode.Pipeline.required "FormattedID" Json.Decode.string
        |> Json.Decode.Pipeline.required "Name" Json.Decode.string
        |> Json.Decode.Pipeline.required "Owner" decodeResultOwner
        |> Json.Decode.Pipeline.required "Project" decodeResultProject
        |> Json.Decode.Pipeline.required "_type" Json.Decode.string
        |> Json.Decode.Pipeline.optional "c_DefectSource" Json.Decode.string ""
        |> Json.Decode.Pipeline.optional "Feature" (Json.Decode.map Just decodeFeature) Nothing
        |> Json.Decode.Pipeline.required "ObjectID" Json.Decode.int
        |> Json.Decode.Pipeline.optional "c_TestingStatus" Json.Decode.string "N/A"
        |> Json.Decode.Pipeline.required "Blocked" Json.Decode.bool
        |> Json.Decode.Pipeline.optional "BlockedReason" Json.Decode.string ""


decodeResultChangesets : Json.Decode.Decoder ResultChangesets
decodeResultChangesets =
    Json.Decode.map5 ResultChangesets
        (field "_rallyAPIMajor" Json.Decode.string)
        (field "_rallyAPIMinor" Json.Decode.string)
        (field "_ref" Json.Decode.string)
        (field "_type" Json.Decode.string)
        (field "Count" Json.Decode.int)


decodeResultOwner : Json.Decode.Decoder ResultOwner
decodeResultOwner =
    Json.Decode.Pipeline.decode ResultOwner
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_ref" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectUUID" Json.Decode.string
        |> Json.Decode.Pipeline.required "_objectVersion" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectName" Json.Decode.string
        |> Json.Decode.Pipeline.required "_type" Json.Decode.string


decodeResultProjectOwner : Json.Decode.Decoder ResultProjectOwner
decodeResultProjectOwner =
    Json.Decode.Pipeline.decode ResultProjectOwner
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_ref" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectUUID" Json.Decode.string
        |> Json.Decode.Pipeline.required "_objectVersion" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectName" Json.Decode.string
        |> Json.Decode.Pipeline.required "_type" Json.Decode.string


decodeResultProject : Json.Decode.Decoder ResultProject
decodeResultProject =
    Json.Decode.Pipeline.decode ResultProject
        |> Json.Decode.Pipeline.required "_rallyAPIMajor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_rallyAPIMinor" Json.Decode.string
        |> Json.Decode.Pipeline.required "_ref" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectUUID" Json.Decode.string
        |> Json.Decode.Pipeline.required "_objectVersion" Json.Decode.string
        |> Json.Decode.Pipeline.required "_refObjectName" Json.Decode.string
        |> Json.Decode.Pipeline.required "Description" Json.Decode.string
        |> Json.Decode.Pipeline.required "Name" Json.Decode.string
        |> Json.Decode.Pipeline.required "Owner" decodeResultProjectOwner
        |> Json.Decode.Pipeline.required "_type" Json.Decode.string


encodeResult : Result -> Json.Encode.Value
encodeResult record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
        , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
        , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
        , ( "_CreatedAt", Json.Encode.string <| record.createdAt )
        , ( "Severity", Json.Encode.string <| record.severity )
        , ( "Changesets", encodeResultChangesets <| record.changesets )
        , ( "Description", Json.Encode.string <| record.description )
        , ( "FormattedID", Json.Encode.string <| record.formattedID )
        , ( "Name", Json.Encode.string <| record.name )
        , ( "Owner", encodeResultOwner <| record.owner )
        , ( "Project", encodeResultProject <| record.project )
        , ( "_type", Json.Encode.string <| record.rtype )
        , ( "c_DefectSource", Json.Encode.string <| record.c_DefectSource )
        , ( "Feature", Maybe.withDefault Json.Encode.null <| encodeFeature <| record.feature )
        , ( "ObjectID", Json.Encode.int <| record.objectId )
        , ( "c_TestingStatus", Json.Encode.string <| record.c_TestingStatus )
        , ( "Blocked", Json.Encode.bool <| record.blocked )
        , ( "BlockedReason", Json.Encode.string <| record.blockedReason )
        ]


encodeResultChangesets : ResultChangesets -> Json.Encode.Value
encodeResultChangesets record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_type", Json.Encode.string <| record.rtype )
        , ( "Count", Json.Encode.int <| record.count )
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


encodeResultProject : ResultProject -> Json.Encode.Value
encodeResultProject record =
    Json.Encode.object
        [ ( "_rallyAPIMajor", Json.Encode.string <| record.rallyAPIMajor )
        , ( "_rallyAPIMinor", Json.Encode.string <| record.rallyAPIMinor )
        , ( "_ref", Json.Encode.string <| record.ref )
        , ( "_refObjectUUID", Json.Encode.string <| record.refObjectUUID )
        , ( "_objectVersion", Json.Encode.string <| record.objectVersion )
        , ( "_refObjectName", Json.Encode.string <| record.refObjectName )
        , ( "Description", Json.Encode.string <| record.description )
        , ( "Name", Json.Encode.string <| record.name )
        , ( "Owner", encodeResultProjectOwner <| record.owner )
        , ( "_type", Json.Encode.string <| record.rtype )
        ]
