
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