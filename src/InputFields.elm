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


formatInputs : Array Point -> List (Html Msg)
formatInputs points =
    let
        pointInputs =
            Array.indexedMap mkInputs points

        axisSelector =
            \axis -> Array.toList <| Array.map .field <| Array.map axis pointInputs

        xInputs =
            axisSelector .x

        yInputs =
            axisSelector .y

        breaks =
            List.repeat (List.length xInputs) (Html.br [] [])
    in
        List.concat <| List.map3 concat3elements xInputs yInputs breaks


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


concat3elements : a -> a -> a -> List a
concat3elements a b c =
    [ a, b, c ]
