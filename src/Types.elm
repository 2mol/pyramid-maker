module Types exposing (..)


type alias Point =
    { x : Float
    , y : Float
    }


type alias Pyramid =
    { basePolygon : List Point
    , top : Point
    , height : Float
    }


type alias Line =
    { start : Point
    , end : Point
    }
