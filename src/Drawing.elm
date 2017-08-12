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

import Html exposing (Html)
import Html.Attributes as HtmlA
import Svg exposing (Svg)
import Svg.Attributes as SvgA
import Array exposing (Array)
import Types exposing (..)
import Update exposing (Msg)
import Perspective exposing (ViewPoint(..))


{- want to have the following flow

   pyramid -> [Edges] -> [drawnEdges] -> drawing

-}
-- some parameters:


canvasSize : { x : Float, y : Float }
canvasSize =
    { x = 600, y = 400 }


canvas : List (Html.Attribute Msg)
canvas =
    let
        canvasString =
            [ 0, 0, canvasSize.x, canvasSize.y ]
                |> List.map toString
                |> String.join " "
    in
        [ SvgA.viewBox canvasString, SvgA.width "600px" ]



-- Drawing the Pyramid:


drawPyramid : Pyramid -> ViewPoint -> List (Svg Msg)
drawPyramid ({ basePolygon, top, height } as pyramid) vp =
    case vp of
        Top ->
            let
                edges =
                    Array.toList <| pyramidToEdges pyramid

                pyramidLines =
                    List.map drawEdge edges

                topCircle =
                    Svg.circle
                        [ SvgA.cx <| toString top.x
                        , SvgA.cy <| toString top.y
                        , SvgA.r "4"
                        , SvgA.fill "#dd0000"
                        , SvgA.stroke "none"
                        ]
                        []
            in
                pyramidLines ++ [ topCircle ]


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


pyramidToEdges : Pyramid -> Array Edge
pyramidToEdges { basePolygon, top, height } =
    let
        ridges =
            Array.map (Edge top) basePolygon

        perimeter =
            polygonToEdges basePolygon
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



-- prettifying stuff:


grey : String
grey =
    "#fafafafa"


wrapInputColumn : List (Html Msg) -> String -> Html Msg
wrapInputColumn whatever title =
    let
        enrichedWhatever =
            drawTitle title :: whatever

        content =
            Html.div
                [ HtmlA.style
                    [ ( "backgroundColor", grey )
                    , ( "padding", "10px" )
                    ]
                ]
                enrichedWhatever
    in
        Html.td
            [ HtmlA.style [ ( "vertical-align", "top" ) ] ]
            [ content ]


drawTitle : String -> Html Msg
drawTitle title =
    Html.div
        [ HtmlA.style
            [ ( "padding", "10px" )
            , ( "font-size", "39px" )
            , ( "font-family", "sans-serif" )
            , ( "color", "#ad296f" )
            ]
        ]
        [ Html.text title
        , Html.br [] []
        ]


border : Svg.Svg msg
border =
    Svg.rect
        [ SvgA.x "2"
        , SvgA.y "2"
        , SvgA.width <| toString <| canvasSize.x - 3
        , SvgA.height <| toString <| canvasSize.y - 3
        , SvgA.fill "none"
        , SvgA.stroke grey
        , SvgA.strokeWidth "1"
        ]
        []



-- annotations:


edgeAnnotation : String -> Edge -> Svg.Svg msg
edgeAnnotation label edge =
    let
        pos =
            lineMiddle edge
    in
        Svg.text_
            [ SvgA.x <| toString <| pos.x
            , SvgA.y <| toString <| pos.y
            , SvgA.fontFamily "sans-serif"
            , SvgA.fontSize "4"
            ]
            [ Svg.text label ]


lineMiddle : Edge -> Point
lineMiddle { start, end } =
    { x = (start.x + end.x) / 2
    , y = (start.y + end.y) / 2
    }
