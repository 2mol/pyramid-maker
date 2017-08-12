module View exposing (..)

{-| Should just chain Drawing functions together
-> drawCanvas = literally drawPyramid ++ drawAnnotations ++ drawOtherCrap
-}

import Html exposing (Html)
import Svg
import Svg.Attributes as SvgA
import Model exposing (Model)
import Update exposing (Msg)
import Drawing as D
import Perspective exposing (ViewPoint(..))


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


view : Model -> Html.Html Msg
view pyramid =
    let
        pyramidDrawing =
            D.drawPyramid pyramid Top

        annotationsDrawing =
            []

        borderDrawing =
            []

        drawing =
            pyramidDrawing ++ annotationsDrawing ++ borderDrawing
    in
        Html.div []
            [ Svg.svg canvas drawing
            ]



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
