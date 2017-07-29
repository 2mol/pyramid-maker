module Main exposing (main)

{-| go away, read your own source code.
@docs main
-}

import Html exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Types exposing (..)


{-| I refuse to comment.
-}
main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }


type alias Model =
    Pyramid


startPyramid : Pyramid
startPyramid =
    Pyramid
        [ Point 5 5
        , Point 10 50
        , Point 90 50
        , Point 50 10
        ]
        (Point 50 20)
        1


model : Model
model =
    startPyramid


type Msg
    = Nah


update : Msg -> Model -> Model
update msg model =
    case msg of
        Nah ->
            startPyramid


drawLine : Line -> Svg msg
drawLine { start, end } =
    let
        lineCoord =
            List.map toString [ start.x, end.x, start.y, end.y ]

        svgLineCoord =
            List.map2 (<|) [ x1, x2, y1, y2 ] lineCoord

        lineParameters =
            [ stroke "black", strokeWidth "0.2" ]
    in
        line (svgLineCoord ++ lineParameters) []


drawLines : List Line -> List (Svg msg)
drawLines l =
    List.map drawLine l


pyramidLines : Pyramid -> List Line
pyramidLines { basePolygon, top } =
    let
        ridges =
            List.map (Line top) basePolygon

        perimeter =
            polygonLinesCheating basePolygon
    in
        ridges ++ perimeter


polygonLines : List Point -> List Line
polygonLines p =
    case p of
        x1 :: x2 :: xs ->
            Line x1 x2 :: polygonLines (x2 :: xs)

        other ->
            []


polygonLinesCheating : List Point -> List Line
polygonLinesCheating p =
    case p of
        [] ->
            []

        x :: xs ->
            polygonLines (x :: xs ++ [ x ])


view : Model -> Html Msg
view model =
    div []
        [ svg [ viewBox "0 0 160 100", width "300px" ] []
        , svg [ viewBox "0 0 160 100", width "300px", shapeRendering "auto" ]
            (drawLines (pyramidLines model))
        , br [] []
        , svg [ viewBox "0 0 160 100", width "300px" ]
            (drawLines (pyramidLines model))
        , svg [ viewBox "0 0 160 100", width "300px" ]
            (drawLines (pyramidLines model))
        ]
