module Math
    exposing
        ( pyramidToEdges
        , randomPoint
        , pyramidAngles
        )

import Types exposing (..)
import Array
import Random
import Config as C


-- getting edges from a pyramid:


pyramidToEdges : Pyramid -> List Edge
pyramidToEdges { basePolygon, tip } =
    let
        orderedPolygon =
            basePolygon
                |> Array.toList
                |> List.sortWith (compareAngle tip)

        ridges =
            orderedPolygon
                |> List.map (Edge tip)

        perimeter =
            orderedPolygon
                |> polygonToEdges tip
    in
        ridges ++ perimeter


polygonToEdges : Point2D -> List Point2D -> List Edge
polygonToEdges tip polygon =
    case polygon of
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


pyramidAngles : Pyramid -> List Float
pyramidAngles pyramid =
    let
        triangles =
            pyramidToTriangles pyramid

        faceAngles =
            anglesBetweenFaces triangles

        wallAngles =
            List.map wallAngle triangles
    in
        faceAngles ++ wallAngles


anglesBetweenFaces : List Triangle -> List Float
anglesBetweenFaces triangles =
    case triangles of
        t1 :: _ :: _ ->
            anglesBetweenFacesHelper (triangles ++ [ t1 ])

        _ ->
            []


anglesBetweenFacesHelper : List Triangle -> List Float
anglesBetweenFacesHelper triangles =
    case triangles of
        t1 :: t2 :: ts ->
            (triangleAngle t1 t2) / 2 :: anglesBetweenFacesHelper (t2 :: ts)

        _ ->
            []


pyramidToTriangles : Pyramid -> List Triangle
pyramidToTriangles { basePolygon, tip, height } =
    let
        orderedPolygon =
            basePolygon
                |> Array.toList
                |> List.sortWith (compareAngle tip)

        ordered3DPolygon =
            List.map (\p -> Point3D p.x p.y 0) orderedPolygon

        tip3D =
            Point3D tip.x tip.y height
    in
        case ordered3DPolygon of
            p1 :: p2 :: ps ->
                -- these triangles _will_ all be counter-clockwise due to the sorting
                List.scanl triangleScanner (Triangle tip3D p1 p2) (ps ++ [ p1 ])

            _ ->
                []


triangleScanner : Point3D -> Triangle -> Triangle
triangleScanner nextPoint prevTriangle =
    Triangle prevTriangle.a prevTriangle.c nextPoint


normalVector : Triangle -> Point3D
normalVector { a, b, c } =
    let
        u =
            Point3D (b.x - a.x) (b.y - a.y) (b.z - a.z)

        v =
            Point3D (c.x - a.x) (c.y - a.y) (c.z - a.z)

        cpx =
            (u.y * v.z - u.z * v.y)

        cpy =
            (u.z * v.x - u.x * v.z)

        cpz =
            (u.x * v.y - u.y * v.x)
    in
        Point3D cpx cpy cpz


vectorAngle : Point3D -> Point3D -> Float
vectorAngle u v =
    let
        dotProduct =
            u.x * v.x + u.y * v.y + u.z * v.z

        nu =
            sqrt <| u.x ^ 2 + u.y ^ 2 + u.z ^ 2

        nv =
            sqrt <| v.x ^ 2 + v.y ^ 2 + v.z ^ 2
    in
        acos <| dotProduct / (nu * nv)


triangleAngle : Triangle -> Triangle -> Float
triangleAngle t1 t2 =
    let
        n1 =
            normalVector t1

        n2 =
            normalVector t2
    in
        vectorAngle n1 n2


wallAngle : Triangle -> Float
wallAngle t =
    let
        n1 =
            normalVector t

        n2 =
            Point3D 0 0 1
    in
        vectorAngle n1 n2



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
