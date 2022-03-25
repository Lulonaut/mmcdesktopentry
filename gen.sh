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

existing_files=()
# check for already existing entries to delete unused ones later
for entry in $OUTPUT/*.desktop; do
    contents=$(<$entry)
    if [[ $contents == *"$PROGRAM -l"* ]]; then
        name="${entry##*/}"
        name="${name%%.desktop}"
        existing_files+=("$name")
    fi
done

instance_files=()
# generate the entries
for file in $folder/*; do
    if [[ -d $file ]]; then
        name="${file##*/}"
        if [[ $name != _* ]]; then
            instance_files+=("$name")
            entry="[Desktop Entry]\nType=Application\nName=$name\nExec=$PROGRAM -l \"$name\"\nIcon=minecraft-launcher\nTerminal=false"
            path="$OUTPUT/$name.desktop"
            if [ ! -d "$path" ]; then
                # create it if not already present and fill it out
                printf "$entry\n" > $path
           fi
        fi
    fi
done

while IFS= read -r line; do
    rm -f "$OUTPUT/$line.desktop"
done <<< $(printf '%s\n%s\n' "${existing_files[@]}" "${instance_files[@]}" | sort | uniq -u)
