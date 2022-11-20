#!/bin/sh

HTTPCMD="http -b"

next() {
	echo -n "Next command: $1"
	read _
	eval $1
}

# Get carol
next "$HTTPCMD get localhost:8080/user/carol"

# List 
next "$HTTPCMD get localhost:8080/user?minKarma=4"