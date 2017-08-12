module Main exposing (main)

{-| go away, read your own source code.
@docs main
-}

import Html
import Mouse exposing (Position)
import Types exposing (..)
import Update exposing (update)
import View exposing (view)
import Presets


{-| No.
-}
main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = Presets.whateverPyramid
        , view = view
        , update = update
        }



-- subscriptions : Model -> Sub Msg
-- subscriptions model =
--     case model.drag of
--         Nothing ->
--             Sub.none
--         Just _ ->
--             Sub.batch [ Mouse.moves DragAt, Mouse.ups DragEnd ]
