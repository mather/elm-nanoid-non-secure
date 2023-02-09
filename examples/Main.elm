module Main exposing (main)

import Browser
import Html exposing (Html, button, div, fieldset, h1, input, label, legend, li, option, p, pre, select, text, ul)
import Html.Attributes as A
import Html.Events exposing (onClick, onInput)
import NanoId exposing (customAlphabet, nanoid, nanoidWithSize)
import Random


type alias Model =
    { generatedId : Maybe String
    , chars : String
    , size : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { generatedId = Nothing
      , chars = "abcdefgABCDEFG0123456789"
      , size = 10
      }
    , Cmd.none
    )


type Msg
    = GenerateNanoId
    | GenerateNanoIdWithSize Int
    | GenerateNanoIdWithCustom String Int
    | NanoIdGenerated String
    | UpdateSize Int
    | UpdateChars String
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GenerateNanoId ->
            ( model, Random.generate NanoIdGenerated nanoid )

        GenerateNanoIdWithSize size ->
            ( model, Random.generate NanoIdGenerated <| nanoidWithSize size )

        GenerateNanoIdWithCustom chars size ->
            ( model, Random.generate NanoIdGenerated <| customAlphabet chars size )

        NanoIdGenerated newId ->
            ( { model | generatedId = Just newId }, Cmd.none )

        UpdateSize size ->
            ( { model | size = size }, Cmd.none )

        UpdateChars chars ->
            ( { model | chars = chars }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


onSizeInput : String -> Msg
onSizeInput =
    UpdateSize << Maybe.withDefault 21 << String.toInt


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Elm NanoId (non-secure) Examples" ]
        , p []
            [ pre [] [ text <| (++) "Generated nanoid: " <| Maybe.withDefault "" <| model.generatedId ] ]
        , ul []
            [ li [] [ button [ onClick GenerateNanoId ] [ text "Generate standard nanoid" ] ]
            , li [] [ button [ onClick <| GenerateNanoIdWithSize model.size ] [ text "Generate sized nanoid" ] ]
            , li [] [ button [ onClick <| GenerateNanoIdWithCustom model.chars model.size ] [ text "Generate nanoid using custom chars" ] ]
            ]
        , div []
            [ fieldset []
                [ legend [] [ text "Options" ]
                , div []
                    [ label [] [ text "Size: " ]
                    , select [ A.value <| String.fromInt model.size, onInput onSizeInput ]
                        (List.range 1 21 |> List.map (\n -> option [ A.value <| String.fromInt n, A.selected <| model.size == n ] [ text <| String.fromInt n ]))
                    ]
                , div []
                    [ label [] [ text "Chars: " ]
                    , input [ A.type_ "text", A.size 100, A.value model.chars, onInput UpdateChars ] []
                    ]
                ]
            ]
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
