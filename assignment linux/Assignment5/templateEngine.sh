#!/bin/bash

# T_FILE=$1
# touch "$T_FILE"
# echo "{{fname}} is a trainer of {{topic}}" > $T_FILE

if [ $# -lt 2 ]; then
    echo "Usage: $0 <template-file> key=value key=value ..."
    exit 1
fi

template_file=$1
shift

content=$(cat "$template_file")

for kvp in "$@" 
do 
    key=$(echo "$kvp" | cut -d'=' -f1)
    value=$(echo "$kvp" | cut -d'=' -f2)

    content=$(echo "$content" | sed "s|{{$key}}|$value|g")

done

echo "$content"