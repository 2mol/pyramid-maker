module Update exposing (..)

import Array exposing (Array)
import Types exposing (..)


update : Msg -> Model -> Model
update msg ({ basePolygon, top, height } as currentModel) =
    case msg of
        NewPoint ->
            { currentModel | basePolygon = addPoint basePolygon }

        RemovePoint ->
            { currentModel | basePolygon = Array.slice 0 -1 basePolygon }

        ChangeCoordinate index axis newValueString ->
            let
                newBasePolygon =
                    changeCoordinate index axis newValueString basePolygon
            in
                { currentModel | basePolygon = newBasePolygon }

        _ ->
            currentModel


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


changeCoordinate : Int -> Axis -> String -> Array Point -> Array Point
changeCoordinate index axis newValueString basePolygon =
    case ( Array.get index basePolygon, String.toFloat newValueString ) of
        ( Just point, Ok newValue ) ->
            let
                updatedPoint =
                    case axis of
                        X ->
                            { point | x = newValue }

                        Y ->
                            { point | y = newValue }
            in
                Array.set index updatedPoint basePolygon

        _ ->
            basePolygon
