module Math
    exposing
        ( pyramidToEdges
        , randomPoint
        )

import Types exposing (..)
import Array
import Random
import Config as C


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


randomPairGenerator : Random.Generator ( Int, Int )
randomPairGenerator =
    let
        cs =
            C.canvasSize
    in
        Random.pair (Random.int 0 (truncate cs.x)) (Random.int 0 (truncate cs.y))


randomPoint : Int -> Point
randomPoint seed =
    let
        ( ( x, y ), _ ) =
            Random.step randomPairGenerator (Random.initialSeed seed)
    in
        Point (toFloat x) (toFloat y)
