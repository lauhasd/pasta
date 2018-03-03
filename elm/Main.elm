module App exposing (..)

import Html
    exposing
        ( Html
        , a
        , code
        , div
        , h3
        , img
        , input
        , li
        , p
        , program
        , pre
        , span
        , text
        , textarea
        , ul
        )
import Html.Attributes exposing (class, href, property, src, style, title, type_, value)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Encode exposing (string)
import Navigation
import Ports exposing (highlight, highlighted)
import Pasta exposing (getPastaRequest, savePastaRequest)


type State
    = EditPasta
    | ViewPasta


type alias Model =
    { content : String
    , slug : String
    , state : State
    , showAbout : Bool
    }


initialContent : String
initialContent =
    "// PASTA v0.1\n//\n// Paste here and hit save!"


initialModel : Model
initialModel =
    { content = initialContent
    , slug = ""
    , state = EditPasta
    , showAbout = False
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    update (UrlChange location) initialModel


type Msg
    = ContentChanged String
    | DoSavePasta String
    | DoPastaGet String
    | HighlightResult String
    | NewPasta
    | GetPastaResult (Result Http.Error Pasta.Pasta)
    | SavePastaResult (Result Http.Error Pasta.Pasta)
    | UrlChange Navigation.Location
    | ToggleAboutBox Bool


view : Model -> Html Msg
view model =
    let
        logo =
            img
                [ src "/static/img/logo.svg"
                , class "logo"
                , title "About"
                , onClick <| ToggleAboutBox True
                ]
                []

        saveBtn =
            if model.content == initialContent || model.content == "" then
                a [ class "disabled-button", title "Save" ] [ text "Save" ]
            else
                a
                    [ class "save-button"
                    , title "Save"
                    , onClick <| DoSavePasta model.content
                    ]
                    [ text "Save" ]

        newBtn =
            a
                [ class "new-button"
                , title "New"
                , onClick NewPasta
                ]
                [ text "New" ]
    in
        div []
            [ logo
            , aboutBox model.showAbout
            , (case model.state of
                EditPasta ->
                    div []
                        [ textarea
                            [ onInput ContentChanged
                            , value model.content
                            ]
                            []
                        , saveBtn
                        ]

                ViewPasta ->
                    div [] [ highlightedContent model.content, newBtn ]
              )
            ]


aboutBox : Bool -> Html Msg
aboutBox show =
    let
        logo =
            img
                [ src "/static/img/logo.svg"
                , title "Pasta!"
                ]
                []

        classes =
            case show of
                True ->
                    "about-box"

                False ->
                    "about-box hidden"
    in
        div [ class classes, onClick <| ToggleAboutBox False ]
            [ logo
            , h3 [] [ text "Pasta" ]
            , p [] [ text "A dead simple pastebin for your pasting needs." ]
            ]


highlightedContent : String -> Html Msg
highlightedContent content =
    pre [] [ code [ property "innerHTML" <| string content ] [] ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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

        HighlightResult result ->
            ( { model | content = result, state = ViewPasta }, Cmd.none )

        NewPasta ->
            ( { model | state = EditPasta }
            , Navigation.newUrl "/"
            )

        GetPastaResult (Ok result) ->
            ( { initialModel
                | content = result.content
                , slug = result.slug
                , state = ViewPasta
              }
            , highlight result.content
            )

        GetPastaResult (Err err) ->
            ( model, Cmd.none )

        SavePastaResult (Ok result) ->
            ( { model
                | slug = result.slug
                , content = result.content
                , state = ViewPasta
              }
            , Cmd.batch
                [ Navigation.newUrl <| "/" ++ result.slug
                , highlight result.content
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
                    ( { model | state = ViewPasta }
                    , Http.send
                        GetPastaResult
                        (getPastaRequest slug)
                    )
                else
                    ( initialModel, Cmd.none )

        ToggleAboutBox bool ->
            ( { model | showAbout = bool }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    highlighted HighlightResult


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
