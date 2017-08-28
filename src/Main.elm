module Main exposing (..)

import Http
import Date
import Time
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
import DateUtils

(=>) =
    (,)


type Msg
    = SendRequest
    | ListPullRequests (Result Http.Error (List PullRequest))


type alias Model =
    { session : Session
    , now : Date.Date
    , pullRequests : List PullRequest
    , error : String
    }


type alias Flags =
    { value : Json.Decode.Value
    , now : Time.Time
    }


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


init : Flags -> ( Model, Cmd Msg )
init { value, now } =
    let
        model =
            Model
                (value
                    |> Data.Session.fromJson
                    |> Maybe.withDefault (Session Nothing)
                )
                (now |> Date.fromTime)
                []
                ""
    in
        ( model
        , getPullRequests model.session
        )


subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ListPullRequests list ->
            case list of
                Result.Ok requests ->
                    let
                        sorted =
                            requests |> List.sortWith sortDescending
                    in
                        { model | pullRequests = sorted } => Cmd.none

                Result.Err (Http.BadPayload err _) ->
                    Debug.log "ERR" { model | error = err } => Cmd.none

                Result.Err _ ->
                    Debug.log "???" model => Cmd.none

        SendRequest ->
            model.session
                |> getPullRequests
                |> (,) model


view model =
    div []
        [ navbar model
        , section
            [ Views.PullRequests.view model.pullRequests
            ]
        ]


getPullRequests : Session -> Cmd Msg
getPullRequests session =
    let
        getList token =
            token
                |> Request.PullRequest.list
                |> Http.send ListPullRequests
    in
        session
            |> Data.Session.tryAction getList


sortDescending r1 r2 =
    let
        milestone =
            .milestone >> Maybe.withDefault ""
    in
        case compare (milestone r1) (milestone r2) of
            LT ->
                GT

            EQ ->
                EQ

            GT ->
                LT


errorMessage : Http.Error -> String
errorMessage error =
    case error of
        Http.BadPayload message _ ->
            Debug.log "ERR" message

        _ ->
            ""


section children =
    div [ class "section" ] children


requestButton =
    button [ class "button is-primary", onClick SendRequest ] [ text "request repos" ]


textDiv msg =
    div [] [ text msg ]


sessionChange : Sub (Maybe Session)
sessionChange =
    Ports.onSessionChanged (Json.Decode.decodeValue Data.Session.decoder >> Result.toMaybe)
