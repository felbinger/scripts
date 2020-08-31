#!/bin/bash

pw_lenght=20
pw_count=1
pw_keyset="A-NP-Za-km-z0-9%+_~*.:,"

while getopts ":l:c:k:" opt; do
  case $opt in
    l)
      pw_lenght=${OPTARG}
      ;;
    c)
      pw_count=${OPTARG}
      ;;
    k)
      pw_keyset=${OPTARG}
      ;;
    *)
      echo "Usage: $0 [OPTION]..."
      echo "Print a random generated password. With no OPTION, $pw_count password with $pw_lenght characters ($pw_keyset)"
      echo ""
      echo "-l {int}             lenght of the passwords"
      echo "-c {int}             count of the paswords"
      echo "-k {String}          keyset of the password e.g. A-Z0-9"
      exit 1
      ;;
  esac
done

cat /dev/urandom | tr -dc $pw_keyset | fold -w $pw_lenght | head -n $pw_count
exit 0
