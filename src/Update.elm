module Update exposing (..)

import Array exposing (Array)
import Types exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( updateHelper msg model, Cmd.none )



-- helper functions:


updateHelper : Msg -> Model -> Model
updateHelper msg ({ pyramid, drag } as model) =
    let
        { basePolygon, top, height } =
            pyramid

        newBasePolygon =
            case msg of
                NewPoint ->
                    if Array.length basePolygon < 12 then
                        addPoint basePolygon
                    else
                        basePolygon

                RemovePoint ->
                    Array.slice 0 -1 basePolygon

                ChangePoint index updatedPoint ->
                    Array.set index updatedPoint basePolygon

                DragEnd index xy ->
                    (getPosition model index).basePolygon

                _ ->
                    basePolygon

        -- DragStart index xy ->
        --     Array.set index position basePolygon
        -- DragAt index position ->
        --     basePolygon
        -- DragEnd index position ->
        --     basePolygon
        newPyramid =
            { pyramid | basePolygon = newBasePolygon }

        newDrag =
            case msg of
                DragStart index xy ->
                    Just (Drag xy xy)

                DragAt index xy ->
                    Maybe.map (\{ start } -> Drag start xy) drag

                DragEnd index xy ->
                    Nothing

                _ ->
                    Nothing
    in
        { model | pyramid = newPyramid, drag = newDrag }


getPosition : Model -> Int -> Pyramid
getPosition { pyramid, drag } index =
    case drag of
        Nothing ->
            pyramid

        Just { start, current } ->
            let
                mPoint =
                    Array.get index pyramid.basePolygon

                newPoint =
                    case mPoint of
                        Just point ->
                            Point
                                (point.x + (toFloat <| current.x - start.x))
                                (point.y + (toFloat <| current.y - start.y))

                        Nothing ->
                            pyramid.top
            in
                { pyramid | basePolygon = Array.set index newPoint pyramid.basePolygon }



-- more helper functions:


addPoint : Array Point -> Array Point
addPoint basePolygon =
    let
        newPoint =
            case ( Array.get 0 basePolygon, lastElem basePolygon ) of
                ( Just p0, Just pn ) ->
                    Point ((p0.x + pn.x) / 2) ((p0.y + pn.y) / 2)

                _ ->
                    Point 20 20
    in
        Array.push newPoint basePolygon


lastElem : Array a -> Maybe a
lastElem =
    Array.foldl (Just >> always) Nothing
