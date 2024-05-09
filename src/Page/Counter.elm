port module Page.Counter exposing (Model, Msg, init, update, view)

import Browser
import Components.Button as Button
import Components.Header as Header
import Html
import Html.Attributes as Attributes
import Json.Encode as Encode
import Route
import Styles


port saveCounter : Encode.Value -> Cmd msg



-- TODO: 1) Implement Increment logic
-- TODO: 2) Add Decrement msg


type Model
    = ModelInternal { counter : Int }


init : Int -> ( Model, Cmd Msg )
init initCounter =
    ( ModelInternal { counter = initCounter }
    , Cmd.none
    )


type Msg
    = Increment
    | Decrement Int
    | ClickedCallJS


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ((ModelInternal ({ counter } as modelPayload)) as model) =
    case msg of
        Increment ->
            ( ModelInternal { modelPayload | counter = counter + 1 }
            , Cmd.none
            )

        Decrement decrementValue ->
            ( ModelInternal { modelPayload | counter = counter - decrementValue }
            , Cmd.none
            )

        ClickedCallJS ->
            ( model
            , saveCounter <| Encode.int counter
            )


view : (Msg -> msg) -> Model -> Browser.Document msg
view wrapMsg (ModelInternal { counter }) =
    { title = "Counter Page"
    , body =
        [ Header.view <| Just Route.Counter
        , Html.map wrapMsg <|
            Html.div Styles.centeredColumn
                [ Html.h1 [] [ Html.text "Counter" ]
                , Html.div [ Attributes.style "padding-top" "20px" ]
                    [ Button.view Increment "Increment!"
                    , Button.view (Decrement 2) "Decrement 2!"
                    , Button.view (Decrement 5) "Decrement 5!"
                    , Button.view ClickedCallJS "Save counter!"
                    ]
                , Html.text <| "Current value: " ++ String.fromInt counter
                ]
        ]
    }
