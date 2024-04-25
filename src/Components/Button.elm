module Components.Button exposing (view)

import Html
import Html.Attributes as Attributes
import Html.Events as Events


view : msg -> String -> Html.Html msg
view msg text =
    Html.button
        [ Events.onClick msg
        , Attributes.style "width" "100px"
        ]
        [ Html.text text ]
