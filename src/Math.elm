module Math
    exposing
        ( pyramidToEdges
        , lastElem
        , addPoint
        )

import Types exposing (..)
import Array exposing (Array)
import Random
import Config as C exposing (..)


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


randInt : Random.Generator Int
randInt =
    Random.int 1 100


randomPoint : Random.Generator ( Int, Int )
randomPoint =
    let
        cs =
            C.canvasSize
    in
        Random.pair (Random.int 0 (truncate cs.x)) (Random.int 0 (truncate cs.y))


coordAccum : Point -> Int -> Int
coordAccum { x, y } acc =
    acc + truncate x + truncate y


addPoint : Array Point -> Array Point
addPoint basePolygon =
    let
        seed =
            Array.foldl coordAccum 0 basePolygon

        ( ( x, y ), _ ) =
            Random.step randomPoint (Random.initialSeed seed)

        newPoint =
            Point (toFloat x) (toFloat y)
    in
        Array.push newPoint basePolygon
