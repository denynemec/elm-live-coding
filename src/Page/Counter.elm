module Page.Counter exposing (Model, Msg, init, update, view)

import Browser
import Components.Header as Header
import Html
import Html.Attributes as Attributes
import Html.Events as Events
import Route
import Styles



-- TODO: 1) Implement Increment logic DONE
-- TODO: 2) Add Decrement msg


type alias Model =
    Int


init : ( Model, Cmd Msg )
init =
    ( 42
    , Cmd.none
    )


type Msg
    = Increment
    | Decrement Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( model + 1
            , Cmd.none
            )

        Decrement decrementValue ->
            ( model - decrementValue
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
                , buttonView "Increment" Increment
                , Html.text <| "Current value: " ++ String.fromInt model
                , buttonView "Decrement 3" (Decrement 3)
                , buttonView "Decrement 7" <| Decrement 7
                ]
        ]
    }


buttonView : String -> msg -> Html.Html msg
buttonView text msg =
    Html.div [ Attributes.style "padding-top" "20px" ]
        [ Html.button
            [ Events.onClick msg
            , Attributes.style "width" "100px"
            ]
            [ Html.text text ]
        ]
