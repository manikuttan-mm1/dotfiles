#!/bin/bash

# Prompt user for a search query
query=$(rofi -dmenu -p "Search Google")

# If query is not empty, get suggestions
if [ -n "$query" ]; then
    # Use Google Suggest API to get suggestions (parse with jq)
    suggestions=$(curl -s "http://suggestqueries.google.com/complete/search?output=firefox&q=$query" | jq -r '.[1][]')

    # If there are suggestions, show them in rofi
    if [ -n "$suggestions" ]; then
        query=$(echo "$suggestions" | rofi -dmenu -p "Select Search Term")
    fi

    # Perform the search if a valid query is selected
    if [ -n "$query" ]; then
        xdg-open "https://www.google.com/search?q=$query"
    fi
fi
