module Types exposing (..)


type alias Point =
    { x : Float
    , y : Float
    }


type alias Edge =
    { start : Point
    , end : Point
    }


type alias Pyramid =
    { basePolygon : List Point
    , top : Point
    , height : Float
    }
