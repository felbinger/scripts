#!/bin/bash

# extract songs from xspf (vlc media player) playlist

xspf_file=${1}

urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }
parse() { local IFS=\> ; read -d \< TAG VALUE; }

# parse each line in the the m3u file
while parse; do
  # check if the tag is location, this indicates that there is a path behind
  if [[ ${TAG} == "location" ]]; then
    # get the value of the location tag and decode it
    song=$(urldecode ${VALUE})
    # remove file://
    song=${song#"file://"}
    echo ${song}
  fi
done < $xspf_file
