module NanoId exposing
    ( nanoid, nanoidWithSize, customAlphabet
    , defaultSize, defaultChars
    )

{-| NanoId generator


# Generators

@docs nanoid, nanoidWithSize, customAlphabet


# Default Configuration Variables

@docs defaultSize, defaultChars

-}

import Array exposing (Array)
import Dict exposing (size)
import Random



-- NanoId configuration


{-| Configuration for NanoId.customGenerator.

To make these, try [`defaultConfig`](#defaultConfig), [`sizedConfig`](#sizedConfig),
or [`customConfig`](#customConfig).

-}
type alias NanoIdConfig =
    { size : Int
    , chars : Array Char
    }


isValidConfig : NanoIdConfig -> Bool
isValidConfig config =
    (Array.length config.chars > 0) && (config.size > 1)


{-| Default configuration for NanoId.

    ID size is 21, using chars from `[a-zA-Z0-9_-]`.

-}
defaultConfig : NanoIdConfig
defaultConfig =
    customConfig defaultChars defaultSize


{-| Uses same pattern from original nanoid.
See <https://github.com/ai/nanoid/blob/main/non-secure/index.js>
-}
urlAlphabet : String
urlAlphabet =
    "useandom-26T198340PX75pxJACKVERYMINDBUSHWOLF_GQZbfghjklqvwyzrict"


{-| Default ID size (21 digits)
-}
defaultSize : Int
defaultSize =
    21


{-| Default chars (`[a-zA-Z0-9_-]`)
-}
defaultChars : String
defaultChars =
    urlAlphabet


{-| Create custom configuration.

    ```
    NanoId.customConfig "abcdefghijklmnopqrstuvwxyz0123456789" 15
    ```

-}
customConfig : String -> Int -> NanoIdConfig
customConfig str size =
    { size = size
    , chars = str |> String.toList |> Array.fromList
    }


generator : NanoIdConfig -> Random.Generator String
generator config =
    if isValidConfig config then
        Array.length config.chars
            - 1
            |> Random.int 0
            |> Random.map (getChar config.chars)
            |> Random.list config.size
            |> Random.map String.fromList

    else
        Random.constant ""


getChar : Array Char -> Int -> Char
getChar chars index =
    Array.get index chars |> Maybe.withDefault ' '



-- Generators


{-| Create nanoid generator with default configuration.

    import NanoId exposing (nanoid)
    import Random

    type Msg
        = GenerateNanoId
        | NanoIdGenerated String

    generateNanoId : Cmd Msg
    generateNanoId =
        Random.generate NanoIdGenerated nanoid

    update msg model =
        case msg of
            GenerateNanoId ->
                ( model, generateNanoId )

-}
nanoid : Random.Generator String
nanoid =
    generator defaultConfig


{-| Create nanoid generator with customized ID size.

    import NanoId exposing (nanoidWithSize)
    import Random

    type Msg
        = GenerateNanoId
        | NanoIdGenerated String

    generateNanoId : Cmd Msg
    generateNanoId =
        Random.generate NanoIdGenerated <| nanoidWithSize 14

    update msg model =
        case msg of
            GenerateNanoId ->
                ( model, generateNanoId )

Note:

  - If size is 0 or negative interger, generator generates empty string.

-}
nanoidWithSize : Int -> Random.Generator String
nanoidWithSize size =
    generator <| customConfig defaultChars size


{-| Create nanoid generator with customized alphabet and ID size.

    import NanoId exposing (customAlphabet)
    import Random

    type Msg
        = GenerateNanoId
        | NanoIdGenerated String

    generateNanoId : Cmd Msg
    generateNanoId =
        Random.generate NanoIdGenerated <| customAlphabet "1234567890abcdef" 10

    update msg model =
        case msg of
            GenerateNanoId ->
                ( model, generateNanoId )

Note:

  - If alphabet length is 0, generator generates empty string.
  - If size is 0 or negative interger, generator generates empty string.

-}
customAlphabet : String -> Int -> Random.Generator String
customAlphabet alphabet size =
    generator <| customConfig alphabet size
