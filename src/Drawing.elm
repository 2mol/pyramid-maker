module Drawing exposing (..)

import Svg
import Svg.Attributes as SvgA
import Types exposing (..)


drawLine : Edge -> Svg.Svg msg
drawLine { start, end } =
    let
        lineCoord =
            List.map toString [ start.x, end.x, start.y, end.y ]

        svgLineCoord =
            List.map2 (<|) [ SvgA.x1, SvgA.x2, SvgA.y1, SvgA.y2 ] lineCoord

        lineParameters =
            [ SvgA.stroke "black", SvgA.strokeWidth "0.2" ]
    in
        Svg.line (svgLineCoord ++ lineParameters) []


drawLines : List Edge -> List (Svg.Svg msg)
drawLines l =
    List.map drawLine l


scale : Float -> Float -> Float -> Float -> Float
scale x y xMax yMax =
    if (xMax / yMax < x / y) then
        -- scale on y axis
        y / yMax
    else
        x / xMax


getScaleFactor : Float -> Float -> List Point -> Float
getScaleFactor x y p =
    let
        xMax_ =
            p
                |> List.map .x
                |> List.maximum

        yMax_ =
            p
                |> List.map .y
                |> List.maximum
    in
        case ( xMax_, yMax_ ) of
            ( Just xMax, Just yMax ) ->
                scale x y xMax yMax

            other ->
                1


scaleLine : Float -> Edge -> Edge
scaleLine r { start, end } =
    { start = { x = r * start.x, y = r * start.y }
    , end = { x = r * end.x, y = r * end.y }
    }


scaleLines : Float -> List Edge -> List Edge
scaleLines r edges =
    List.map (scaleLine r) edges



-- some static stuff:
