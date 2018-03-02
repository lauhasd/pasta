port module Ports exposing (highlight, highlighted)


port highlight : String -> Cmd msg


port highlighted : (String -> msg) -> Sub msg
