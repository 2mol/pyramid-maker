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
    , drag : Maybe DragPoint
    }


type alias DragPoint =
    { start : Position
    , current : Position
    , index : Int
    }



-- Message Type:


type Msg
    = NewPoint
    | RemovePoint
    | Random
    | ChangePolygonPoint Int Point2D
    | ChangeTip Point2D
    | ChangeHeight Float
    | DragStart Int Position
    | DragAt Int Position
    | DragEnd Int Position



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


type alias Triangle =
    { a : Point3D
    , b : Point3D
    , c : Point3D
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
