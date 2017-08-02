module Update exposing (formatString, update)

import Init exposing (model)
import Model exposing (Model)
import Msg exposing (Msg)
import Paginate
import UserStory
import WebSocket


formatString : String -> String
formatString string =
    String.split " " string
        |> String.join ""
        |> String.append "ws://localhost:1234/qaportal/"
        |> String.toLower


updateMergeToITB : Model -> String -> Cmd Msg
updateMergeToITB model ref =
    WebSocket.send "ws://localhost:1234/qaportal/mergedtoitb/update" (model.selectedTeam ++ "-" ++ ref)


updateMergeToCRT : Model -> String -> Cmd Msg
updateMergeToCRT model ref =
    WebSocket.send "ws://localhost:1234/qaportal/mergedtocrt/update" (model.selectedTeam ++ "-" ++ ref)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg.SetActive tabName ->
            ( { model | selected = tabName, mergeAll = False, mergeAllCRT = False }, WebSocket.send (formatString tabName) model.selectedTeam )

        Msg.ChooseSortOrder category ->
            ( { model | sortCategory = category }, Cmd.none )

        Msg.GetUserStory userStory ->
            ( { model
                | userStory = userStory
                , csvString = List.map (\s -> s.formattedID ++ "\x0D\n") userStory.results
                , refs = List.map (\s -> s.ref) userStory.results
                , paginated =
                    Paginate.fromList model.pageSize <|
                        (List.map identity <|
                            Debug.log
                                "results: "
                                userStory.results
                        )
              }
            , Cmd.none
            )

        Msg.GetRelease release ->
            ( { model | releases = release }, WebSocket.send "ws://localhost:1234/qaportal/releases" "" )

        Msg.FailedToParseUserStory msg ->
            Debug.log msg ( model, Cmd.none )

        Msg.FailedToParseRelease msg ->
            Debug.log msg ( model, Cmd.none )

        Msg.SetSelectedTeam string ->
            ( { model | selectedTeam = string }, WebSocket.send (formatString model.selected) string )

        Msg.GoTo index ->
            ( { model | paginated = Paginate.goTo index model.paginated }, Cmd.none )

        Msg.Next ->
            ( { model | paginated = Paginate.next model.paginated }, Cmd.none )

        Msg.Prev ->
            ( { model | paginated = Paginate.prev model.paginated }, Cmd.none )

        Msg.First ->
            ( { model | paginated = Paginate.first model.paginated }, Cmd.none )

        Msg.Last ->
            ( { model | paginated = Paginate.last model.paginated }, Cmd.none )

        Msg.ChangePageSize size ->
            let
                sizeAsInt =
                    Result.withDefault 5 <| String.toInt size
            in
            ( { model
                | paginated = Paginate.changeItemsPerPage sizeAsInt model.paginated
                , pageSize = sizeAsInt
              }
            , Cmd.none
            )

        Msg.DeleteItem item ->
            let
                removeItem =
                    List.filter ((/=) item)
            in
            ( { model | paginated = Paginate.map removeItem model.paginated }, Cmd.none )

        Msg.Reverse ->
            ( { model | reversed = not model.reversed }, Cmd.none )

        Msg.Find query ->
            ( { model | query = query }, Cmd.none )

        Msg.MergeToITB ref ->
            ( model, updateMergeToITB model ref )

        Msg.MergeToCRT ref ->
            ( model, updateMergeToCRT model ref )

        Msg.MergeAll ->
            ( { model | mergeAll = not model.mergeAll }, Cmd.batch <| List.map (updateMergeToITB model) model.refs )

        Msg.MergeAllCRT ->
            ( { model | mergeAllCRT = not model.mergeAllCRT }, Cmd.batch <| List.map (updateMergeToCRT model) model.refs )
