#!/bin/bash
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     										machine=linux;;
    Darwin*)    										machine=mac;;
    CYGWIN*|MINGW32*|MSYS*|MINGW*)	machine=win;;
    *)          machine="UNKNOWN:${unameOut}"
esac

create_folder() {
	mkdir -p dist/large
  mkdir -p dist/small
  mkdir -p dist/tiny
}

if [ -d "dist" ]; then
  rm -rf dist
	create_folder
else
	create_folder
fi

src=$(find . -name '*.png' -exec basename {} .png \;)

for file in $src
do
	./libwebp-${machine}/bin/cwebp -quiet -q 90 -resize 152 212 src/${file}.png -o dist/large/${file%.*}.webp
  ./libwebp-${machine}/bin/cwebp -quiet -q 90 -resize 304 424 src/${file}.png -o dist/large/${file%.*}@2x.webp

	./libwebp-${machine}/bin/cwebp -quiet -q 90 -resize 102 142 src/${file}.png -o dist/small/${file%.*}.webp
  ./libwebp-${machine}/bin/cwebp -quiet -q 90 -resize 204 284 src/${file}.png -o dist/small/${file%.*}@2x.webp

	./libwebp-${machine}/bin/cwebp -quiet -q 90 -resize 14 22 src/${file}.png -o dist/tiny/${file%.*}.webp
  ./libwebp-${machine}/bin/cwebp -quiet -q 90 -resize 28 44 src/${file}.png -o dist/tiny/${file%.*}@2x.webp
done

webp=$(find -d './dist' -name '*.webp' -exec basename {} .webp \;)

for file in $webp
do
	./libwebp-${machine}/bin/dwebp -quiet dist/large/${file}.webp -o dist/large/${file%.*}.png
  ./libwebp-${machine}/bin/dwebp -quiet dist/large/${file}.webp -o dist/large/${file%.*}.png

	./libwebp-${machine}/bin/dwebp -quiet dist/small/${file}.webp -o dist/small/${file%.*}.png
  ./libwebp-${machine}/bin/dwebp -quiet dist/small/${file}.webp -o dist/small/${file%.*}.png

	./libwebp-${machine}/bin/dwebp -quiet dist/tiny/${file}.webp -o dist/tiny/${file%.*}.png
  ./libwebp-${machine}/bin/dwebp -quiet dist/tiny/${file}.webp -o dist/tiny/${file%.*}.png
done

echo "Complete"