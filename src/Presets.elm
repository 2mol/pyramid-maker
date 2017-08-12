module Presets exposing (..)

import Types exposing (..)
import Array exposing (Array)


whatever : Array Point
whatever =
    Array.fromList
        [ Point 50 50
        , Point 100 300
        , Point 300 400
        , Point 500 150
        , Point 250 20
        ]


whateverPyramid : Pyramid
whateverPyramid =
    Pyramid
        whatever
        (Point 320 200)
        20



--


easyPeasy_ : Array Point
easyPeasy_ =
    Array.fromList
        [ Point 50 50
        , Point 100 300
        , Point 300 400
        ]


easyPeasy : Pyramid
easyPeasy =
    Pyramid
        easyPeasy_
        (Point 10 10)
        10
