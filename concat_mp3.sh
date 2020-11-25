#!/bin/bash

if [ -e ".concat" ]; then exit; fi
find . -type f -size 0 -delete

for i in *
do
  # skip if not a directory
  if [ ! -d "$i" ]; then continue; fi

  # check if file exists
  if [ -e "$i.mp3" ]; then
    A=`du -sh "$i" | awk '{print $1}' | sed 's/[BKMG]//g' | awk '{print int($1)}'` # folder size, integer
    B=`du -sh "$i.mp3" | awk '{print $1}' | sed 's/[BKMG]//g' | awk '{print int($1)+10}'` # file size, integer + 10
    if [ "$B" -gt "$A" ]; then
      echo $i 🐱
      continue
    else
      echo "Deleting $i ..."
      sleep 5
      rm -f "$i.mp3"      
    fi
  fi

  # dive into the album
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
    B=`du -sh "$i.mp3" | awk '{print $1}' | sed 's/[BKMG]//g' | awk '{print int($1)+10}'` # file size, integer + 10
    echo "Sizes: $A $B"
    sleep 3
    if [ "$B" -gt "$A" ]; then
      echo $i 🐱
      sleep 1
      continue
    else
      echo "Deleting $i ..."
      sleep 5
      rm -f "$i.mp3"      
    fi
  fi
done

find . -type f -size 0 -delete
touch .concat
