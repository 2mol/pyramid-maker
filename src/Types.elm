module Types exposing (..)

import Array exposing (Array)
import Mouse exposing (Position)


{-| Simplified pyramid definition, so that the
base polygon always lies in the z=0 plane.

Assume only a single pyramid tip, because it guarantees
unambiguous triangular sides.

-}
type alias Model =
    { pyramid : Pyramid
    , drag : Maybe Drag
    }


type Msg
    = NewPoint
    | RemovePoint
    | Change ChangePyramidPoint
    | Random
    | DragStart Int Position
    | DragAt Int Position
    | DragEnd


type ChangePyramidPoint
    = ChangePolygonPoint Int Point
    | ChangeTip Point


type alias Drag =
    { start : Position
    , current : Position
    }



-- Shapes:


type alias Pyramid =
    { basePolygon : Array Point
    , tip : Point
    , height : Float
    }


type alias Edge =
    { start : Point
    , end : Point
    }


type alias Point =
    { x : Float
    , y : Float
    }


type Axis
    = X
    | Y
