#!/bin/sh

latexclean() {
    for texfile in *.tex; do
        basename=$(echo "$texfile" | sed 's/\.tex$//')

        for ext in aux bbl bcf fdb_latexmk fls log out run.xml synctex.gz; do
            if [ -f "${basename}.${ext}" ]; then
                echo "Removing ${basename}.${ext}"
                rm "${basename}.${ext}"
            fi
        done
    done
}

if [ "$0" = "$BASH_SOURCE" ] || [ -z "$BASH_SOURCE" ]; then
    latexclean
fi

