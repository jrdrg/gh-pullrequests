module Data.PullRequest exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required, custom, optional)


type alias PullRequest =
    { createdAt : String
    , user : String
    -- , labels : List String
    , milestone : Maybe String
    -- , url : String
    -- , repositoryUrl : String
    , title : String
    -- , updatedAt : String
    , body : String
    }


decoder : Decoder PullRequest
decoder =
    decode PullRequest
        |> required "created_at" Decode.string
        |> custom (Decode.at ["user", "login"] Decode.string)
        |> optional "milestone" decodeMilestone Nothing
        |> required "title" Decode.string
        |> required "body" Decode.string



decodeMilestone: Decoder (Maybe String)
decodeMilestone =
    Decode.at ["title"] (Decode.nullable Decode.string)
