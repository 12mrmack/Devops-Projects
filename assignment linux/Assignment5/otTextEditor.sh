#!/bin/bash

operation=$1
file=$2
shift 2

case $operation in 
    addLineTop) 
    line=$1
    sed -i "1i $line" "$file"
    ;;
    addLineBottom)
    line=$1
    echo "$line" >> "$file"
    ;;
    addLineAt)
    lineno=$1
    line=$2
    sed -i "${lineno}i $line" "$file"
    ;;
    updateFirstWord)
    matchword=$1
    newword=$2
    sed -i "0,/$matchword/s|$matchword|$newword|" "$file"
    ;;
    updateAllWords)
    matchword=$1
    newword=$2
    sed -i "s|$matchword|$newword|g" "$file"
    ;;
    insertWord)
    word1=$1
    word2=$2
    insertword=$3
    sed -i "s|$word1 $word2|$word1 $insertword $word2|g" "$file"
    ;;
    deleteLine)
    lineno=$1
    word=$2
    if [ -z "$word" ]; then
        sed -i "${lineno}d" "$file"

    else
        sed -i "/$word/d" "$file"
    fi

    ;;
esac