module Utils_
    exposing
        ( pyramidEdges
        , lineMiddle
        )

import Types exposing (..)
import Array exposing (Array)


pyramidEdges : Pyramid -> List Edge
pyramidEdges { basePolygon, top } =
    let
        ridges =
            Array.map (Edge top) basePolygon

        perimeter =
            Array.fromList <| polygonLines basePolygon
    in
        Array.toList <| Array.append ridges perimeter



-- pyramidFront : Pyramid -> List Edge
-- pyramidFront pyramid =
--     let
--         newBasePolygon =
--             pyramid.basePolygon
--         newTop =
--             pyramid.top
--         newPyramid =
--             { pyramid | basePolygon = newBasePolygon, top = newTop }
--     in
--         pyramidEdges newPyramid


polygonLinesHelper : Array Point -> List Edge
polygonLinesHelper p =
    -- this function only manages to give the perimeter with last line missing
    let
        pl =
            Array.toList p
    in
        case pl of
            x1 :: x2 :: xs ->
                Edge x1 x2 :: polygonLinesHelper (Array.fromList (x2 :: xs))

            other ->
                []


polygonLines : Array Point -> List Edge
polygonLines p =
    if Array.isEmpty p then
        []
    else
        polygonLinesHelper (Array.append p (Array.slice 0 1 p))



-- case p of
--     [] ->
--         []
--     x :: xs ->
--         polygonLinesHelper (x :: xs ++ [ x ])


lineMiddle : Edge -> Point
lineMiddle { start, end } =
    { x = (start.x + end.x) / 2
    , y = (start.y + end.y) / 2
    }
