module View exposing (..)

{-| Should just chain Drawing functions together
-> drawCanvas = literally drawPyramid ++ drawAnnotations ++ drawOtherCrap
-}

import Html exposing (Html)
import Svg
import Svg.Attributes as SvgA
import Array exposing (Array)
import Model exposing (Model)
import Update exposing (Msg)
import Types exposing (..)
import Drawing as D
import Perspective exposing (ViewPoint(..))
import InputFields exposing (..)


canvasSize : { x : Float, y : Float }
canvasSize =
    { x = 600, y = 400 }


canvas : List (Html.Attribute Msg)
canvas =
    let
        canvasString =
            [ 0, 0, canvasSize.x, canvasSize.y ]
                |> List.map toString
                |> String.join " "
    in
        [ SvgA.viewBox canvasString, SvgA.width "600px" ]


coordinateFields : Array Point -> Array PointInput
coordinateFields =
    Array.indexedMap mkInputs


concat3elements : a -> a -> a -> List a
concat3elements a b c =
    [ a, b, c ]


view : Model -> Html.Html Msg
view pyramid =
    let
        pyramidDrawing =
            D.drawPyramid pyramid Top

        pointInputs =
            coordinateFields pyramid.basePolygon

        xInputs =
            Array.toList <| Array.map .field <| Array.map .x pointInputs

        yInputs =
            Array.toList <| Array.map .field <| Array.map .y pointInputs

        brs =
            List.repeat (List.length xInputs) (Html.br [] [])

        inputFields =
            List.concat <| List.map3 concat3elements xInputs yInputs brs

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



-- Html.div
-- []
-- [ Svg.svg canvas drawing
-- ]
-- let
--     edges =
--         pyramid |> U.pyramidEdges
--     pyramidDrawing =
--         edges |> D.drawLines
--     annotations =
--         List.map (D.lineAnnotation "25.8°") edges
--     drawing =
--         annotations ++ pyramidDrawing ++ [ D.border ]
-- in
--     Html.div []
--         [ Html.table []
--             [ Html.tr []
--                 [ Html.td []
--                     ([ Html.br [] []
--                      , Html.br [] []
--                      ]
--                     )
--                 , Html.td []
--                     [ Svg.svg [ SvgA.viewBox canvas, SvgA.width "600px" ] drawing
--                     ]
--                 ]
--             ]
--         ]
