module Main exposing (main)

{-| go away, read your own source code.
@docs main
-}

import Html exposing (..)
import Svg as Svg
import Svg.Attributes as SvgA
import Types exposing (..)
import Utils exposing (..)
import Drawing as D


{-| I refuse to comment.
-}
main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initialModel
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
        , Point 30 5
        ]
        (Point 50 20)
        1


initialModel : Model
initialModel =
    startPyramid


type Msg
    = Nah


update : Msg -> Model -> Model
update msg model =
    case msg of
        Nah ->
            startPyramid


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
        , SvgA.width (canvasSize.x - 2 |> toString)
        , SvgA.height (canvasSize.y - 2 |> toString)
        , SvgA.fill "none"
        , SvgA.stroke "black"
        , SvgA.strokeWidth "0.2"
        ]
        []


view : Model -> Html Msg
view ({ basePolygon, top, height } as pyramid) =
    let
        -- get scale factor assuming that the tip lies inside the base polygon
        scaleFactor =
            0.95 * D.getScaleFactor canvasSize.x canvasSize.y basePolygon

        pyramidDrawing =
            pyramid
                |> pyramidLines
                |> D.scaleLines scaleFactor
                |> D.drawLines

        annotationsDrawing =
            [ border ]

        drawing =
            pyramidDrawing ++ annotationsDrawing
    in
        div []
            [ Svg.svg [ SvgA.viewBox canvas, SvgA.width "600px" ] drawing
            , br [] []
            , Svg.svg [ SvgA.viewBox canvas, SvgA.width "300px" ]
                (border
                    :: [ Svg.polygon
                            [ SvgA.fill "none"
                            , SvgA.stroke "black"
                            , SvgA.strokeWidth "0.2"
                            , SvgA.points "5,5 10,50 90,50 50,10 30,5"
                            ]
                            []
                       ]
                )
            ]
