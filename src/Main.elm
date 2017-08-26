module Main exposing (..)

import Http
import Json.Decode
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Ports
import Data.Session exposing (Session)
import Views.Navbar exposing (navbar)
import Request.PullRequest
import Data.AuthToken exposing (AuthToken)
import Data.PullRequest exposing (PullRequest)
import Views.PullRequests


(=>) =
    (,)


type alias Model =
    { session : Session
    , repositories : List String
    , pullRequests : List PullRequest
    , error : String
    }


type Msg
    = SendRequest
    | ListPullRequests (Result Http.Error (List PullRequest))


main : Program Json.Decode.Value Model Msg
main =
    Html.programWithFlags
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


init : Json.Decode.Value -> ( Model, Cmd Msg )
init value =
    ( Model
        (value
            |> Data.Session.fromJson
            |> Maybe.withDefault (Session Nothing)
        )
        []
        []
        ""
    , Cmd.none
    )


subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ListPullRequests list ->
            case list of
                Result.Ok requests ->
                    { model | pullRequests = requests } => Cmd.none

                Result.Err (Http.BadPayload err _) ->
                    Debug.log "ERR" { model | error = err } => Cmd.none

                _ ->
                    Debug.log "???" model => Cmd.none

        SendRequest ->
            let
                { session } =
                    model

                getList token =
                    token
                        |> Request.PullRequest.list
                        |> Http.send ListPullRequests
            in
                session
                    |> Data.Session.tryAction getList
                    |> (,) model


view model =
    div []
        [ navbar
        , section
            [ textDiv "testing"
            , requestButton
            , Views.PullRequests.view model.pullRequests
            ]
        ]


section children =
    div [ class "section" ] children


requestButton =
    button [ class "button is-primary", onClick SendRequest ] [ text "request repos" ]


textDiv msg =
    div [] [ text msg ]


sessionChange : Sub (Maybe Session)
sessionChange =
    Ports.onSessionChanged (Json.Decode.decodeValue Data.Session.decoder >> Result.toMaybe)
