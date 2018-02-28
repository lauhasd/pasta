module Pasta exposing (..)

import Http
import Json.Decode as Decode
import Json.Encode as Encode


type alias Pasta =
    { slug : String
    , content : String
    }



-- ENCODE


pastaEncoder : Pasta -> Encode.Value
pastaEncoder pasta =
    Encode.object
        [ ( "slug", Encode.string pasta.slug )
        , ( "content", Encode.string pasta.content )
        ]



-- DECODER


pastaDecoder : Decode.Decoder Pasta
pastaDecoder =
    Decode.map2 Pasta
        (Decode.field "slug" Decode.string)
        (Decode.field "content" Decode.string)



-- REQUESTS


savePastaRequest : String -> Http.Request Pasta
savePastaRequest content =
    let
        body =
            Pasta "" content
                |> pastaEncoder
                |> Http.jsonBody
    in
        Http.post "/api/pasta/" body pastaDecoder


getPastaRequest : String -> Http.Request Pasta
getPastaRequest slug =
    Http.get ("/api/pasta/" ++ slug) pastaDecoder
