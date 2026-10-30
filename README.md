# README

## Run instructions

In order to run:
`make clean && make && make test_scanner`

## Note about tests

We found that bad4.bminor and bad9.bminor are not in line with the 2025 spec.

1. bad4.bminor: Expects floats to fail.
1. bad9.bminor: Expects hash to not be a symbol

## Group Members

Hriddhiman Sardar
Adriano Marcelo Vilarga Corbelino II
Jegannarayanan Sivakasiulaganathan
Conor Quinn
Lavish Kumar

## Building
```
make
```

## Running Tests
These make recipes will clean then run tests.
### Scanner
```sh
make test_scan
```
### Parser
```sh
make test # usually set in Makefile per assignment
make test_parse
```

## Clean up All Non-Source Files
```sh
make clean
```

## Making Homework ZIP
```sh
make zip
```

## Note for macOS Users
If you have `commandlinetools` installed, you may have old bison (v2.x) on your path and at `/usr/bin/bison`. To provide bison 3.x, use `make` while specifying `BISON=custom_bison_path`.

Example:
```sh
make test_scan BISON=/opt/homebrew/opt/bison/bin/bison
make test_parse BISON=/opt/homebrew/opt/bison/bin/bison
make BISON=/opt/homebrew/opt/bison/bin/bison
```

## Note
We renamed `tests/parser` to `tests/parse` to match the parse flag.
