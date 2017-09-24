module Update exposing (update, getLivePyramid)

import Array
import Types exposing (..)
import Math exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( updateHelper msg model, Cmd.none )



-- helper functions:


updateHelper : Msg -> Model -> Model
updateHelper msg ({ pyramid, drag } as model) =
    let
        { basePolygon, tip } =
            pyramid

        seed =
            Array.foldl coordAccum 0 basePolygon

        newTip =
            case msg of
                Change (ChangeTip updatedPoint) ->
                    updatedPoint

                _ ->
                    tip

        newBasePolygon =
            case msg of
                NewPoint ->
                    if Array.length basePolygon < 12 then
                        Array.push (randomPoint seed) basePolygon
                    else
                        basePolygon

                RemovePoint ->
                    if Array.length basePolygon > 3 then
                        Array.slice 0 -1 basePolygon
                    else
                        basePolygon

                Change (ChangePolygonPoint index updatedPoint) ->
                    Array.set index updatedPoint basePolygon

                Random ->
                    basePolygon
                        |> Array.map (\p -> randomPoint (seed + truncate p.x + truncate p.y))

                _ ->
                    basePolygon

        newPyramid =
            case msg of
                DragEnd _ _ ->
                    getLivePyramid model

                _ ->
                    { pyramid | basePolygon = newBasePolygon, tip = newTip }

        newDrag =
            case msg of
                DragStart _ xy ->
                    Just (Drag xy xy)

                DragAt _ xy ->
                    Maybe.map (\{ start } -> Drag start xy) drag

                DragEnd _ _ ->
                    Nothing

                _ ->
                    Nothing

        newDraggedPointIndex =
            case msg of
                DragStart index _ ->
                    Just index

                DragAt index _ ->
                    Just index

                _ ->
                    Nothing
    in
        { model | pyramid = newPyramid, drag = newDrag, draggedPointIndex = newDraggedPointIndex }


getLivePyramid : Model -> Pyramid
getLivePyramid { pyramid, drag, draggedPointIndex } =
    case ( drag, draggedPointIndex ) of
        ( Just { start, current }, Just index ) ->
            let
                currentPoint =
                    Array.get index pyramid.basePolygon

                draggedPoint =
                    case currentPoint of
                        Just point ->
                            Point
                                (point.x + (toFloat <| current.x - start.x))
                                (point.y + (toFloat <| current.y - start.y))

                        Nothing ->
                            Point
                                (pyramid.tip.x + (toFloat <| current.x - start.x))
                                (pyramid.tip.y + (toFloat <| current.y - start.y))
            in
                if index >= 0 then
                    { pyramid | basePolygon = Array.set index draggedPoint pyramid.basePolygon }
                else
                    { pyramid | tip = draggedPoint }

        _ ->
            pyramid


coordAccum : Point -> Int -> Int
coordAccum { x, y } acc =
    acc + truncate x + truncate y
