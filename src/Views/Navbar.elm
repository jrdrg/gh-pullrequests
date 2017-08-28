module Views.Navbar exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import DateUtils


navbar model =
    nav [ class "navbar" ]
        [ div
            [ class "navbar-brand" ]
            [ a [ class "navbar-item" ] [ text "Github API stuff" ] ]
        , div
            [ class "navbar-menu" ]
            [ div
                [ class "navbar-start" ]
                [ a [ class "navbar-item" ] [ text "item 1" ]
                , a [ class "navbar-item" ] [ text "item 2" ]
                ]
            , div
                [ class "navbar-end" ]
                [ div [ class "navbar-item" ] [ text <| formattedDate model.now ] ]
            ]
        ]


formattedDate date =
    date
        |> toString
        |> DateUtils.formatDate
