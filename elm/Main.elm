module App exposing (..)

import Html exposing (Html, pre, code, text, program)
import Html.Attributes exposing (class, style)
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
    pre [ class "content", style [ ( "margin", "0" ), ( "padding", "0" ) ] ]
        [ code [] [ text model.content ] ]


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
