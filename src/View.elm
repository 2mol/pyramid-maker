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
        -- title =
        --     D.drawTitle "Pyramid Maker"
        coordinateFields =
            I.pointsToInputs pyramid.basePolygon

        inputs =
            I.randomButton :: I.addRemoveButtons :: coordinateFields

        inputColumn =
            D.wrapInputColumn inputs "Pyramid Maker"

        annotationsDrawing =
            []

        borderDrawing =
            []

        drawing =
            Svg.svg D.canvas <|
                (D.drawPyramid pyramid Top)
                    ++ annotationsDrawing
                    ++ [ D.border ]
    in
        Html.table []
            [ Html.tr []
                [ inputColumn
                , Html.td []
                    [ drawing
                    ]
                ]
            ]
