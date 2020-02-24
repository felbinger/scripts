#!/bin/bash

# Color Definitions
GRAY="\e[90m"
DEFAULT="\e[39m"

function spin() {
  speed=$1
  n=25
  # Create n gray hashtags
  for i in $(seq 1 $n); do
    echo -ne $GRAY"#"$DEFAULT
  done
  # Create m white hashtags and n-m gray hashtags
  m=1
  for i in $(seq 1 $n); do
    sleep $speed
    # Remove all characters in this line
    for i in $(seq 1 $((n+20))); do
      echo -ne "\b"
    done
    # Create m white hashtags
    for i in $(seq 1 $m); do
      echo -ne "#"
    done
    # Create n-m gray hashtags
    for i in $(seq 1 $((n-m))); do
      echo -ne $GRAY"#"$DEFAULT
    done
    if [[ $m -eq $n ]]; then
      # If you have n hashtags show COMPLETE
      echo -ne "\tCOMPLETE"
    else
      # Show the m/n*100 procent
      echo -ne "\t($(awk -v t1="$n" -v t2="$m" 'BEGIN{printf (t2 / t1 * 100)}')%)"
    fi
    m=$((m+1))
  done
  echo
}

function control_c {
  echo
  echo "You can't stop this!"
  echo
}

function main() {
  clear
  echo "Just a cool animation!"
  spin 0.3
  echo
  exit 0
}

# Capture SIGINT (Ctrl-C) and run the function.
trap control_c SIGINT
main
