module View exposing (..)

{-| Should just chain Drawing functions together
-> drawCanvas = literally drawPyramid ++ drawAnnotations ++ drawOtherCrap
-}

import Html exposing (Html)
import Svg
import Model exposing (Model)
import Update exposing (Msg)
import Drawing as D
import Perspective exposing (ViewPoint(..))
import InputFields exposing (formatInputs)


-- List.concat <| fields ++ [ breaks ]


view : Model -> Html Msg
view pyramid =
    let
        -- title =
        --     D.drawTitle "Pyramid Maker"
        inputFields =
            formatInputs pyramid.basePolygon

        inputColumn =
            D.wrapInputColumn inputFields "Pyramid Maker"

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

            -- , Html.tr []
            --     [ Html.td []
            --         [ draw drawing
            --         ]
            --     , Html.td []
            --         [ draw drawing
            --         ]
            --     ]
            ]
