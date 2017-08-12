module Presets exposing (..)

import Types exposing (..)
import Array as A


whateverPyramid : Pyramid
whateverPyramid =
    Pyramid
        (A.fromList
            [ Point 5 5
            , Point 100 300
            , Point 300 400
            , Point 500 200
            , Point 250 50
            ]
        )
        (Point 300 200)
        1
