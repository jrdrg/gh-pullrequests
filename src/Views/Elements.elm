module Views.Elements exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


tag : String -> List (Html.Attribute msg) -> Html msg
tag label attrs =
    span
        (List.append attrs [ class "tag" ])
        [ text label ]


section content =
    div
        [ class "section" ]
        content


card headerContent content footerContent =
    div
        [ class "card" ]
        [ header
            [ class "card-header" ]
            headerContent
        , div
            [ class "card-content" ]
            [ div
                [ class "content" ]
                content
            ]
        , footer
            [ class "card-footer" ]
            footerContent
        ]
