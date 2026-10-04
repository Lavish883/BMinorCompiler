#!/usr/bin/env fish

set output "Group1_CC_A1.zip"
set files (cat files_to_zip.txt)

zip -r $output $files
