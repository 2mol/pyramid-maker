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
        , Point 250 5
        , Point 140 50
        ]


whateverPyramid : Pyramid
whateverPyramid =
    Pyramid
        whatever
        (Point 320 200)
        20



--


easyPeasy : Pyramid
easyPeasy =
    Pyramid
        (Array.fromList
            [ Point 50 40
            , Point 50 360
            , Point 560 200
            ]
        )
        (Point 120 200)
        666
