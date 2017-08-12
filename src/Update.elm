module Update exposing (..)

import Array
import Model exposing (Model)
import Types exposing (..)


type Msg
    = NewPoint
    | RemovePoint Int
    | ChangePoint Int Axis String


update : Msg -> Model -> Model
update msg ({ basePolygon, top, height } as currentModel) =
    case msg of
        NewPoint ->
            currentModel

        RemovePoint i ->
            currentModel

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
