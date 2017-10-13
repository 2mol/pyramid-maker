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
                ChangeTip updatedPoint ->
                    updatedPoint

                _ ->
                    tip

        newHeight =
            case msg of
                ChangeHeight h ->
                    h

                _ ->
                    pyramid.height

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

                ChangePolygonPoint index updatedPoint ->
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
                    { pyramid | basePolygon = newBasePolygon, tip = newTip, height = newHeight }

        newDrag =
            case msg of
                DragStart index xy ->
                    Just (DragPoint xy xy index)

                DragAt index xy ->
                    Maybe.map (\{ start } -> DragPoint start xy index) drag

                DragEnd _ _ ->
                    Nothing

                _ ->
                    Nothing
    in
        { model
            | pyramid = newPyramid
            , drag = newDrag
        }


getLivePyramid : Model -> Pyramid
getLivePyramid { pyramid, drag } =
    case drag of
        Just { start, current, index } ->
            let
                currentPoint =
                    Array.get index pyramid.basePolygon

                draggedPoint =
                    case currentPoint of
                        Just point ->
                            Point2D
                                (point.x + (toFloat <| current.x - start.x))
                                (point.y + (toFloat <| current.y - start.y))

                        Nothing ->
                            Point2D
                                (pyramid.tip.x + (toFloat <| current.x - start.x))
                                (pyramid.tip.y + (toFloat <| current.y - start.y))
            in
                if index >= 0 then
                    { pyramid | basePolygon = Array.set index draggedPoint pyramid.basePolygon }
                else
                    { pyramid | tip = draggedPoint }

        _ ->
            pyramid


coordAccum : Point2D -> Int -> Int
coordAccum { x, y } acc =
    acc + truncate x + truncate y
