module Drawing_ exposing (..)

import Svg
import Svg.Attributes as SvgA
import Html as Html
import Html.Attributes as HtmlA
import Html.Events exposing (onInput)
import Types exposing (..)
import Utils as U
import Update exposing (Msg(..))


-- Drawing Lines:


drawLine : Edge -> Svg.Svg msg
drawLine { start, end } =
    let
        lineCoord =
            List.map toString [ start.x, end.x, start.y, end.y ]

        svgLineCoord =
            List.map2 (<|) [ SvgA.x1, SvgA.x2, SvgA.y1, SvgA.y2 ] lineCoord

        lineParameters =
            [ SvgA.stroke "black", SvgA.strokeWidth "0.2" ]
    in
        Svg.line (svgLineCoord ++ lineParameters) []


drawLines : List Edge -> List (Svg.Svg msg)
drawLines l =
    List.map drawLine l



-- Scaling Stuff:


scale : Float -> Float -> Float -> Float -> Float
scale x y xMax yMax =
    if (xMax / yMax < x / y) then
        -- scale on y axis
        y / yMax
    else
        x / xMax


getScaleFactor : Float -> Float -> List Point -> Float
getScaleFactor x y p =
    let
        xMax_ =
            p
                |> List.map .x
                |> List.maximum

        yMax_ =
            p
                |> List.map .y
                |> List.maximum
    in
        case ( xMax_, yMax_ ) of
            ( Just xMax, Just yMax ) ->
                scale x y xMax yMax

            other ->
                1


scaleLine : Float -> Edge -> Edge
scaleLine r { start, end } =
    { start = { x = r * start.x, y = r * start.y }
    , end = { x = r * end.x, y = r * end.y }
    }


scaleLines : Float -> List Edge -> List Edge
scaleLines r edges =
    List.map (scaleLine r) edges



-- Text on drawing:


lineAnnotation : String -> Edge -> Svg.Svg msg
lineAnnotation label edge =
    let
        pos =
            U.lineMiddle edge
    in
        Svg.text_
            [ SvgA.x <| toString <| pos.x
            , SvgA.y <| toString <| pos.y
            , SvgA.fontFamily "sans-serif"
            , SvgA.fontSize "4"
            ]
            [ Svg.text label ]



-- draw Input:


mkInput : Int -> Html.Html Msg
mkInput i =
    Html.input
        [ HtmlA.type_ "number"

        -- , HtmlA.placeholder <| toString i
        -- , HtmlA.disabled True
        --, HtmlA.name "quantity"
        , HtmlA.defaultValue <| toString i
        , HtmlA.min "0"
        , HtmlA.max "10"
        , onInput ChangePoint
        ]
        []


mkInput_ : Html.Html Msg
mkInput_ =
    Html.input
        [ HtmlA.type_ "number"
        , HtmlA.placeholder "blala"

        --, HtmlA.name "quantity"
        , HtmlA.min "0"
        , HtmlA.max "5"
        , onInput ChangePoint
        ]
        []



-- border crap:


canvasSize : { x : Float, y : Float }
canvasSize =
    { x = 160, y = 100 }


canvas : String
canvas =
    [ 0, 0, canvasSize.x, canvasSize.y ]
        |> List.map toString
        |> String.join " "


border : Svg.Svg msg
border =
    Svg.rect
        [ SvgA.x "2"
        , SvgA.y "2"
        , SvgA.width <| toString <| canvasSize.x - 4
        , SvgA.height <| toString <| canvasSize.y - 4
        , SvgA.fill "none"
        , SvgA.stroke "#eeeeee"
        , SvgA.strokeWidth "0.5"
        ]
        []
