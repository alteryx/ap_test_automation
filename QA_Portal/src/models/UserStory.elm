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
    , changesets : ResultChangesets
    , description : String
    , formattedID : String
    , name : String
    , owner : ResultOwner
    , project : ResultProject
    , rtype : String
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
        |> Json.Decode.Pipeline.required "Changesets" decodeResultChangesets
        |> Json.Decode.Pipeline.required "Description" Json.Decode.string
        |> Json.Decode.Pipeline.required "FormattedID" Json.Decode.string
        |> Json.Decode.Pipeline.required "Name" Json.Decode.string
        |> Json.Decode.Pipeline.required "Owner" decodeResultOwner
        |> Json.Decode.Pipeline.required "Project" decodeResultProject
        |> Json.Decode.Pipeline.required "_type" Json.Decode.string


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
        , ( "Changesets", encodeResultChangesets <| record.changesets )
        , ( "Description", Json.Encode.string <| record.description )
        , ( "FormattedID", Json.Encode.string <| record.formattedID )
        , ( "Name", Json.Encode.string <| record.name )
        , ( "Owner", encodeResultOwner <| record.owner )
        , ( "Project", encodeResultProject <| record.project )
        , ( "_type", Json.Encode.string <| record.rtype )
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
