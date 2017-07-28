#!/usr/bin/env bash

# A bunch of shell lines I frecuently use to optimize images for web.
#
# Requisites:
#  + convert: Imagemagick
#  + jpegoptim: To compress and optimize JPEGs
#  + optipng: To optimize PNGs
#
# Installation (Ubuntu/Debian):
#  sudo apt-get install imagemagick jpegoptim optipng -y

folder="$1"

# Check syntax
if [ "$folder" = "" ]; then
	echo "That's not the way to execute the script you must use:"
	echo "$0 FOLDER_TO_PROCESS"
	exit 1
fi

echo "Let's do this!"

# Check requisites
pkgRequisites="imagemagick jpegoptim optipng"
justUpdated=false

echo "Checking requisites..."
for pkg in $pkgRequisites; do
    if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" >/dev/null; then
        echo "  [OK] $pkg is already installed"
    else
	
		if [[ $EUID -ne 0 ]]; then
			echo "Some requisites are not installed. :-("
			echo "To install them you must run this script as superuser (root/sudo) or install them manually (sudo apt-get install imagemagick jpegoptim optipng)"
			echo "Aborted -_-!"
			exit 1
		fi
		
		echo "  [KO] $pkg is not installed, trying to install..."
		if [ $justUpdated = false ]; then
			echo "    ... updating sources..."
			apt-get -qq update -y
			justUpdated=true
		fi
		echo "    ... installing $pkg..."
		if apt-get -qqq install $pkg; then
			echo "    ... $pkg successfully installed! :-)"
		else
			echo "    ... ERROR installing $pkg :-("
			echo "Aborted -_-!"
			exit 1
		fi
    fi
done

# Resize images bigger than 3Mpx (2048x1536)
echo "Resizing images..."
find $folder -type f -iregex ".*\.\(jpg\|jpeg\|png\|gif\)" -exec convert {} -resize '2048x1536>' -quiet {} \; 2> /dev/null

#Optimize jpeg images to 60% compression (Photoshop "High Quality")
echo "Optimizing JPEGs..."
find $folder -type f -iregex ".*\.\(jpg\|jpeg\)" -exec jpegoptim --strip-all --max=60 --force --quiet {} \; 2> /dev/null

#Optimize PNG images (-o1 > 48 trials of optimization, decrease for faster optimization)
echo "Optimizing PNGs..."
find $folder -type f -name "*.png" -exec optipng -o1 -force -quiet {} \; 2> /dev/null
