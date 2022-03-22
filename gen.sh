#!/bin/sh

OUTPUT=~/.local/share/applications

# use polymc if installed
PROGRAM=polymc
folder=~/.local/share/polymc/instances
if ! type "$PROGRAM" &> /dev/null; then
    PROGRAM=multimc
    folder=~/.local/share/multimc/instances
fi

# if argument is present use it as the path
if [[ "$1" ]]; then
    folder=$1
fi

#generate the entries
for file in $folder/*; do
    if [[ -d $file ]]; then
        name="${file##*/}"
        if [[ $name != _* ]]; then
            entry="[Desktop Entry]\nType=Application\nName=$name\nExec=$PROGRAM -l \"$name\"\nIcon=minecraft-launcher\nTerminal=false"
            path="$OUTPUT/$name.desktop"
            if [ ! -d "$path" ]; then
                # create it if not already present and fill it out
                printf "$entry\n" > $path
           fi
        fi
    fi
done
