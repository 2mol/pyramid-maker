module View exposing (..)

{-| Should just chain Drawing functions together
-> drawCanvas = literally drawPyramid ++ drawAnnotations ++ drawOtherCrap
-}

import Html exposing (Html)
import Svg
import Array exposing (Array)
import Model exposing (Model)
import Update exposing (Msg)
import Drawing exposing (canvas, drawPyramid)
import Perspective exposing (ViewPoint(..))
import InputFields exposing (..)


view : Model -> Html.Html Msg
view pyramid =
    let
        pyramidDrawing =
            drawPyramid pyramid Top

        pointInputs =
            coordinateFields pyramid.basePolygon

        xInputs =
            Array.toList <| Array.map .field <| Array.map .x pointInputs

        yInputs =
            Array.toList <| Array.map .field <| Array.map .y pointInputs

        breaks =
            List.repeat (List.length xInputs) (Html.br [] [])

        inputFields =
            List.concat <| List.map3 concat3elements xInputs yInputs breaks

        annotationsDrawing =
            []

        borderDrawing =
            []

        drawing =
            Svg.svg canvas <| pyramidDrawing ++ annotationsDrawing ++ borderDrawing
    in
        Html.table []
            [ Html.tr []
                [ Html.td []
                    inputFields
                , Html.td []
                    [ drawing
                    ]
                ]

            -- , Html.tr []
            --     [ Html.td []
            --         [ draw drawing
            --         ]
            --     , Html.td []
            --         [ draw drawing
            --         ]
            --     ]
            ]
