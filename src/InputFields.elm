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


concat3elements : a -> a -> a -> List a
concat3elements a b c =
    [ a, b, c ]


mkInputs : Int -> Point -> PointInput
mkInputs index p =
    let
        inputField =
            \axis ->
                \axisAccessor ->
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
                        , HtmlA.max <| toString <| axisAccessor canvasSize
                        , HtmlA.defaultValue <| toString <| axisAccessor p
                        , onInput (ChangeCoordinate index axis)
                        ]
                        []
    in
        { x = { index = index, field = inputField X .x }
        , y = { index = index, field = inputField Y .y }
        }



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
