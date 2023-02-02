#!/bin/bash
# This reads in the first file (.tsv) passed as an argument takes only ones containing "Ready"
# Cut then takes the 2,3,5,6,7,8,9th feilds and passes them along
cut -f-3,5-9 "./$1" >> .tmp
echo "" > ./_data/people.yml
while read entry; do
	# For each line it seperates each feild into a value
	READY_STATUS=$(echo "$entry" | cut -f1)
	if [[ $READY_STATUS =~ .*Ready.* ]]; then READY="true"; else READY="false"; fi
	NAME=$(echo "$entry" | cut -f2 | sed -e "s/\(.*\),\(.*\)/\2 \1/g")
	TITLE=$(echo "$entry" | cut -f5)
	if [[ "$TITLE" == "Piece Title" ]]; then 
		PAGETITLE=$(echo "$NAME")
	else 
		# PAGETITLE=$(echo "$NAME - $TITLE")
		PAGETITLE=$(echo "$NAME")
	fi
	YEAR=$(echo "$entry" | cut -f3)
	DESCRIPTION=$(echo "$entry" | cut -f4)
	MEDIUM=$(echo "$entry" | cut -f6)
	DIMENSIONS=$(echo "$entry" | cut -f7)
	DOCUMENT=$(echo $NAME | sed -e "s/[[:space:]]/_/g")
	# Print frontmatter
	printf '$---
layout: artists
name: "'"$TITLE"'"
year: '"$YEAR"'
image: '"$DOCUMENT.JPG"'
title: "'"$PAGETITLE"'"
medium: '"$MEDIUM"'
dimensions: '"$DIMENSIONS"'
ready: '"$READY"'
published: '"$READY"'
---
'"$DESCRIPTION"'
' | sed -e "s/\$---/---/g" > _artists/$DOCUMENT.md 
echo "- title: $PAGETITLE">> ./_data/people.yml	
echo "  year: $YEAR">> ./_data/people.yml	
echo "  ready: $READY">> ./_data/people.yml	
echo "  url: $DOCUMENT.html">> ./_data/people.yml	
	
done <.tmp

rm .tmp
