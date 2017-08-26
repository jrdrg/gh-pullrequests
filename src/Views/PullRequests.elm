module Views.PullRequests exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Data.PullRequest exposing (PullRequest)


view : List PullRequest -> Html msg
view list =
    div [ class "section" ]
        (list |> List.map pullRequest)


line content =
    div []
        [ text content ]


pullRequest : PullRequest -> Html msg
pullRequest pr =
    let
        { title, body } =
            pr

        milestone =
            case pr.milestone of
                Just value ->
                    value
                Nothing ->
                    "No milestone"
    in
        div [ class "card" ]
            [ header
                [ class "card-header" ]
                [ p [ class "card-header-title" ]
                    [ text title ]
                ]
            , div
                [ class "card-content" ]
                [ div
                    [ class "content" ]
                    [ line body
                    , line milestone
                    ]
                ]
            ]
