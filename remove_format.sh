function remove_format {
    cat $1 | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | sed 's/\x1b\[[0-9;]*m//g'
}

# example
echo -e "\e[93mLight yellow"
echo -e "\e[93mLight yellow" | remove_format
