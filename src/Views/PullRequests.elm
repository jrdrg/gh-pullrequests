module Views.PullRequests exposing (..)

import Date
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Data.PullRequest exposing (PullRequest)


view : List PullRequest -> Html msg
view list =
    let
        grouped =
            list |> byMilestone
    in
        div [ class "section" ]
            (grouped |> List.map milestoneSection)


milestoneSection : ( String, List PullRequest ) -> Html msg
milestoneSection ( milestone, list ) =
    div
        [ class "message" ]
        [ div
            [ class "message-header" ]
            [ text <|
                if milestone == "" then
                    "No milestone"
                else
                    milestone
            ]
        , div
            [ class "message-body" ]
            [ div
                [ class "columns is-multiline" ]
                (list |> List.map pullRequest)
            ]
        ]


pullRequest : PullRequest -> Html msg
pullRequest pr =
    let
        { title, body, url } =
            pr

        milestone =
            case pr.milestone of
                Just value ->
                    value

                Nothing ->
                    "No milestone"
    in
        div
            [ class "column is-4" ]
            [ div [ class "card" ]
                [ header
                    [ class "card-header" ]
                    [ p [ class "card-header-title" ]
                        [ text title ]
                    ]
                , div
                    [ class "card-content" ]
                    [ div
                        [ class "content" ]
                        [ div
                            []
                            [ a
                                [ target "_blank", href pr.repository.url ]
                                [ text pr.repository.url ]
                            ]
                        , line body
                        , line (pr.updatedAt |> formatDate)
                        , div
                            []
                            (pr.labels |> List.map label)
                        ]
                    ]
                , footer
                    [ class "card-footer" ]
                    [ cardButton url "Pull request"
                    ]
                ]
            ]


byMilestone : List PullRequest -> List ( String, List PullRequest )
byMilestone list =
    let
        reduce : PullRequest -> Dict String (List PullRequest) -> Dict String (List PullRequest)
        reduce next acc =
            let
                milestone =
                    (next.milestone |> Maybe.withDefault "")

                grouped =
                    case Dict.get milestone acc of
                        Just group ->
                            next :: group

                        Nothing ->
                            [ next ]
            in
                acc |> Dict.insert milestone grouped
    in
        list
            |> List.foldl reduce Dict.empty
            |> Dict.toList
            |> List.reverse


label label =
    span
        [ class "tag is-primary"
        , style
            [ ( "background", "#" ++ label.color )
            , ( "margin-right", "5px" )
            ]
        ]
        [ text label.name ]


line content =
    div []
        [ text content ]


cardButton url label =
    a
        [ class "card-footer-item", href url, target "_blank" ]
        [ text label ]


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
