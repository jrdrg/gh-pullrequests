module Views.Navbar exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


navbar =
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
            ]
        ]
