rm Group1_CC_A1.zip
rm -rf test_submission/
fish zip_files.fish
unzip Group1_CC_A1.zip -d test_submission/
cd test_submission/; or exit 1
make clean && make && make test_scanner
