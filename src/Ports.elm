port module Ports exposing (..)

import Json.Encode


port serializeSession : Maybe String -> Cmd msg


port onSessionChanged : (Json.Encode.Value -> msg) -> Sub msg
