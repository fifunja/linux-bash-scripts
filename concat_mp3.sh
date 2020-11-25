#!/bin/bash

find . -type f -size 0 -delete
for i in *
do
  if [ ! -d "$i" ]; then continue; fi # not a directory
  # check if file exists
  if [ -e "$i.mp3" ]; then
    A=`du -sh "$i" | awk '{print $1}' | sed 's/[BKMG]//g' | awk '{print int($1)}'` # folder size, integer
    B=`du -sh "$i.mp3" | awk '{print $1}' | sed 's/[BKMG]//g' | awk '{print int($1)}'` # file size, integer
    if [ "$B" -gt "$A" ]; then
      echo $i 🐱
      continue
    else
      if [ "$A" -eq "$B" ]; then
        echo $i 🐱
        continue
      fi
      echo "Deleting $i ..."
      sleep 5
      rm -f "$i.mp3"      
    fi
  fi
  # dive into ...
  cd "$i"
  FILES=`ls *.mp3 2>/dev/null`
  D=0
  for x in *
  do
    if [ -d "$x" ]; then D=1; continue; fi # there is a directory!
  done
  if [ "$D" -eq "1" ]; then echo "> subfolders present ..."; cd ..; continue; fi # skip the loop if there is a directory inside!
  if [ -z "$FILES" ]; then echo "💀 no MP3s in $i"; cd ..; continue; fi
  # create MP3
  echo -en "\nProcessing: $i\n\n"
  ls *.mp3 | sed -e "s/\(.*\)/file '\1'/" | ffmpeg -protocol_whitelist 'file,pipe' -f concat -safe 0 -i - -c copy "../$i.mp3"
  cd ..
  # check if file exists
  if [ -e "$i.mp3" ]; then
    A=`du -sh "$i" | awk '{print $1}' | sed 's/[BKMG]//g' | awk '{print int($1)}'` # folder size, integer
    B=`du -sh "$i.mp3" | awk '{print $1}' | sed 's/[BKMG]//g' | awk '{print int($1)}'` # file size, integer
    if [ "$B" -gt "$A" ]; then
      echo $i 🐱
      continue
    else
      if [ "$A" -eq "$B" ]; then
        echo $i 🐱
        continue
      fi
      echo "Deleting $i ..."
      sleep 5
      rm -f "$i.mp3"      
    fi
  fi
done
find . -type f -size 0 -delete
