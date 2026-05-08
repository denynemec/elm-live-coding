port module Page.TodoList exposing (Model, Msg, init, update, view)

import Api
import Browser
import Components.Header as Header
import Html
import Html.Attributes as Attributes
import Html.Events as Events
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Json.Encode as Encode
import Route
import Styles



-- TODO: 1) Add fetch todo list
-- TODO: 2) Get api from Flags
-- TODO: 3) Add simple playground page
-- TODO: 4) Trigger port on button click
-- TODO: 5) Implement Api module as Opaque type
-- TODO: 6) Implement Page models as opaque type and compare with previous implementation
-- TODO: 7) Implement add todo item form


port sendToJs : Encode.Value -> Cmd msg


type alias IDRecord r idType =
    { r
        | id : idType
    }


type alias TodoItem =
    IDRecord
        { label2 : String
        , completed : Bool
        }
        Int


type alias TodoItemList =
    List TodoItem


decodeTodoItemList : Decode.Decoder TodoItemList
decodeTodoItemList =
    Decode.list decodeTodoItem


createTodoItem : Int -> String -> Bool -> TodoItem
createTodoItem id newTitleInTodoItem completed =
    { id = id
    , label2 = newTitleInTodoItem
    , completed = completed
    }


decodeTodoItem : Decode.Decoder TodoItem
decodeTodoItem =
    Decode.succeed createTodoItem
        |> Pipeline.required "id" Decode.int
        |> Pipeline.required "label" Decode.string
        |> Pipeline.required "completed" Decode.bool


fetchTodoItems : Api.Api -> Cmd Msg
fetchTodoItems =
    Api.refreshToken Api.tokenV2
        >> Api.get "/todos" FetchedTodoItems decodeTodoItemList


type Loading
    = LoadingData
    | Error Http.Error
    | Success TodoItemList


type Model
    = Model { data : Loading }


init : Api.Api -> ( Model, Cmd Msg )
init api =
    ( Model { data = LoadingData }
    , fetchTodoItems api
    )


type Msg
    = FetchedTodoItems (Result Http.Error TodoItemList)
    | ClickedJSPort Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ((Model model) as modelRaw) =
    case msg of
        FetchedTodoItems (Err httpError) ->
            ( Model { model | data = Error httpError }
            , Cmd.none
            )

        FetchedTodoItems (Ok data) ->
            ( Model { model | data = Success data }
            , Cmd.none
            )

        ClickedJSPort valueToJs ->
            ( modelRaw
            , sendToJs <| Encode.int valueToJs
            )


view : (Msg -> msg) -> Model -> Browser.Document msg
view wrapMsg (Model { data }) =
    { title = "Todo List Page"
    , body =
        [ Header.view <| Just Route.TodoList
        , Html.map wrapMsg <|
            Html.div Styles.centeredColumn
                [ Html.h1 [] [ Html.text "Todo list" ]
                , Html.button
                    [ Attributes.style "padding-top" "20px"
                    , Events.onClick <| ClickedJSPort 42
                    ]
                    [ Html.text "Port to JS" ]
                , Html.div [ Attributes.style "padding-top" "20px" ] [ dataView data ]
                ]
        ]
    }


dataView : Loading -> Html.Html Msg
dataView loading =
    case loading of
        LoadingData ->
            Html.text "Loading ..."

        Error _ ->
            Html.text "Something went wrong ..."

        Success data ->
            data
                |> List.map todoItemView
                |> Html.div []


todoItemView : TodoItem -> Html.Html msg
todoItemView { label2 } =
    Html.div [] [ Html.text label2 ]
