rm Group1_CC_A1.zip || true
rm -rf test_submission/ || true
fish zip_files.fish
unzip Group1_CC_A1.zip -d test_submission/
cd test_submission/; or exit 1
make clean && make && make test_scanner
