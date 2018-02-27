module App exposing (..)

import Html exposing (Html, a, div, pre, code, img, text, textarea, program)
import Html.Attributes exposing (class, href, src, style)
import Html.Events exposing (onClick)
import Ports exposing (highlight)


type alias Model =
    { content : String
    }


initialModel : Model
initialModel =
    { content = """// PASTA v0.1
//
// Super simple pastebin
""" }


init : ( Model, Cmd Msg )
init =
    ( initialModel, highlight "content" )


type Msg
    = NoOp


view : Model -> Html Msg
view model =
    div []
        [ textarea [] [ text "// Paste here :)" ]
        , img [ src "/static/img/logo.svg", class "logo", onClick <| Debug.log "CLICK" NoOp ] []
        , a [ class "save-button", href "#" ] [ text "PASTA!" ]
        ]



-- view : Model -> Html Msg
-- view model =
--     pre [ class "content", style [ ( "margin", "0" ), ( "padding", "0" ) ] ]
--         [ code [] [ text model.content ] ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
