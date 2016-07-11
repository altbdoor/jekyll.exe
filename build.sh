#!/bin/bash

# this script builds jekyll into a single exe file. specify the version, and it
# *should* handle the rest. to add other dependency, list it in the
# "dependencies" array below, where it will be injected directly into the
# /bin/jekyll file.

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
cd "$CURRENT_DIR"

declare -a dependencies=(
	'jekyll-watch'
	'rouge'
	'webrick'
)

# ========================================

VERSION="$1"

# simple check version
if [[ -z "$VERSION" ]]; then
	echo "> Please specify the version to build. E.g. \"./build.sh 2.5.3\""
	echo "> For a list of versions, use 'gem list \"^jekyll$\" -ra'"
	exit 1
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

# manually add dependencies into jekyll
echo "> Manually adding dependency..."
sed_filename="temp.sed"
echo -n "" > "$sed_filename"

for dep in "${dependencies[@]}"; do
	echo "require '$dep'" >> "$sed_filename"
done

sed -i "/require 'jekyll'/r $sed_filename" "$folder_name/bin/jekyll"
rm "$sed_filename"

# build with ocra
echo "> Building..."
ocra "$folder_name/bin/jekyll" "$folder_name/**" --console --gem-all > ocra.log 2>&1
sed -i -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" ocra.log

# clean up gem unpack folder
echo "> Cleaning up..."
rm -rf "$folder_name"

# release log generation
echo "> Generating \"release.log\"..."
operating_system=$(wmic os get caption | grep "Windows")
ruby_version=$(ruby -v)
gem_version=$(gem -v)

cat > release.log << EOL
Known issues:
- None

---

Subcommands:
- [ ] docs
- [ ] import
- [x] build, b
- [x] clean
- [x] doctor, hyde
- [x] help
- [x] new
- [x] serve, server, s

---

Build environment:
- $operating_system
- $ruby_version
- RubyGems $gem_version
EOL

echo "> Done. Check \"ocra.log\" for build details."
