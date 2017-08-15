module Main exposing (main)

{-| go away, read your own source code.
@docs main
-}

import Html
import Types exposing (..)
import Update
import View
import Subscriptions
import Presets


{-| No.
-}
main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = View.view
        , update = Update.update
        , subscriptions = Subscriptions.subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( Model Presets.whateverPyramid Nothing Nothing, Cmd.none )
