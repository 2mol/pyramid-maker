module Math
    exposing
        ( pyramidToEdges
        , lastElem
        , addPoint
        )

import Types exposing (..)
import Array exposing (Array)


-- getting edges from a pyramid:


pyramidToEdges : Pyramid -> List Edge
pyramidToEdges { basePolygon, tip } =
    let
        ridges =
            basePolygon
                |> Array.toList
                |> List.map (Edge tip)

        -- Array.toList <| Array.map (Edge tip) basePolygon
        perimeter =
            basePolygon
                |> Array.toList
                |> polygonToEdges tip
    in
        ridges ++ perimeter


polygonToEdges : Point -> List Point -> List Edge
polygonToEdges tip polygon =
    let
        orderedPolygon =
            polygon |> List.sortWith (compareAngle tip)
    in
        case orderedPolygon of
            x1 :: x2 :: xs ->
                List.scanl perimeterScanner (Edge x1 x2) (xs ++ [ x1 ])

            _ ->
                []


perimeterScanner : Point -> Edge -> Edge
perimeterScanner nextPoint { end } =
    Edge end nextPoint



-- because Array is lacking:


lastElem : Array a -> Maybe a
lastElem =
    Array.foldl (Just >> always) Nothing



-- sort vectors/points by angle:


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



-- add a point to an array in a hopefully clever way in the future:


addPoint : Array Point -> Array Point
addPoint basePolygon =
    let
        newPoint =
            case ( Array.get 0 basePolygon, lastElem basePolygon ) of
                ( Just p0, Just pn ) ->
                    Point ((p0.x + pn.x) / 2) ((p0.y + pn.y) / 2)

                _ ->
                    Point 20 20
    in
        Array.push newPoint basePolygon
