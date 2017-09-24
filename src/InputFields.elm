module InputFields
    exposing
        ( pointsToInputs
        , addRemoveButtons
        , randomButton
        )

import Array
import Html exposing (Html)
import Html.Attributes as HtmlA
import Html.Events exposing (onInput, onClick)
import Types exposing (..)
import Config exposing (canvasSize)


-- Input Fields:


pointsToInputs : Pyramid -> List (Html Msg)
pointsToInputs { basePolygon, tip } =
    let
        polygonInputs =
            Array.toList <| Array.indexedMap mkInputPair basePolygon
    in
        mkInputPair -1 tip :: polygonInputs


mkInputPair : Int -> Point -> Html Msg
mkInputPair index point =
    Html.div []
        [ inputField X index point
        , inputField Y index point
        , Html.br [] []
        ]


inputField : Axis -> Int -> Point -> Html Msg
inputField axis index point =
    let
        ( value, maxValue, onInputEvent ) =
            case axis of
                X ->
                    ( point.x, canvasSize.x, onInput (\s -> changePoint s "" point index) )

                Y ->
                    ( point.y, canvasSize.y, onInput (\s -> changePoint "" s point index) )
    in
        Html.input
            [ HtmlA.type_ "number"
            , HtmlA.step "any"
            , HtmlA.style
                [ ( "width", "80px" )
                ]

            -- , HtmlA.placeholder <| toString i
            -- , HtmlA.disabled True
            --, HtmlA.name "quantity"
            , HtmlA.min "0"
            , HtmlA.max <| toString <| maxValue
            , HtmlA.defaultValue <| toString <| value
            , onInputEvent
            ]
            []


changePoint : String -> String -> Point -> Int -> Msg
changePoint xString yString oldPoint index =
    let
        newx =
            case String.toFloat xString of
                Ok x ->
                    x

                _ ->
                    oldPoint.x

        newy =
            case String.toFloat yString of
                Ok y ->
                    y

                _ ->
                    oldPoint.y
    in
        if index >= 0 then
            Change (ChangePolygonPoint index { oldPoint | x = newx, y = newy })
        else
            Change (ChangeTip { oldPoint | x = newx, y = newy })



-- Buttons:


addRemoveButtons : Html Msg
addRemoveButtons =
    Html.div []
        [ Html.button [ onClick RemovePoint ] [ Html.text "-" ]
        , Html.button [ onClick NewPoint ] [ Html.text "+" ]
        ]


randomButton : Html Msg
randomButton =
    Html.div []
        [ Html.button [ onClick Random ] [ Html.text "Random" ]
        ]
