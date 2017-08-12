module View exposing (..)

{-| Should just chain Drawing functions together
-> drawCanvas = literally drawPyramid ++ drawAnnotations ++ drawOtherCrap
-}

import Html exposing (Html)
import Svg
import Model exposing (Model)
import Update exposing (Msg)
import Drawing exposing (canvas, drawPyramid)
import Perspective exposing (ViewPoint(..))
import InputFields exposing (formatInputs)


-- List.concat <| fields ++ [ breaks ]


view : Model -> Html.Html Msg
view pyramid =
    let
        inputFields =
            formatInputs pyramid.basePolygon

        annotationsDrawing =
            []

        borderDrawing =
            []

        drawing =
            Svg.svg canvas <|
                (drawPyramid pyramid Top)
                    ++ annotationsDrawing
                    ++ borderDrawing
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
