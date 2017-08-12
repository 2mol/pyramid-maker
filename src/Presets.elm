module Presets exposing (..)

import Types exposing (..)
import Array as A


whateverPyramid : Pyramid
whateverPyramid =
    Pyramid
        (A.fromList
            [ Point 50 50
            , Point 100 300
            , Point 300 400
            , Point 500 150
            , Point 250 20
            ]
        )
        (Point 320 200)
        10
