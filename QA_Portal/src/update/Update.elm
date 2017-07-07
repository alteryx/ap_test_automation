module Update exposing (update, formatString)

import Model exposing (Model)
import Msg exposing (Msg)
import WebSocket
import Paginate


formatString : String -> String
formatString string =
    String.split " " string
        |> String.join ""
        |> String.append "ws://localhost:1234/qaportal/"
        |> String.toLower


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg.SetActive tabName ->
            ( { model | selected = tabName }, Cmd.none )

        Msg.ChooseSortOrder category ->
            ( { model | sortCategory = category }, Cmd.none )

        Msg.GetUserStory userStory ->
            ( { model
                | userStory = userStory
                , paginated = (Paginate.fromList 5 <| (List.map (\s -> s.formattedID) <| Debug.log "results: " userStory.results))
              }
            , Cmd.none
            )

        Msg.FailedToParseUserStory msg ->
            (Debug.log msg ( model, Cmd.none ))

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
                ( { model | paginated = Paginate.changeItemsPerPage sizeAsInt model.paginated }, Cmd.none )

        Msg.DeleteItem item ->
            let
                removeItem =
                    List.filter ((/=) item)
            in
                ( { model | paginated = Paginate.map removeItem model.paginated }, Cmd.none )

        Msg.AddItem ->
            let
                addItem existing =
                    existing ++ (List.repeat 1 "new item")
            in
                ( { model | paginated = Paginate.map addItem model.paginated }, Cmd.none )

        Msg.Reverse ->
            ( { model | reversed = not model.reversed }, Cmd.none )

        Msg.Find query ->
            ( { model | query = query }, Cmd.none )
