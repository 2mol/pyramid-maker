module Types exposing (..)

import Array exposing (Array)


{-| Simplified pyramid definition, so that the
base polygon always lies in the z=0 plane.

Assume only a single pyramid tip, because it guarantees
unambiguous triangular sides.

-}
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


type Coordinate
    = X
    | Y
