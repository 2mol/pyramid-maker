module Types exposing (..)


type alias Point =
    { x : Float
    , y : Float
    , z : Float
    }


type alias Pyramid =
    { p1 : Point
    , p2 : Point
    , p3 : Point
    , p4 : Point
    , top : Point
    }


type alias Line =
    { start : Point
    , end : Point
    }
