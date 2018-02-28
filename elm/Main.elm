module App exposing (..)

import Html exposing (Html, a, div, pre, code, img, text, textarea, program)
import Html.Attributes exposing (class, href, src, style, title, value)
import Html.Events exposing (onClick, onInput)
import Http
import Navigation
import Ports exposing (highlight)
import Pasta exposing (getPastaRequest, savePastaRequest)


type alias Model =
    { content : String
    , slug : String
    }


initialModel : Model
initialModel =
    { content = "// PASTA v0.1\n//\n// Paste here and then Pasta!"
    , slug = ""
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    update (UrlChange location) initialModel


type Msg
    = NoOp
    | ContentChanged String
    | DoSavePasta String
    | DoPastaGet String
    | NewPasta
    | GetPastaResult (Result Http.Error Pasta.Pasta)
    | SavePastaResult (Result Http.Error Pasta.Pasta)
    | UrlChange Navigation.Location


view : Model -> Html Msg
view model =
    let
        logo =
            img
                [ src "/static/img/logo.svg"
                , class "logo"
                , onClick <| NewPasta
                , title "New pasta"
                ]
                []

        saveBtn =
            a
                [ class "save-button"
                , href "#"
                , title "Save"
                , onClick <| DoSavePasta model.content
                ]
                [ text "Pasta!"
                ]
    in
        if model.slug /= "" then
            div []
                [ pre [ class "content", style [ ( "margin", "0" ), ( "padding", "0" ) ] ]
                    [ code [] [ text model.content ] ]
                , logo
                ]
        else
            div []
                [ textarea [ onInput ContentChanged, value model.content ] []
                , logo
                , saveBtn
                ]


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

        DoPastaGet slug ->
            ( model
            , Http.send
                GetPastaResult
                (getPastaRequest model.slug)
            )

        NewPasta ->
            ( model
            , Navigation.newUrl "/"
            )

        GetPastaResult (Ok result) ->
            ( { initialModel
                | content = result.content
                , slug = result.slug
              }
            , highlight "content"
            )

        GetPastaResult (Err err) ->
            ( model, Cmd.none )

        SavePastaResult (Ok result) ->
            ( { model | slug = result.slug, content = result.content }
            , Cmd.batch
                [ Navigation.newUrl <| "/" ++ result.slug
                , highlight ""
                ]
            )

        SavePastaResult (Err _) ->
            ( model, Cmd.none )

        UrlChange location ->
            let
                slug =
                    String.dropLeft 1 location.pathname
            in
                if slug /= "" then
                    ( model
                    , Http.send
                        GetPastaResult
                        (getPastaRequest slug)
                    )
                else
                    ( Debug.log "" initialModel, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
