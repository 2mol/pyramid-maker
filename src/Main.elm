module Main exposing (main)

{-| go away, read your own source code.
@docs main
-}

import Html
import Model exposing (Model, initialModel)
import Update exposing (Msg, update)
import View exposing (view)


{-| No.
-}
main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }
