module InputFields exposing (..)

import Array exposing (Array)
import Html exposing (Html)
import Html.Attributes as HtmlA
import Html.Events exposing (onInput)
import Update exposing (Msg(..))
import Types exposing (..)


type alias CoordinatesInput =
    { index : Int
    , field : Html Msg
    }


type alias PointInput =
    { x : CoordinatesInput
    , y : CoordinatesInput
    }


mkInputs : Int -> Point -> PointInput
mkInputs index p =
    let
        inputFieldX =
            Html.input
                [ HtmlA.type_ "number"

                -- , HtmlA.placeholder <| toString i
                -- , HtmlA.disabled True
                --, HtmlA.name "quantity"
                -- , HtmlA.min "0"
                -- , HtmlA.max "10"
                , HtmlA.defaultValue <| toString p.x
                , onInput (ChangePoint index X)
                ]
                []

        inputFieldY =
            Html.input
                [ HtmlA.type_ "number"
                , HtmlA.defaultValue <| toString p.y
                , onInput (ChangePoint index Y)
                ]
                []
    in
        { x = { index = index, field = inputFieldX }
        , y = { index = index, field = inputFieldY }
        }


coordinateFields : Array Point -> Array PointInput
coordinateFields =
    Array.indexedMap mkInputs


concat3elements : a -> a -> a -> List a
concat3elements a b c =
    [ a, b, c ]
