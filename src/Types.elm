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
    | ChangePoint Int Point
    | Random
    | DragStart Int Position
    | DragAt Int Position
    | DragEnd Int Position


type alias Drag =
    { start : Position
    , current : Position
    }



-- Shapes:


type alias Pyramid =
    { basePolygon : Array Point
    , top : Point
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
