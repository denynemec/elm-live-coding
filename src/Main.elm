module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Html
import Page.Counter as Counter
import Page.NotFound as NotFound
import Page.TodoList as TodoList
import Route
import Url


type alias Flags =
    ()


type alias Model =
    { api : String
    , key : Navigation.Key
    , page : Page
    }


type Page
    = Counter Counter.Model
    | TodoList TodoList.Model
    | NotFound


type Msg
    = ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest
    | TodoListMsg TodoList.Msg
    | CounterMsg Counter.Msg


api_ : String
api_ =
    ""


init : Flags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    url
        |> urlToPage
        |> Tuple.mapFirst
            (\page ->
                { api = api_
                , key = key
                , page = page
                }
            )


urlToPage : Url.Url -> ( Page, Cmd Msg )
urlToPage =
    Route.fromUrl
        >> Maybe.map routeToPage
        >> Maybe.withDefault ( NotFound, Cmd.none )


routeToPage : Route.Route -> ( Page, Cmd Msg )
routeToPage route =
    case route of
        Route.TodoList ->
            TodoList.init
                |> Tuple.mapBoth TodoList (Cmd.map TodoListMsg)

        Route.Counter ->
            Counter.init
                |> Tuple.mapBoth Counter (Cmd.map CounterMsg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ key, page } as model) =
    let
        noUpdate =
            ( model
            , Cmd.none
            )
    in
    case msg of
        ClickedLink urlRequest ->
            ( model
            , case urlRequest of
                Browser.Internal url ->
                    url
                        |> Url.toString
                        |> Navigation.pushUrl key

                Browser.External href ->
                    Navigation.load href
            )

        ChangedUrl url ->
            url
                |> urlToPage
                |> Tuple.mapFirst (\page_ -> { model | page = page_ })

        CounterMsg pageMsg ->
            case page of
                Counter pageModel ->
                    pageModel
                        |> Counter.update pageMsg
                        |> Tuple.mapBoth
                            (\pageModel_ -> { model | page = Counter pageModel_ })
                            (Cmd.map CounterMsg)

                _ ->
                    noUpdate

        TodoListMsg pageMsg ->
            case page of
                TodoList pageModel ->
                    pageModel
                        |> TodoList.update pageMsg
                        |> Tuple.mapBoth
                            (\pageModel_ -> { model | page = TodoList pageModel_ })
                            (Cmd.map TodoListMsg)

                _ ->
                    noUpdate


view : Model -> Browser.Document Msg
view { page } =
    case page of
        Counter counterModel ->
            Counter.view CounterMsg counterModel

        TodoList todoListModel ->
            TodoList.view TodoListMsg todoListModel

        NotFound ->
            NotFound.view


main : Program Flags Model Msg
main =
    Browser.application
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        }
