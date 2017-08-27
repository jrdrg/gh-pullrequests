module Data.Session exposing (Session, decoder, fromJson, tryAction)

import Json.Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)
import Data.AuthToken exposing (AuthToken)


type alias Session =
    { token : Maybe AuthToken
    }


fromJson : Json.Decode.Value -> Maybe Session
fromJson json =
    json
        |> Json.Decode.decodeValue Json.Decode.string
        |> Result.toMaybe
        |> Maybe.andThen (Json.Decode.decodeString decoder >> Result.toMaybe)


decoder : Decoder Session
decoder =
    decode Session
        |> required "token" (Json.Decode.nullable Data.AuthToken.decoder)


tryAction : (AuthToken -> Cmd msg) -> Session -> Cmd msg
tryAction makeCmd session =
    case session.token of
        Just auth ->
            makeCmd auth

        Nothing ->
            Cmd.none
