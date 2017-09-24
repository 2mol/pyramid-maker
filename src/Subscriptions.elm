module Subscriptions exposing (subscriptions)

import Types exposing (..)
import Mouse


subscriptions : Model -> Sub Msg
subscriptions model =
    case ( model.drag, model.draggedPointIndex ) of
        ( Just _, Just index ) ->
            Sub.batch
                [ Mouse.moves (DragAt index)
                , Mouse.ups (DragEnd index)
                ]

        _ ->
            Sub.none
