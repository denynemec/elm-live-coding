module Page.Counter exposing (Model, Msg, init, update, view)

import Browser
import Components.Header as Header
import Html
import Html.Attributes as Attributes
import Html.Events as Events
import Route
import Styles



-- TODO: 1) Implement Increment logic
-- TODO: 2) Add Decrement msg


type alias Model =
    Int


init : ( Model, Cmd Msg )
init =
    ( 0
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
view wrapMsg model =
    { title = "Counter Page"
    , body =
        [ Header.view <| Just Route.Counter
        , Html.map wrapMsg <|
            Html.div Styles.centeredColumn
                [ Html.h1 [] [ Html.text "Counter" ]
                , Html.div [ Attributes.style "padding-top" "20px" ]
                    [ Html.button
                        [ Events.onClick Increment
                        , Attributes.style "width" "100px"
                        ]
                        [ Html.text "Increment!" ]
                    ]
                , Html.text <| "Current value: " ++ String.fromInt model
                ]
        ]
    }
