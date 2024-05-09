module Main exposing (main)

import Api
import Browser
import Browser.Navigation as Navigation
import Page.Counter as Counter
import Page.NotFound as NotFound
import Page.Playground as Playground
import Page.TodoList as TodoList
import Route
import Taco
import Url


type alias Flags =
    { api : String
    , counter : Int
    }


type alias Model =
    { flags : Flags
    , key : Navigation.Key
    , page : Page
    , taco : Taco.Taco
    }


type Page
    = Counter Counter.Model
    | TodoList TodoList.Model
    | Playground Playground.Model
    | NotFound


type Msg
    = ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest
    | TodoListMsg TodoList.Msg
    | CounterMsg Counter.Msg
    | PlaygroundMsg Playground.Msg


init : Flags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        api =
            Api.init
                { apiPrefix = flags.api
                , token = "MAIN INIT TOKEN"
                }
    in
    url
        |> urlToPage flags api
        |> Tuple.mapFirst
            (\page ->
                { flags = flags
                , key = key
                , page = page
                , taco = Taco.init api
                }
            )


urlToPage : Flags -> Api.Api -> Url.Url -> ( Page, Cmd Msg )
urlToPage flags api =
    Route.fromUrl
        >> Maybe.map (routeToPage flags api)
        >> Maybe.withDefault ( NotFound, Cmd.none )


routeToPage : Flags -> Api.Api -> Route.Route -> ( Page, Cmd Msg )
routeToPage { counter } api route =
    case route of
        Route.TodoList ->
            TodoList.init api
                |> Tuple.mapBoth TodoList (Cmd.map TodoListMsg)

        Route.Counter ->
            Counter.init counter
                |> Tuple.mapBoth Counter (Cmd.map CounterMsg)

        Route.Playground ->
            Playground.init
                |> Tuple.mapBoth Playground (Cmd.map PlaygroundMsg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ flags, key, page, taco } as model) =
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
                |> urlToPage flags (Taco.getApi taco)
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

        PlaygroundMsg pageMsg ->
            case page of
                Playground pageModel ->
                    pageModel
                        |> Playground.update pageMsg
                        |> (\( pageModel_, pageCmd, tacoMsg ) ->
                                let
                                    updatedTaco =
                                        Taco.update tacoMsg taco
                                in
                                ( { model
                                    | page = Playground pageModel_
                                    , taco = updatedTaco
                                  }
                                , Cmd.map PlaygroundMsg pageCmd
                                )
                           )

                _ ->
                    noUpdate


view : Model -> Browser.Document Msg
view { page } =
    case page of
        Counter counterModel ->
            Counter.view CounterMsg counterModel

        TodoList todoListModel ->
            TodoList.view TodoListMsg todoListModel

        Playground playgroundModel ->
            Playground.view PlaygroundMsg playgroundModel

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
