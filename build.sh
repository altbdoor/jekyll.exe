#!/bin/bash

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
cd "$CURRENT_DIR"

VERSION="$1"

OIFS="$IFS"
IFS=','
read -r -a INJECT_DEPS <<< "$2"
read -r -a BUNDLER_DEPS <<< "$3"
IFS="$OIFS"

# ========================================

# simple check version
if [[ -z "$VERSION" || "$VERSION" == "help" || "$VERSION" == "-h" ]]; then
	cat << EOF
Usage: ./build.sh VERSION [INJECT_DEPS] [BUNDLER_DEPS]
Compiles Jekyll into a single .exe file for Windows with OCRA.

  VERSION       Specifies the Jekyll version to build. E.g., "2.5.3". For a
                list of versions, use 'gem list "^jekyll$" -ra'.
  INJECT_DEPS   Optional, manually injects dependencies into the executable
                Jekyll file, comma separated. E.g., "webrick,jekyll-watch".
  BUNDLER_DEPS  Optional, manually injects dependencies via Bundler, comma
                separated. E.g., "webrick,jekyll-watch".

This script assumes that you already have installed whatever dependencies that
you are looking to inject.
EOF
	exit 0
fi

# check if jekyll version was installed
has_installed=$(gem list jekyll --local --installed -v "$VERSION")
if [[ "$has_installed" == "false" ]]; then
	echo "> Version $VERSION not installed. Installing..."
	gem install jekyll -v "$VERSION"
fi

# unpack gem
echo "> Unpacking gem..."
gem unpack jekyll -v "$VERSION"
folder_name="jekyll-$VERSION"
jekyll_bin=$(find "$folder_name" -name "jekyll" -type f | head -1)

# manually add dependencies into jekyll
if [[ ${#INJECT_DEPS[@]} -gt 0 ]]; then
	echo "> Manually injecting dependencies into Jekyll executable..."
	
	sed_filename="temp.sed"
	touch "$sed_filename"
	
	for dep in "${INJECT_DEPS[@]}"; do
		echo "require '$dep'" >> "$sed_filename"
	done
	
	sed -i "/require ['\"]jekyll['\"]/r $sed_filename" "$jekyll_bin"
	rm "$sed_filename"
fi

# manually add dependencies into bundler
gem_filename="Gemfile"

if [[ ${#BUNDLER_DEPS[@]} -gt 0 ]]; then
	echo "> Manually injecting dependencies into Bundler..."
	touch "$gem_filename"
	
	echo -e 'source "https://rubygems.org"\n' >> "$gem_filename"
	echo "gem 'jekyll', '$VERSION'" >> "$gem_filename"
	for dep in "${BUNDLER_DEPS[@]}"; do
		echo "gem '$dep'" >> "$gem_filename"
	done
fi

# build with ocra
echo "> Building..."

if [[ ! -f "$gem_filename" ]]; then
	ocra "$jekyll_bin" "$folder_name/**" --console --gem-all > ocra.log 2>&1
else
	ocra "$jekyll_bin" "$folder_name/**" --gemfile "$gem_filename" --console --gem-all > ocra.log 2>&1
fi

sed -i -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" ocra.log

# clean up gem unpack folder
echo "> Cleaning up..."
rm -rf "$folder_name" "$gem_filename" "$gem_filename.lock"

# release log generation
echo "> Generating \"release.log\"..."
operating_system=$(wmic os get caption | grep "Windows" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
ruby_version=$(ruby -v)
gem_version=$(gem -v)
md5_hash=$(md5sum ./jekyll.exe | cut -d ' ' -f 1)
sha1_hash=$(sha1sum ./jekyll.exe | cut -d ' ' -f 1)

cat > release.log << EOL
Build information:
- $operating_system
- $ruby_version
- RubyGems $gem_version
- Parameters:
    - \`VERSION\`: \`$1\`
    - \`INJECT_DEPS\`: \`$2\`
    - \`BUNDLER_DEPS\`: \`$3\`

Checksum information (for \`jekyll.exe\` only):
- MD5: $md5_hash
- SHA1: $sha1_hash
EOL

echo "> Done. Check \"ocra.log\" for build details."
