# nanoid generator for Elm

[![Test](https://github.com/mather/elm-nanoid-non-secure/actions/workflows/build.yml/badge.svg)](https://github.com/mather/elm-nanoid-non-secure/actions/workflows/build.yml)

This package provides [nanoid (non-secure ver.)](https://github.com/ai/nanoid#non-secure) over [elm/random](https://package.elm-lang.org/packages/elm/random/latest/).

If you are concerned about security, please refer to [ai/nanoid#Security](https://github.com/ai/nanoid#security).

## Usage

Standard `nanoid` generate 21-digits ID using `[a-zA-Z0-9_-]` characters.

```elm
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
```

Or else, use `nanoidWithSize` to change ID size, `customAlphabet` to change characters and ID size.

## License

MIT License