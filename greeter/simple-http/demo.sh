#!/bin/sh

HTTPCMD="http -b"

next() {
	echo -n "Next command: $1"
	read
	$1
}

next "$HTTPCMD get localhost:8080/greet?name=Alice"
next "$HTTPCMD get localhost:8080/greet?name=Bob"