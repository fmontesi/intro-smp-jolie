#!/bin/sh

HTTPCMD="http -b"

next() {
	echo -n "Next command: $1"
	read
	$1
}

# Create a few users
next "$HTTPCMD post localhost:8080/user/alice username=alice name='Alice Apple' email='alice@jolie-lang.org' karma=4"
next "$HTTPCMD post localhost:8080/user/bob username=bob name='Bob Banana' email='bob@jolie-lang.org' karma=6"
next "$HTTPCMD post localhost:8080/user/carol username=carol name='Carol Cantaloupe' email='carol@jolie-lang.org' karma=3"

# Get carol
next "$HTTPCMD get localhost:8080/user/carol"

# List 
next "$HTTPCMD get localhost:8080/user?minKarma=4"