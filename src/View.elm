module View exposing (..)

{-| Should just chain Drawing functions together
-}

import Html exposing (Html)
import Svg
import Types exposing (..)
import Drawing as D
import Perspective exposing (ViewPoint(..))
import InputFields exposing (pointsToInputs, addRemoveButtons)


view : Model -> Html Msg
view pyramid =
    let
        -- title =
        --     D.drawTitle "Pyramid Maker"
        coordinateFields =
            pointsToInputs pyramid.basePolygon

        inputs =
            addRemoveButtons :: coordinateFields

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
