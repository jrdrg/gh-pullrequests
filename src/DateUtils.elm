module DateUtils exposing (..)

import Date


formatDate : String -> String
formatDate date =
    let
        time dt =
            (Date.hour dt |> toString) ++ ":" ++ (Date.minute dt |> toString)

        mdy dt =
            (Date.month dt |> toString) ++ " " ++ (Date.day dt |> toString) ++ " " ++ (Date.year dt |> toString)

        result =
            case (date |> Date.fromString) of
                Result.Ok dt ->
                    (mdy dt) ++ ", " ++ (time dt)

                Result.Err err ->
                    err
    in
        result
