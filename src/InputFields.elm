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
pointsToInputs { basePolygon, tip, height } =
    let
        polygonInputs =
            Array.toList <| Array.indexedMap mkInputPair basePolygon

        tipInputs =
            mkInputPair -1 tip

        heightInput =
            heightField height
    in
        heightInput :: tipInputs :: polygonInputs


mkInputPair : Int -> Point2D -> Html Msg
mkInputPair index point =
    Html.div []
        [ inputField X index point
        , inputField Y index point
        , Html.br [] []
        ]


inputField : Axis -> Int -> Point2D -> Html Msg
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
                , ( "border", "thin solid #dddddd" )
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


heightField : Float -> Html Msg
heightField height =
    let
        onInputEvent =
            onInput (\s -> changeHeight s height)
    in
        Html.input
            [ HtmlA.type_ "number"
            , HtmlA.step "any"
            , HtmlA.style
                [ ( "width", "80px" )
                , ( "border", "thin solid #ffaaaa" )
                ]
            , HtmlA.min "0"
            , HtmlA.defaultValue <| toString <| height
            , onInputEvent
            ]
            []


changePoint : String -> String -> Point2D -> Int -> Msg
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


changeHeight : String -> Float -> Msg
changeHeight hString oldHeight =
    let
        newh =
            case String.toFloat hString of
                Ok h ->
                    h

                _ ->
                    oldHeight
    in
        Change <| ChangeHeight newh



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
