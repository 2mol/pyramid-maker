module Update exposing (..)

import Model exposing (Model)


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
            currentModel
