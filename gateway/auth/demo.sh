#!/bin/sh

HTTPCMD="http -b"

next() {
	echo -n "Next command: $1"
	read _
	eval $1
}

# Create david (unauthorized)
next "$HTTPCMD post localhost:8080/user/david name='David Date' email='david@jolie-lang.org' karma=5"

# Create david (authorized)
next "$HTTPCMD post localhost:8080/user/david 'Authorization:Bearer 123' username=david name='David Date' email='david@jolie-lang.org' karma=5"

# Get david
next "$HTTPCMD get localhost:8080/user/david"

# Greet david
next "$HTTPCMD get localhost:8080/greeting/david"
