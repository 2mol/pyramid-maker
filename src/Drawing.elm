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
import Html.Events as HtmlE
import Svg exposing (Svg)
import Svg.Attributes as SvgA
import Mouse
import Json.Decode as Decode
import Array
import Types exposing (..)
import Config exposing (..)
import Perspective exposing (ViewPoint(..))
import Math as Math
import Round as Round


canvas : List (Html.Attribute Msg)
canvas =
    let
        canvasString =
            [ 0, 0, canvasSize.x, canvasSize.y ]
                |> List.map toString
                |> String.join " "
    in
        [ SvgA.viewBox canvasString, SvgA.width <| toString canvasSize.x ++ "px" ]



-- Drawing the Pyramid:


(=>) : a -> b -> ( a, b )
(=>) =
    (,)


drawPyramid : Pyramid -> ViewPoint -> Svg Msg
drawPyramid pyramid vp =
    case vp of
        Top ->
            let
                edges =
                    Math.pyramidToEdges pyramid

                drawnEdges =
                    Svg.g [] <| List.map drawEdge edges

                drawnPoints =
                    -- Svg.g [ SvgA.filter "url(#fafa)", SvgA.fillOpacity ".5" ] <| drawPyramidPoints pyramid
                    Svg.g [] <| drawPyramidPoints pyramid

                edgeLabels =
                    List.map radiansToDegreeString <| Math.pyramidAngles pyramid

                --List.map toString <| List.range 1 (List.length edges)
                drawnLabels =
                    Svg.g [] <| List.map2 edgeAnnotation edgeLabels edges
            in
                Svg.g []
                    [ drawnEdges
                    , drawnPoints
                    , drawnLabels

                    -- , Svg.filter [ SvgA.id "fafa" ] [ Svg.feBlend [ SvgA.mode "lighten" ] [] ]
                    ]


drawEdge : Edge -> Svg Msg
drawEdge { start, end } =
    let
        lineCoord =
            List.map toString [ start.x, end.x, start.y, end.y ]

        svgLineCoord =
            List.map2 (<|) [ SvgA.x1, SvgA.x2, SvgA.y1, SvgA.y2 ] lineCoord

        lineParameters =
            [ SvgA.stroke "black", SvgA.strokeWidth "0.5", SvgA.result "edges" ]
    in
        Svg.line (svgLineCoord ++ lineParameters) []


drawPoint : String -> Int -> Point2D -> Svg Msg
drawPoint color index { x, y } =
    Svg.circle
        [ HtmlE.on "mousedown" (Decode.map (DragStart index) Mouse.position)
        , SvgA.cx <| toString x
        , SvgA.cy <| toString y
        , SvgA.r "8"
        , SvgA.fill "none"
        , SvgA.stroke color
        , HtmlA.style
            [ "cursor" => "move"
            , "pointer-events" => "visible"
            ]
        ]
        []


drawPyramidPoints : Pyramid -> List (Svg Msg)
drawPyramidPoints { basePolygon, tip } =
    let
        polygonPoints =
            Array.toList <| Array.indexedMap (drawPoint "none") basePolygon

        tipPoint =
            drawPoint "#dd0000" -1 tip
    in
        tipPoint :: polygonPoints



-- prettifying stuff:


wrapInputColumn : List (Html Msg) -> String -> Html Msg
wrapInputColumn someHtml title =
    let
        content =
            Html.div
                [ HtmlA.style
                    [ ( "backgroundColor", grey )
                    , ( "padding", "10px" )
                    ]
                ]
                (drawTitle title :: someHtml)
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
        [ SvgA.x "0"
        , SvgA.y "0"
        , SvgA.width <| toString <| canvasSize.x
        , SvgA.height <| toString <| canvasSize.y
        , SvgA.fill "none"
        , SvgA.stroke grey
        , SvgA.strokeWidth "10"
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
            , SvgA.fontSize "14"
            , SvgA.pointerEvents "none"
            ]
            [ Svg.text label ]


lineMiddle : Edge -> Point2D
lineMiddle { start, end } =
    { x = (start.x + end.x) / 2
    , y = (start.y + end.y) / 2
    }


radiansToDegreeString : Float -> String
radiansToDegreeString angle =
    let
        degree =
            180 * angle / pi

        roundedDegree =
            Round.round 1 degree
    in
        roundedDegree ++ "°"
