module Views.PullRequests exposing (..)

import Date
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Data.PullRequest exposing (PullRequest)
import Views.Elements exposing (tag, card)


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
        { title, body, url, repository } =
            pr

        milestone =
            case pr.milestone of
                Just value ->
                    value

                Nothing ->
                    "No milestone"
    in
        div
            [ class "column is-narrow" ]
            [ card
                [ p [ class "card-header-title" ]
                    [ text title ]
                ]
                [ div
                    [ class "pullrequest-url" ]
                    [ a
                        [ target "_blank", href repository.url ]
                        [ text repository.url ]
                    ]
                , div [ class "pullrequest-body" ] [ text body ]
                , line (pr.updatedAt |> formatDate)
                , div
                    [ class "pullrequest-labels" ]
                    (pr.labels |> List.map label)
                ]
                [ cardButton url "Pull request" ]
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
    tag label.name
        [ style
            [ ( "background", "#" ++ label.color )
            , ( "margin-right", "5px" )
            , ( "color", "white" )
            ]
        ]


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
