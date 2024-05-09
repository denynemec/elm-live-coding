module Page.Playground exposing (Model, Msg, init, update, view)

import Browser
import Components.Button as Button
import Components.Header as Header
import Html
import Html.Attributes as Attributes
import Route
import Styles
import Taco


type alias Model =
    ()


init : ( Model, Cmd Msg )
init =
    ( ()
    , Cmd.none
    )


type Msg
    = ClickedRefreshToken


update : Msg -> Model -> ( Model, Cmd Msg, Taco.TacoMsg )
update msg model =
    case msg of
        ClickedRefreshToken ->
            ( model
            , Cmd.none
            , Taco.RefreshToken
            )


view : (Msg -> msg) -> Model -> Browser.Document msg
view wrapMsg _ =
    { title = "Playground Page"
    , body =
        [ Header.view <| Just Route.Playground
        , Html.map wrapMsg <|
            Html.div Styles.centeredColumn
                [ Html.h1 [] [ Html.text "Playground" ]
                , Html.div [ Attributes.style "padding-top" "20px" ]
                    [ Button.view ClickedRefreshToken "Refresho token!" ]
                ]
        ]
    }
