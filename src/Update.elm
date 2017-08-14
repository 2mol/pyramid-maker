module Update exposing (..)

import Array exposing (Array)
import Types exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ basePolygon, top, height } as currentModel) =
    let
        newModel =
            case msg of
                NewPoint ->
                    if Array.length basePolygon < 12 then
                        { currentModel | basePolygon = addPoint basePolygon }
                    else
                        currentModel

                RemovePoint ->
                    { currentModel | basePolygon = Array.slice 0 -1 basePolygon }

                ChangePoint index updatedPoint ->
                    let
                        newBasePolygon =
                            Array.set updatedPoint index basePolygon
                    in
                        { currentModel | basePolygon = newBasePolygon }

                MouseMsg position ->
                    -- { currentModel | basePolygon = addPoint basePolygon }
                    currentModel

                _ ->
                    currentModel
    in
        ( newModel, Cmd.none )



-- helper functions:


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
