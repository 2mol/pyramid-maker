module Types exposing (..)

import Array exposing (Array)


type alias Point =
    { x : Float
    , y : Float
    }


type alias Edge =
    { start : Point
    , end : Point
    }


type alias Pyramid =
    { basePolygon : Array Point
    , top : Point
    , height : Float
    }
