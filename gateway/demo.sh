#!/bin/sh

HTTPCMD="http -b"

next() {
	echo -n "Next command: $1"
	read
	$1
}

# Get carol
next "$HTTPCMD get localhost:8080/user/carol"

# List 
next "$HTTPCMD get localhost:8080/user?minKarma=4"

# Greetings
next "$HTTPCMD get localhost:8080/greeting/alice"
next "$HTTPCMD get localhost:8080/greeting/bob"
next "$HTTPCMD get localhost:8080/greeting/carol"
next "$HTTPCMD get localhost:8080/greeting/david"