module View exposing (..)

{-| Should just chain Drawing functions together
-}

import Html exposing (Html)
import Svg
import Types exposing (..)
import Drawing as D
import Perspective exposing (ViewPoint(..))
import InputFields as I


view : Model -> Html Msg
view { pyramid, drag } =
    let
        -- input stuff:
        coordinateFields =
            I.pointsToInputs pyramid

        inputs =
            I.randomButton :: I.addRemoveButtons :: coordinateFields

        inputColumn =
            D.wrapInputColumn inputs "Pyramid Maker"

        -- drawing stuff:
        pyramidDrawing =
            D.drawPyramid pyramid Top

        annotationsDrawing =
            Svg.g [] []

        borderDrawing =
            D.border

        drawing =
            Svg.svg D.canvas <|
                [ pyramidDrawing
                , annotationsDrawing
                , borderDrawing
                ]
    in
        Html.table []
            [ Html.tr []
                [ inputColumn
                , Html.td []
                    [ drawing
                    ]
                ]
            ]
