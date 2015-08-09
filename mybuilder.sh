#!/bin/bash

strindex() { 
  x="${1%%$2*}"
  [[ $x = $1 ]] && echo -1 || echo ${#x}
}
KEY="XXXXXXX"
PPA="XXXXXXX"
MAIN_DIR=$PWD
DEBIAN_DIR=$PWD'/debian'
SRCDIR=$PWD'/src'
CHANGELOG=$PWD'/debian/changelog'
PARENDIR="$(dirname "$MAIN_DIR")"
PYCACHEDIR=$SRCDIR'/__pycache__'
if [ -d $PYCACHEDIR ]; then
	echo "Removing cache directory: $PYCACHEDIR"
	rm -rf $PYCACHEDIR
fi
firstline=$(head -n 1 $CHANGELOG)
echo $firstline
pos=`strindex "$firstline" "("`
posf=`strindex "$firstline" ")"`
echo $pos,$posf
app=${firstline:0:$pos-1}
app=${app,,} #lowercase
appname=${app^^} #uppercase
version=${firstline:$pos+1:$posf-$pos-1}
#
echo 'Building debian package...'
debuild -S -sa -k"$KEY"
package="$PARENDIR/$app"_"$version"_source.changes
if [ -f $package ]; then
	echo "Uploading debian package..."
	dput ppa:"$PPA" "$PARENDIR/$app"_"$version"_source.changes
else
	echo "Error: package not build"
fi
rm "$PARENDIR/$app"_"$version"*
