module Page.TodoList exposing (Model, Msg, init, update, view)

import Browser
import Components.Header as Header
import Html
import Html.Attributes as Attributes
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import RemoteData
import Route
import Styles
import Utils.Api as Api



-- TODO: 1) Add fetch todo list
-- TODO: 2) Get api from Flags
-- TODO: 3) Add simple playground page
-- TODO: 4) Trigger port on button click
-- TODO: 5) Implement Api module as Opaque type
-- TODO: 6) Implement Page models as opaque type and compare with previous implementation
-- TODO: 7) Implement add todo item form


type alias Model =
    { todoItemList : RemoteData.WebData TodoItemList
    }


fetchTodoListCmd : Api.Api -> Cmd Msg
fetchTodoListCmd =
    Api.updateRefreshToken
        >> Api.get "/todos" FetchedTodoItems decodeTodoItemList


type alias TodoItem =
    { id : Int
    , label : String
    , completed : Bool
    }


type alias TodoItemList =
    List TodoItem


decodeTodoItemList : Decode.Decoder TodoItemList
decodeTodoItemList =
    Decode.list decodeTodoItem


decodeTodoItem : Decode.Decoder TodoItem
decodeTodoItem =
    Decode.succeed TodoItem
        |> Pipeline.required "id" Decode.int
        |> Pipeline.required "label" Decode.string
        |> Pipeline.required "completed" Decode.bool


init : Api.Api -> ( Model, Cmd Msg )
init api =
    ( { todoItemList = RemoteData.Loading }
    , fetchTodoListCmd api
    )


type Msg
    = FetchedTodoItems (RemoteData.WebData TodoItemList)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchedTodoItems webData ->
            ( { model | todoItemList = webData }
            , Cmd.none
            )


view : (Msg -> msg) -> Model -> Browser.Document msg
view wrapMsg model =
    { title = "Todo List Page"
    , body =
        [ Header.view <| Just Route.TodoList
        , case model.todoItemList of
            RemoteData.NotAsked ->
                Html.text "Not Asked..."

            RemoteData.Loading ->
                Html.text "Loading ..."

            RemoteData.Failure _ ->
                Html.text "Error"

            RemoteData.Success data ->
                Html.map wrapMsg <|
                    Html.div Styles.centeredColumn
                        [ Html.h1 [] [ Html.text "Todo list" ]
                        , Html.div [ Attributes.style "padding-top" "20px" ]
                            [ Html.ul Styles.todoItemListListStyle <| List.map todoItemView data ]
                        ]
        ]
    }


todoItemView : TodoItem -> Html.Html Msg
todoItemView { label, completed } =
    let
        checkText =
            if completed then
                "✓"

            else
                ""
    in
    Html.li Styles.todoItemStyle
        [ Html.div Styles.todoItemCheckStyle [ Html.text checkText ]
        , Html.text label
        ]
