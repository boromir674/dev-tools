#!/usr/bin/env bash

## recursively find and delete pyc files and __pycache__ folders

directory=$1

# if [ $# -eq 0 ]; then
#     echo "No directory specified"
#     exit 1
# fi

# handle non-option arguments
if [[ $# -ne 1 ]]; then
    echo "$0: A single input directory is required."
    echo "Example usage: clear-pycache.sh ~/example-path"
    exit 4
fi

dirs=$(find $directory -type d -name "__pycache__")

if [[ !  -z  $dirs  ]]; then
    for file in $dirs; do
        echo Dir: $file
    done
    read -p 'Delete __pycache__ dirs? (y/n/): ' answer
    if [ "$answer" == "y" ]; then
        for file in $dirs; do
            rm -rf $file
            if [ $? -eq 0 ]; then
                echo "Deleted folder '$file'"
            fi
        done
    fi
else
    echo "No pychache folders found in '$directory' directory"
fi

echo

pycs=$(find $directory -type f -name "*\.pyc")

if [[ !  -z  $pycs  ]]; then
    for file in $pycs; do
        echo File: $file
    done

    read -p 'Delete pyc files? (y/n/): ' answer
    if [ "$answer" == "y" ]; then
        for file in $pycs; do
            rm $file
            if [ $? -eq 0 ]; then
                echo "Deleted '$file'"
            fi
        done
    fi

else
    echo "No pyc files found in '$directory' directory"
fi
exit 0
