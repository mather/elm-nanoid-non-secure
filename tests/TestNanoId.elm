module TestNanoId exposing (..)

import Expect
import Fuzz
import NanoId exposing (customAlphabet, nanoid, nanoidWithSize)
import Random
import Regex
import Test exposing (Test, describe, fuzz)


defaultRegex : Regex.Regex
defaultRegex =
    Regex.fromString "^[a-zA-Z0-9_-]+$" |> Maybe.withDefault Regex.never


lowerAndNumberRegex : Regex.Regex
lowerAndNumberRegex =
    Regex.fromString "^[a-z0-9]+$" |> Maybe.withDefault Regex.never


suite : Test
suite =
    describe "NanoId module"
        [ describe "nanoid generator"
            [ fuzz Fuzz.int "generate 21-digit nanoid" <|
                \intValue ->
                    let
                        ( value, _ ) =
                            Random.initialSeed intValue |> Random.step nanoid
                    in
                    Expect.equal 21 (String.length value)
            , fuzz Fuzz.int "generate nanoid with default characters" <|
                \intValue ->
                    let
                        ( value, _ ) =
                            Random.initialSeed intValue |> Random.step nanoid
                    in
                    Regex.contains defaultRegex value
                        |> Expect.equal True
            ]
        , describe "nanoidWithSize generator"
            [ fuzz Fuzz.int "generate 10-digit nanoid" <|
                \intValue ->
                    let
                        ( value, _ ) =
                            Random.initialSeed intValue |> Random.step (nanoidWithSize 10)
                    in
                    Expect.equal 10 (String.length value)
            , fuzz Fuzz.int "generate 30-digit nanoid" <|
                \intValue ->
                    let
                        ( value, _ ) =
                            Random.initialSeed intValue |> Random.step (nanoidWithSize 30)
                    in
                    Expect.equal 30 (String.length value)
            , fuzz Fuzz.int "generate nanoid with default characters" <|
                \intValue ->
                    let
                        ( value, _ ) =
                            Random.initialSeed intValue |> Random.step (nanoidWithSize 10)
                    in
                    Regex.contains defaultRegex value
                        |> Expect.equal True
            , fuzz Fuzz.int "generate empty string for invalid number" <|
                \intValue ->
                    let
                        ( value, _ ) =
                            Random.initialSeed intValue |> Random.step (nanoidWithSize -1)
                    in
                    Expect.equal "" value
            ]
        , describe "customAlphabet generator"
            [ fuzz Fuzz.int "generate 15-digit nanoid" <|
                \intValue ->
                    let
                        ( value, _ ) =
                            Random.initialSeed intValue |> Random.step (customAlphabet "abcdefghijklmnopqrstuvwxyz0123456789" 15)
                    in
                    Expect.equal 15 (String.length value)
            , fuzz Fuzz.int "generate nanoid with specific characters" <|
                \intValue ->
                    let
                        ( value, _ ) =
                            Random.initialSeed intValue |> Random.step (customAlphabet "abcdefghijklmnopqrstuvwxyz0123456789" 15)
                    in
                    Regex.contains lowerAndNumberRegex value
                        |> Expect.equal True
            , fuzz Fuzz.int "generate empty string for invalid chars" <|
                \intValue ->
                    let
                        ( value, _ ) =
                            Random.initialSeed intValue |> Random.step (customAlphabet "" 21)
                    in
                    Expect.equal "" value
            ]
        ]
