module Request.PullRequest exposing (..)

import Http
import HttpBuilder
import Json.Decode exposing (Decoder)
import Data.AuthToken exposing (AuthToken, withAuthorization)
import Data.PullRequest exposing (PullRequest)
import Request.Utils exposing (apiUrl)


list : AuthToken -> Http.Request (List PullRequest)
list token =
    apiUrl "/issues?filter=assigned"
        |> HttpBuilder.get
        |> withAuthorization (Just token)
        |> HttpBuilder.withExpect (Http.expectJson decodePullRequestList)
        |> HttpBuilder.toRequest


decodePullRequestList: Decoder (List PullRequest)
decodePullRequestList =
    Json.Decode.list Data.PullRequest.decoder
