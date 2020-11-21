#!/bin/bash

for i in *
do
  if [ ! -d "$i" ]; then continue; fi # not a directory
  if [ -f "$i.mp3" ]; then continue; fi # file exists
  cd "$i"
  echo -en "Processing: $i\n\n"
  ls *.mp3 | sed -e "s/\(.*\)/file '\1'/" | ffmpeg -protocol_whitelist 'file,pipe' -f concat -safe 0 -i - -c copy "../$i.mp3"
  cd ..
done
