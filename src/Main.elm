module Main exposing (main)

{-| go away, read your own source code.
@docs main
-}

import Html
import Mouse
import Types exposing (..)
import Update exposing (update)
import View exposing (view)
import Presets


{-| No.
-}
main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( Presets.whateverPyramid, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Mouse.clicks MouseMsg
        ]



-- subscriptions : Model -> Sub Msg
-- subscriptions model =
--     case model.drag of
--         Nothing ->
--             Sub.none
--         Just _ ->
--             Sub.batch [ Mouse.moves DragAt, Mouse.ups DragEnd ]
