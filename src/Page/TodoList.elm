module Page.TodoList exposing (Model, Msg, init, update, view)

import Browser
import Components.Header as Header
import Html
import Html.Attributes as Attributes
import Route
import Styles



-- TODO: 1) Add fetch todo list
-- TODO: 2) Get api from Flags
-- TODO: 3) Add simple playground page
-- TODO: 4) Trigger port on button click
-- TODO: 5) Implement Api module as Opaque type
-- TODO: 6) Implement Page models as opaque type and compare with previous implementation


type alias Model =
    ()


init : ( Model, Cmd Msg )
init =
    ( ()
    , Cmd.none
    )


type Msg
    = Increment


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( model
            , Cmd.none
            )


view : (Msg -> msg) -> Model -> Browser.Document msg
view wrapMsg _ =
    { title = "Todo List Page"
    , body =
        [ Header.view <| Just Route.TodoList
        , Html.map wrapMsg <|
            Html.div Styles.centeredColumn
                [ Html.h1 [] [ Html.text "Todo list" ]
                , Html.div [ Attributes.style "padding-top" "20px" ]
                    []
                ]
        ]
    }
