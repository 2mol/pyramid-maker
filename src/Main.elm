module Main exposing (main)

{-| go away, read your own source code.
@docs main
-}

import Html as Html
import Html.Attributes as HtmlA
import Html.Events exposing (onInput)
import Svg as Svg
import Svg.Attributes as SvgA
import Array as A
import Types exposing (..)
import Utils as U
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
    { pyramid : Pyramid
    , text : String
    }


startPyramid : Pyramid
startPyramid =
    Pyramid
        (A.fromList
            [ Point 5 5
            , Point 10 50
            , Point 90 50
            , Point 50 10

            -- , Point 30 5
            ]
        )
        (Point 50 20)
        1


initialModel : Model
initialModel =
    { pyramid = startPyramid
    , text = "FLUFF"
    }


type Msg
    = NewPoint
    | RemovePoint Int
    | ChangePoint String --Int Int Int


update : Msg -> Model -> Model
update msg currentModel =
    case msg of
        NewPoint ->
            currentModel

        RemovePoint i ->
            currentModel

        ChangePoint t ->
            { currentModel | text = t }


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


drawPointCoord : Int -> Point -> Html.Html Msg
drawPointCoord i { x, y } =
    Html.div []
        [ Html.text <| "P" ++ (toString i) ++ " {x = "
        , Html.text <| toString x
        , Html.text ", y = "
        , Html.text <| toString y
        , Html.text "}"
        ]


view : Model -> Html.Html Msg
view { pyramid, text } =
    let
        -- get scale factor assuming that the tip lies inside the base polygon
        scaleFactor =
            0.95 * D.getScaleFactor canvasSize.x canvasSize.y (A.toList pyramid.basePolygon)

        edges =
            pyramid |> U.pyramidEdges |> D.scaleLines scaleFactor

        pyramidDrawing =
            edges |> D.drawLines

        annotations =
            List.map (D.lineAnnotation "25.8°") edges

        numberInput =
            mkInput 4

        -- Svg.text_
        --     [ SvgA.x "20"
        --     , SvgA.y "20"
        --     , SvgA.fontFamily "sans-serif"
        --     , SvgA.fontSize "4"
        --     ]
        --     [ Html.text "25.8°" ]
        drawing =
            annotations ++ pyramidDrawing ++ [ border ]
    in
        Html.div []
            [ Html.table []
                [ Html.tr []
                    [ Html.td []
                        ([ numberInput
                         , Html.br [] []

                         --  , Html.text text
                         , Html.br [] []
                         ]
                            ++ A.toList (A.map (drawPointCoord 4) pyramid.basePolygon)
                        )
                    , Html.td []
                        [ Svg.svg [ SvgA.viewBox canvas, SvgA.width "600px" ] drawing

                        -- , br [] []
                        -- , Svg.svg [ SvgA.viewBox canvas, SvgA.width "300px" ]
                        --     (border
                        --         :: [ Svg.polygon
                        --                 [ SvgA.fill "none"
                        --                 , SvgA.stroke "black"
                        --                 , SvgA.strokeWidth "0.2"
                        --                 , SvgA.points "5,5 10,50 90,50 50,10 30,5"
                        --                 ]
                        --                 []
                        --            ]
                        --     )
                        ]
                    ]
                ]
            ]
