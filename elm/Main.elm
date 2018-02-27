module App exposing (..)

import Html exposing (Html, a, div, pre, code, img, text, textarea, program)
import Html.Attributes exposing (class, href, src, style)
import Html.Events exposing (onClick, onInput)
import Http
import Ports exposing (highlight)
import Pasta exposing (savePastaRequest)


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
    | ContentChanged String
    | DoSavePasta String
    | SavePastaResult (Result Http.Error Pasta.Pasta)


view : Model -> Html Msg
view model =
    let
        logo =
            img [ src "/static/img/logo.svg", class "logo", onClick <| Debug.log "CLICK" NoOp ] []

        saveBtn =
            a [ class "save-button", href "#", onClick <| DoSavePasta model.content ] [ text "PASTA!" ]
    in
        div []
            [ textarea [ onInput ContentChanged ] [ text model.content ]
            , logo
            , saveBtn
            ]



-- view : Model -> Html Msg
-- view model =
--     pre [ class "content", style [ ( "margin", "0" ), ( "padding", "0" ) ] ]
--         [ code [] [ text model.content ] ]


doPastaSave : String -> Cmd Msg
doPastaSave string =
    Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ContentChanged string ->
            ( { model | content = string }, Cmd.none )

        DoSavePasta content ->
            ( model
            , Http.send
                SavePastaResult
                (savePastaRequest model.content)
            )

        SavePastaResult (Ok result) ->
            ( model, Cmd.none )

        SavePastaResult (Err _) ->
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
