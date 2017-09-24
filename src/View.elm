module View exposing (view)

{-| Should just chain Drawing functions together
-}

import Html exposing (Html)
import Svg
import Types exposing (..)
import Drawing as D
import Perspective exposing (ViewPoint(..))
import InputFields as I
import Update as U


view : Model -> Html Msg
view ({ pyramid, drag } as model) =
    let
        -- drawing stuff:
        livePyramid =
            case drag of
                Nothing ->
                    pyramid

                Just _ ->
                    U.getLivePyramid model

        pyramidDrawing =
            D.drawPyramid livePyramid Top

        -- input stuff:
        coordinateFields =
            I.pointsToInputs livePyramid

        inputs =
            I.randomButton :: I.addRemoveButtons :: coordinateFields

        inputColumn =
            D.wrapInputColumn inputs "Pyramid Maker"

        -- other layers:
        borderDrawing =
            D.border

        -- all together now:
        drawing =
            Svg.svg D.canvas <|
                [ pyramidDrawing
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
