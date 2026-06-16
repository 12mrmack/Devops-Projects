#!/bin/bash

HOUR=$(date +%H)

if [ $HOUR -ge 10 ] && [ $HOUR -lt 12 ]; then
    echo "Hello from Maqbool"
elif [ $HOUR -ge 16 ] && [ $HOUR -lt 18 ]; then
    echo "Hello from Sneha"
else
    echo "Website Closed"
fi
