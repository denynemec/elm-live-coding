module Page.TodoList exposing (Model, Msg, init, update, view)

import Api
import Browser
import Components.Header as Header
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Route
import Styles



-- TODO: 1) Add fetch todo list
-- TODO: 2) Get api from Flags
-- TODO: 3) Add simple playground page
-- TODO: 4) Trigger port on button click
-- TODO: 5) Implement Api module as Opaque type
-- TODO: 6) Implement Page models as opaque type and compare with previous implementation
-- TODO: 7) Implement add todo item form


type alias TodoItem =
    { id : Int
    , title : String
    , completed : Bool
    }


type alias TodoItemList =
    List TodoItem


type Loading data
    = Loading
    | Error Http.Error
    | Success data


getTodoItemList : Api.Api -> Cmd Msg
getTodoItemList =
    Api.get "todos" FetchedTodoList (Decode.list decodeTodoItem)


decodeTodoItem : Decode.Decoder TodoItem
decodeTodoItem =
    Decode.succeed TodoItem
        |> Pipeline.required "id" Decode.int
        |> Pipeline.required "label" Decode.string
        |> Pipeline.required "completed" Decode.bool


type alias Model =
    { todoItemList : Loading TodoItemList }


init : Api.Api -> ( Model, Cmd Msg )
init api =
    ( { todoItemList = Loading }
    , getTodoItemList api
    )


type Msg
    = FetchedTodoList (Result Http.Error TodoItemList)
    | ClickedCompleteTodoItem Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchedTodoList result ->
            case result of
                Ok data ->
                    ( { todoItemList = Success data }
                    , Cmd.none
                    )

                Err error ->
                    ( { todoItemList = Error error }
                    , Cmd.none
                    )

        ClickedCompleteTodoItem id ->
            ( case model.todoItemList of
                Loading ->
                    model

                Error _ ->
                    model

                Success data ->
                    { todoItemList =
                        data
                            |> List.map
                                (\item ->
                                    if item.id == id then
                                        { item | completed = not item.completed }

                                    else
                                        item
                                )
                            |> Success
                    }
            , Cmd.none
            )


view : (Msg -> msg) -> Model -> Browser.Document msg
view wrapMsg model =
    { title = "Todo List Page"
    , body =
        [ Header.view <| Just Route.TodoList
        , Html.map wrapMsg <|
            Html.div Styles.centeredColumn
                [ Html.h1 [] [ Html.text "Todo list" ]
                , Html.div [ Attributes.style "padding-top" "20px" ]
                    [ todoItemListView model ]
                ]
        ]
    }


todoItemListView : Model -> Html Msg
todoItemListView { todoItemList } =
    case todoItemList of
        Loading ->
            Html.text "Loading"

        Error _ ->
            Html.text "Something went wrong ..."

        Success data ->
            Html.ul Styles.todoItemListListStyle <| List.map todoItemView data


todoItemView : TodoItem -> Html.Html Msg
todoItemView { id, title, completed } =
    let
        checkText =
            if completed then
                "✓"

            else
                ""
    in
    Html.li Styles.todoItemStyle
        [ Html.div (Styles.todoItemCheckStyle ++ [ Events.onClick <| ClickedCompleteTodoItem id ]) [ Html.text checkText ]
        , Html.text title
        ]
