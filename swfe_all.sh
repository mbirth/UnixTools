#!/bin/sh
# found on: http://www.mail-archive.com/swftools-common@nongnu.org/msg02159.html
for i in ./*.swf ; do
   for j in `swfextract $i | grep -E PNGs.* -o | grep -E [0-9]+ -o` ; do
       echo "$i -> extract png $j";
       swfextract -p "$j" "$i" -o "$i"_"$j".png
   done
   for j in `swfextract $i | grep -E JPEGs.* -o | grep -E [0-9]+ -o` ; do
       echo "$i -> extract jpeg $j";
       swfextract -j "$j" "$i" -o "$i"_"$j".jpg
   done
   for j in `swfextract $i | grep -E Shapes.* -o | grep -E [0-9]+ -o` ; do
       echo "$i -> extract shapes $j";
       swfextract -i "$j" "$i" -o "$i"_"$j".swf
   done
for j in `swfextract $i | grep -E MovieClips.* -o | grep -E [0-9]+ -o` ; do
       echo "$i -> extract movieclips $j";
       swfextract -i "$j" "$i" -o "$i"_"$j".swf
   done
done
