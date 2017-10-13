module Subscriptions exposing (subscriptions)

import Types exposing (..)
import Mouse


subscriptions : Model -> Sub Msg
subscriptions { drag } =
    case drag of
        Just { index } ->
            Sub.batch
                [ Mouse.moves (DragAt index)
                , Mouse.ups (DragEnd index)
                ]

        _ ->
            Sub.none
