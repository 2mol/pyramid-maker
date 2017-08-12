module Drawing exposing (..)

{-| Should expose the following toplevel functions:

  - drawPyramid : Pyramid (-> ViewPoint) -> Svg Msg

  - drawAnnotation : String -> Coord -> Svg Msg
    -> drawAnnotations = map the above onto list of coordinates

  - drawEdgeAnnotation : String -> DrawnLine -> Svg Msg
    -> same as above, just Coord = middle of Edge

  - labeledInputField : (String ->) Int -> Int -> Html Msg
    -> takes an index (corresponds to point in Array of Points)
    and a default value (current coordinate)
    (-> string is the label, so inputField wrapped in some text. Like 'x' etc)

  - maybe stuff like border, legend, axis labels etc.

-}

import Svg exposing (Svg)
import Svg.Attributes as SvgA
import Array exposing (Array)
import Types exposing (..)
import Update exposing (Msg)
import Perspective exposing (ViewPoint(..))


{- want to have the following flow

   pyramid -> [Edges] -> [drawnEdges] -> drawing

-}


drawPyramid : Pyramid -> ViewPoint -> List (Svg Msg)
drawPyramid pyramid vp =
    case vp of
        Top ->
            let
                edges =
                    Array.toList <| pyramidEdges pyramid
            in
                List.map drawEdge edges


drawEdge : Edge -> Svg Msg
drawEdge { start, end } =
    let
        lineCoord =
            List.map toString [ start.x, end.x, start.y, end.y ]

        svgLineCoord =
            List.map2 (<|) [ SvgA.x1, SvgA.x2, SvgA.y1, SvgA.y2 ] lineCoord

        lineParameters =
            [ SvgA.stroke "black", SvgA.strokeWidth "0.5" ]
    in
        Svg.line (svgLineCoord ++ lineParameters) []


pyramidEdges : Pyramid -> Array Edge
pyramidEdges { basePolygon, top, height } =
    let
        ridges =
            Array.map (Edge top) basePolygon

        perimeter =
            polygonEdges basePolygon
    in
        Array.append ridges perimeter


polygonEdges : Array Point -> Array Edge
polygonEdges p =
    let
        pList =
            Array.toList p

        maybeFirstPoint =
            Array.get 0 p

        maybeLastPoint =
            lastElem p
    in
        case ( maybeFirstPoint, maybeLastPoint ) of
            ( Just lastPoint, Just firstPoint ) ->
                let
                    lastEdge =
                        Edge firstPoint firstPoint
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
