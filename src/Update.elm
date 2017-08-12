module Update exposing (..)

import Array
import Types exposing (..)


update : Msg -> Model -> Model
update msg ({ basePolygon, top, height } as currentModel) =
    case msg of
        NewPoint ->
            let
                newPoint =
                    Point 50 50
            in
                { currentModel | basePolygon = Array.push newPoint basePolygon }

        RemovePoint ->
            { currentModel | basePolygon = Array.slice 0 -1 basePolygon }

        ChangePoint i coord newValueString ->
            case ( Array.get i basePolygon, String.toFloat newValueString ) of
                ( Just point, Ok newValue ) ->
                    let
                        updatedPoint =
                            case coord of
                                X ->
                                    { point | x = newValue }

                                Y ->
                                    { point | y = newValue }

                        newBasePolygon =
                            Array.set i updatedPoint basePolygon
                    in
                        { currentModel | basePolygon = newBasePolygon }

                _ ->
                    currentModel
