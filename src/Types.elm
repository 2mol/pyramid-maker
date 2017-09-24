module Types exposing (..)

import Array as A
import Mouse exposing (Position)


{-| Simplified pyramid definition, so that the
base polygon always lies in the z=0 plane.

Assume only a single pyramid tip, because it guarantees
unambiguous triangular sides.

-}
type alias Model =
    { pyramid : Pyramid
    , draggedPointIndex : Maybe Int
    , drag : Maybe Drag
    }


type Msg
    = NewPoint
    | RemovePoint
    | Change ChangePyramidPoint
    | Random
    | DragStart Int Position
    | DragAt Int Position
    | DragEnd Int Position


type ChangePyramidPoint
    = ChangePolygonPoint Int Point2D
    | ChangeTip Point2D
    | ChangeHeight Float


type alias Drag =
    { start : Position
    , current : Position
    }



-- Shapes:


type alias Pyramid =
    { basePolygon : A.Array Point2D
    , tip : Point2D
    , height : Float
    }


type alias Edge =
    { start : Point2D
    , end : Point2D
    }


type alias Point2D =
    { x : Float
    , y : Float
    }


type alias Point3D =
    { x : Float
    , y : Float
    , z : Float
    }


type Axis
    = X
    | Y
