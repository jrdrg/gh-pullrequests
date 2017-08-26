module Data.AuthToken exposing (AuthToken, withAuthorization, encode, decoder)

import HttpBuilder exposing (RequestBuilder, withHeader)
import Json.Decode exposing (Decoder)
import Json.Encode exposing (Value)


type AuthToken
    = AuthToken String


withAuthorization : Maybe AuthToken -> RequestBuilder a -> RequestBuilder a
withAuthorization token builder =
    case token of
        Just (AuthToken auth) ->
            builder |> withHeader "Authorization" ("token " ++ auth)

        Nothing ->
            builder


encode : AuthToken -> Value
encode (AuthToken token) =
    Json.Encode.string token


decoder : Decoder AuthToken
decoder =
    Json.Decode.string
        |> Json.Decode.map AuthToken
