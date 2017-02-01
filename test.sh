#!/bin/bash

# this script tests a couple of basic jekyll subcommands and checks the exit
# codes. the serve subcommand is a little more difficult, as i do not know any
# reliable way to check the running process.

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
cd "$CURRENT_DIR"

function trigger_error () {
	echo "<!> Test failed!"
	exit 1
}

# ========================================

echo '> Testing jekyll presence'
if [[ ! -f ./jekyll.exe ]]; then
	trigger_error
fi

# ========================================

echo '> Testing jekyll default response ("A subcommand is required.")'
output="$(./jekyll.exe 2>&1 > /dev/null)"

if [[ ! ( $? -eq 1 && "$output" == *"A subcommand is required."* ) ]]; then
	trigger_error
fi

# ========================================

echo '> Testing jekyll help'
./jekyll.exe help
if [[ ! $? -eq 0 ]]; then
	trigger_error
fi

# ========================================

echo '> Testing jekyll new'
folder_name="jekyll-new-folder"
rm -rf "$folder_name"
mkdir "$folder_name"

./jekyll.exe new "$folder_name"
# if [[ ! $? -eq 0 ]]; then
# 	trigger_error
# fi

# ========================================

echo '> Testing jekyll build, b'
cd "$folder_name"
rm Gemfile

../jekyll.exe build
if [[ ! $? -eq 0 ]]; then
	trigger_error
fi

cd ..

# ========================================

echo '> Testing jekyll clean'
cd "$folder_name"

../jekyll.exe clean
if [[ ! $? -eq 0 ]]; then
	trigger_error
fi

cd ..

# ========================================

echo '> Testing jekyll doctor, hyde'
cd "$folder_name"

../jekyll.exe hyde
if [[ ! $? -eq 0 ]]; then
	trigger_error
fi

cd ..

# ========================================

echo "> Test all OK"
printf "\n> Please test jekyll serve manually with the \"$folder_name\" folder."
