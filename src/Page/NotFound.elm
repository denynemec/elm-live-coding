module Page.NotFound exposing (view)

import Browser
import Components.Header as Header
import Html
import Styles


view : Browser.Document msg
view =
    { title = "Not Found Page"
    , body =
        [ Header.view Nothing
        , Html.main_ Styles.centeredColumn
            [ Html.h1 [] [ Html.text "Not Found Page !!!" ] ]
        ]
    }
