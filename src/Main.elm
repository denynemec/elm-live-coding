module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Page.Counter as Counter
import Page.NotFound as NotFound
import Page.TodoList as TodoList
import Route
import Url


type alias Flags =
    { api : String
    , counter : Int
    }


type alias Model =
    { flags : Flags
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


init : Flags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    url
        |> urlToPage flags
        |> Tuple.mapFirst
            (\page ->
                { flags = flags
                , key = key
                , page = page
                }
            )


urlToPage : Flags -> Url.Url -> ( Page, Cmd Msg )
urlToPage flags =
    Route.fromUrl
        >> Maybe.map (routeToPage flags)
        >> Maybe.withDefault ( NotFound, Cmd.none )


routeToPage : Flags -> Route.Route -> ( Page, Cmd Msg )
routeToPage { api, counter } route =
    case route of
        Route.TodoList ->
            TodoList.init api
                |> Tuple.mapBoth TodoList (Cmd.map TodoListMsg)

        Route.Counter ->
            Counter.init counter
                |> Tuple.mapBoth Counter (Cmd.map CounterMsg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ flags, key, page } as model) =
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
                |> urlToPage flags
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
