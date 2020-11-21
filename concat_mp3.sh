#!/bin/bash

for i in *
do
  if [ ! -d "$i" ]; then continue; fi # not a directory
  if [ -f "$i.mp3" ]; then # file exists
    A=`du -sh "$i" | awk '{print $1}' | sed 's/[BKMG]//g' | awk '{print int($1)}'` # folder size, integer
    B=`du -sh "$i.mp3" | awk '{print $1}' | sed 's/[BKMG]//g' | awk '{print int($1)}'` # file size, integer
    if [ "$A" -gt "$B" ]; then
      continue
    else
      if [ "$A" -eq "$B" ]; then
        continue
      fi
      rm "$i.mp3" # MP3 file is smaller than folder size
    fi
  fi
  cd "$i"
  FILES=`ls *.mp3 2>/dev/null`
  if [ -z "$FILES" ]; then echo "No MP3s!"; cd ..; continue; fi
  echo -en "\nProcessing: $i\n\n"
  ls *.mp3 | sed -e "s/\(.*\)/file '\1'/" | ffmpeg -protocol_whitelist 'file,pipe' -f concat -safe 0 -i - -c copy "../$i.mp3"
  cd ..
done
