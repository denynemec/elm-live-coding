module Styles exposing (centeredColumn, todoItemCheckStyle, todoItemListListStyle, todoItemStyle)

import Html exposing (Attribute)
import Html.Attributes as Attributes


centeredColumn : List (Attribute msg)
centeredColumn =
    [ Attributes.style "flex-direction" "column"
    , Attributes.style "display" "flex"
    , Attributes.style "align-items" "center"
    ]


todoItemListListStyle : List (Attribute msg)
todoItemListListStyle =
    [ Attributes.style "padding" "0"
    , Attributes.style "margin" "0"
    ]


todoItemStyle : List (Attribute msg)
todoItemStyle =
    [ Attributes.style "list-Attributes.style-type" "none"
    , Attributes.style "display" "flex"
    , Attributes.style "margin-bottom" ".5rem"
    , Attributes.style "background" "#D8D9D7"
    , Attributes.style "padding" ".75rem"
    , Attributes.style "border-radius" ".5rem"
    ]


todoItemCheckStyle : List (Attribute msg)
todoItemCheckStyle =
    [ Attributes.style "width" "1rem"
    , Attributes.style "height" "1rem"
    , Attributes.style "border" "1px solid #0D0D0D"
    , Attributes.style "border-radius" "50%"
    , Attributes.style "margin-right" ".5rem"
    , Attributes.style "text-align" "center"
    , Attributes.style "cursor" "pointer"
    ]
