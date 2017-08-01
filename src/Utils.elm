module Utils exposing (pyramidLines)

import Types exposing (..)


pyramidLines : Pyramid -> List Edge
pyramidLines { basePolygon, top } =
    let
        ridges =
            List.map (Edge top) basePolygon

        perimeter =
            polygonLines basePolygon
    in
        ridges ++ perimeter



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
--         pyramidLines newPyramid


polygonLinesHelper : List Point -> List Edge
polygonLinesHelper p =
    -- this function only manages to give the perimeter with last line missing
    case p of
        x1 :: x2 :: xs ->
            Edge x1 x2 :: polygonLinesHelper (x2 :: xs)

        other ->
            []


polygonLines : List Point -> List Edge
polygonLines p =
    case p of
        [] ->
            []

        x :: xs ->
            polygonLinesHelper (x :: xs ++ [ x ])
