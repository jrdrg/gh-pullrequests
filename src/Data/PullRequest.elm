module Data.PullRequest exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required, custom, optional)


type alias PullRequest =
    { createdAt : String
    , user : String
    , repository : Repository
    , labels : List Label
    , milestone : Maybe String
    , url : String
    , title : String
    , updatedAt : String
    , body : String
    }


type alias Repository =
    { url : String
    }


type alias Label =
    { name : String
    , color : String
    }


decoder : Decoder PullRequest
decoder =
    decode PullRequest
        |> required "created_at" Decode.string
        |> custom (Decode.at [ "user", "login" ] Decode.string)
        |> custom (Decode.at [ "repository" ] decodeRepository)
        |> optional "labels" (Decode.list decodeLabel) []
        |> optional "milestone" decodeMilestone Nothing
        |> custom (Decode.at [ "pull_request", "html_url" ] Decode.string)
        |> required "title" Decode.string
        |> required "updated_at" Decode.string
        |> required "body" Decode.string


decodeMilestone : Decoder (Maybe String)
decodeMilestone =
    Decode.at [ "title" ] (Decode.nullable Decode.string)


decodeRepository : Decoder Repository
decodeRepository =
    decode Repository
        |> required "html_url" Decode.string


decodeLabel : Decoder Label
decodeLabel =
    decode Label
        |> required "name" Decode.string
        |> required "color" Decode.string
