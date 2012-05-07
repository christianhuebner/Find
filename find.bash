#!/bin/bash

function recurse {
	cd $1
	local files=`ls -a`
	for i in $files; do
		if [[ $i == "." || $i == ".." ]]; then continue; fi
		fls=$(stat -c%s $i)
		let filesize+=$fls
		let numfiles+=1;
		if [[ -L $i ]]; then
			let links+=1
			continue
		fi
		if [[ -d $i ]]; then 
			let dirs+=1
			recurse $i
			cd ..
		fi
		if [[ -f $i ]]; then
			let fnum++;
		fi
	done
}

if [[ $# = 0 ]]; then
	echo "Usage: $0 <filename>"
	exit 1
fi

let numfiles+=1;
filesize=$(stat -c%s .)
recurse $1

echo "find.bash: $1: size $filesize total items $numfiles dirs $dirs files $fnum links $links"

