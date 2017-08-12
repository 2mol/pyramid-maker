module Model exposing (..)

import Types as T
import Presets as P


type alias Model =
    T.Pyramid


initialModel : Model
initialModel =
    P.whateverPyramid
