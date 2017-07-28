module Main exposing (main)

{-| The entry-point for the pyramid builder.
@docs main
-}

import Html exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Types exposing (..)


{-| Start the program running.
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
        (Point 5 5 5)
        (Point 10 50 0)
        (Point 50 10 0)
        (Point 90 50 0)
        (Point 50 20 10)


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
        lx1 =
            toString start.x

        ly1 =
            toString start.y

        lx2 =
            toString end.x

        ly2 =
            toString end.y
    in
        line [ x1 lx1, y1 ly1, x2 lx2, y2 ly2, stroke "#000000", strokeWidth "0.2", scale "22" ] []


drawLines : List Line -> List (Svg msg)
drawLines l =
    List.map drawLine l


pyramidLines : Pyramid -> List Line
pyramidLines { p1, p2, p3, p4, top } =
    [ (Line p1 p2)
    , (Line p2 p4)
    , (Line p4 p3)
    , (Line p3 p1)
    , (Line p1 top)
    , (Line p2 top)
    , (Line p3 top)
    , (Line p4 top)
    ]


view : Model -> Html Msg
view model =
    div []
        [ svg [ viewBox "0 0 100 100", width "300px" ] []
        , svg [ viewBox "0 0 100 100", width "300px" ]
            (drawLines (pyramidLines model))
        , br [] []
        , svg [ viewBox "0 0 100 100", width "300px" ]
            (drawLines (pyramidLines model))
        , svg [ viewBox "0 0 100 100", width "300px" ]
            (drawLines (pyramidLines model))
        ]
