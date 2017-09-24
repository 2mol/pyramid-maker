module Presets exposing (..)

import Types exposing (..)
import Array


whateverPyramid : Pyramid
whateverPyramid =
    Pyramid
        (Array.fromList
            [ Point2D 50 50
            , Point2D 100 300
            , Point2D 300 400
            , Point2D 500 150
            , Point2D 250 5
            , Point2D 140 50
            ]
        )
        (Point2D 320 200)
        20



--


easyPeasy : Pyramid
easyPeasy =
    Pyramid
        (Array.fromList
            [ Point2D 50 40
            , Point2D 50 360
            , Point2D 560 200
            ]
        )
        (Point2D 120 200)
        666
