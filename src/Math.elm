module Math exposing (pyramidToEdges)

import Types exposing (..)
import Array exposing (Array)


pyramidToEdges : Pyramid -> Array Edge
pyramidToEdges { basePolygon, top, height } =
    let
        ridges =
            Array.map (Edge top) basePolygon

        sortedBasePolygon =
            basePolygon
                |> Array.toList
                |> List.sortWith (compareAngle top)
                |> Array.fromList

        perimeter =
            polygonToEdges sortedBasePolygon
    in
        Array.append ridges perimeter


polygonToEdges : Array Point -> Array Edge
polygonToEdges p =
    let
        pList =
            Array.toList p

        maybeLastPoint =
            lastElem p
    in
        case maybeLastPoint of
            Just lastPoint ->
                let
                    lastEdge =
                        Edge lastPoint lastPoint
                in
                    Array.fromList <| List.scanl perimeterScanner lastEdge pList

            _ ->
                Array.empty


lastElem : Array a -> Maybe a
lastElem =
    Array.foldl (Just >> always) Nothing


perimeterScanner : Point -> Edge -> Edge
perimeterScanner nextPoint lastEdge =
    let
        { start, end } =
            lastEdge
    in
        Edge end nextPoint



--
-- sortPyramidByAngle : Pyramid -> Pyramid
-- sortPyramidByAngle pyramid =
--     let
--         sortedBasePolygon =
--             pyramid.basePolygon
--                 |> Array.toList
--                 |> List.sortWith (compareAngle pyramid.top)
--                 |> Array.fromList
--     in
--         { pyramid | basePolygon = sortedBasePolygon }


compareAngle : Point -> Point -> Point -> Order
compareAngle p p1 p2 =
    compare (edgeAngle p p1) (edgeAngle p p2)


edgeAngle : Point -> Point -> Float
edgeAngle p1 p2 =
    let
        x =
            p2.x - p1.x

        y =
            p2.y - p1.y

        hyp =
            sqrt (x ^ 2 + y ^ 2)

        angle =
            acos (x / hyp)
    in
        if y > 0 then
            angle
        else
            -1 * angle
