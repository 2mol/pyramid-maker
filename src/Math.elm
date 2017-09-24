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


polygonToEdges : Point2D -> List Point2D -> List Edge
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


perimeterScanner : Point2D -> Edge -> Edge
perimeterScanner nextPoint { end } =
    Edge end nextPoint



-- sorting polygon points around a central point:


compareAngle : Point2D -> Point2D -> Point2D -> Order
compareAngle p p1 p2 =
    compare (edgeAngle p p1) (edgeAngle p p2)


edgeAngle : Point2D -> Point2D -> Float
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



-- 3D math


pyramidToTriangles : Pyramid -> List Triangle
pyramidToTriangles { basePolygon, tip, height } =
    let
        orderedPolygon =
            basePolygon
                |> Array.toList
                |> List.sortWith (compareAngle tip)

        polygonPoints =
            List.map (\p -> Point3D p.x p.y 0) orderedPolygon

        tip3D =
            Point3D tip.x tip.y height
    in
        case polygonPoints of
            p1 :: p2 :: ps ->
                List.scanl (triangleScanner tip3D) (Triangle tip3D p1 p2) (ps ++ [ p1 ])

            _ ->
                []


triangleScanner : Point3D -> Point3D -> Triangle -> Triangle
triangleScanner anchorPoint nextPoint prevTriangle =
    Triangle anchorPoint prevTriangle.c nextPoint



-- pointTo3D : Point2D -> Point3D
-- pointTo3D p =
--     Point3D p.x p.y 0
-- pyramidTo3D : Pyramid -> List Point3D
-- pyramidTo3D { basePolygon, tip, height } =
--     let
--         polygonPoints =
--             Array.toList <| Array.map pointTo3D basePolygon
--         tip3D =
--             Point3D tip.x tip.y height
--     in
--         tip3D :: polygonPoints
-- pseudo-random point generation:


randomPairGenerator : Random.Generator ( Int, Int )
randomPairGenerator =
    let
        cs =
            C.canvasSize
    in
        Random.pair (Random.int 0 (truncate cs.x)) (Random.int 0 (truncate cs.y))


randomPoint : Int -> Point2D
randomPoint seed =
    let
        ( ( x, y ), _ ) =
            Random.step randomPairGenerator (Random.initialSeed seed)
    in
        Point2D (toFloat x) (toFloat y)
