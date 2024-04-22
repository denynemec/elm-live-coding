module Styles exposing (centeredColumn)

import Html exposing (Attribute)
import Html.Attributes as Attributes


centeredColumn : List (Attribute msg)
centeredColumn =
    [ Attributes.style "flex-direction" "column"
    , Attributes.style "display" "flex"
    , Attributes.style "align-items" "center"
    ]
