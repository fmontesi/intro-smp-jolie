#!/bin/sh

next() {
	echo -n "Next command: $1"
	read _
	$1
}

next "jpm install"
next "jolie setup-db.ol"