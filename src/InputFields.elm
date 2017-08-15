module InputFields
    exposing
        ( pointsToInputs
        , addRemoveButtons
        , randomButton
        )

import Array exposing (Array)
import Html exposing (Html)
import Html.Attributes as HtmlA
import Html.Events exposing (onInput, onClick)
import Types exposing (..)
import Config exposing (canvasSize)


-- Input Fields:


pointsToInputs : Array Point -> List (Html Msg)
pointsToInputs points =
    let
        pointInputs =
            Array.indexedMap mkInputPair points

        -- axisSelector =
        --     \axis -> Array.toList <| Array.map .field <| Array.map axis pointInputs
        xInputs =
            Array.toList <| Array.map Tuple.first pointInputs

        yInputs =
            Array.toList <| Array.map Tuple.second pointInputs

        breaks =
            List.repeat (Array.length pointInputs) (Html.br [] [])
    in
        List.concat <| List.map3 concat3elements xInputs yInputs breaks


concat3elements : a -> a -> a -> List a
concat3elements a b c =
    [ a, b, c ]


mkInputPair : Int -> Point -> ( Html Msg, Html Msg )
mkInputPair index p =
    let
        inputFieldX =
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
                , HtmlA.max <| toString <| .x canvasSize
                , HtmlA.defaultValue <| toString <| .x p
                , onInput (\s -> changePoint s "" p index)
                ]
                []

        inputFieldY =
            Html.input
                [ HtmlA.type_ "number"
                , HtmlA.step "any"
                , HtmlA.style
                    [ ( "width", "80px" )
                    ]
                , HtmlA.min "0"
                , HtmlA.max <| toString <| .y canvasSize
                , HtmlA.defaultValue <| toString <| .y p
                , onInput (\s -> changePoint "" s p index)
                ]
                []
    in
        ( inputFieldX, inputFieldY )


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
        ChangePoint index { oldPoint | x = newx, y = newy }



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
