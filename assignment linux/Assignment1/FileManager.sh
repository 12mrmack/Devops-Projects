#!/bin/bash

command=$1

case $command in

addDir)
    mkdir -p "$2/$3"
    echo "Directory created: $2/$3"
    ;;

deleteDir)
    rm -rf "$2/$3"
    echo "Directory deleted: $2/$3"
    ;;

listFiles)
    ls -p "$2" | grep -v /
    ;;

listDirs)
    ls -p "$2" | grep /
    ;;

listAll)
    ls "$2"
    ;;

addFile)
    if [ -z "$4" ]; then
        touch "$2/$3"
    else
        echo "$4" > "$2/$3"
    fi
    echo "File created: $2/$3"
    ;;

addContentToFile)
    echo "$4" >> "$2/$3"
    echo "Content appended to $2/$3"
    ;;

addContentToFileBegining)
    tmpfile=$(mktemp)
    echo "$4" > "$tmpfile"
    cat "$2/$3" >> "$tmpfile"
    mv "$tmpfile" "$2/$3"
    echo "Content added at beginning"
    ;;

showFileBeginingContent)
    head -n "$4" "$2/$3"
    ;;

showFileEndContent)
    tail -n "$4" "$2/$3"
    ;;

showFileContentAtLine)
    head -n "$4" "$2/$3" | tail -n 1
    ;;

showFileContentForLineRange)
        head -n "$5" "$2/$3" | tail -n $(($5-$4+1))
    ;;

moveFile)
    mv "$2" "$3"
    echo "File moved"
    ;;

copyFile)
    cp "$2" "$3"
    echo "File copied"
    ;;

clearFileContent)
    cat /dev/null > "$2/$3"
    echo "File content cleared"
    ;;

deleteFile)
    rm -f "$2/$3"
    echo "File deleted"
    ;;

*)
    echo "Invalid command"
    echo "Usage: ./FileManager.sh <command> ..."
    ;;
esac
