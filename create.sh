#!/usr/bin/env bash

# Creates Hugo Presentation skeleton structure
# https://github.com/dzello/reveal-hugo
#

CODE_DIR="$HOME/Documents/code/"

create() {

cd ${CODE_DIR} || exit 1

hugo new site ${PRESENTATION}

cd ${PRESENTATION} || exit 1

git init

git submodule add git@github.com:dzello/reveal-hugo.git themes/reveal-hugo

echo "theme = \"reveal-hugo\"
[outputFormats.Reveal]
baseName = \"index\"
mediaType = \"text/html\"
isHTML = true" >  config.toml

echo "+++
title = \"${PRESENTATION}\"
outputs = [\"Reveal\"]
+++

# Hello world!

This is my first slide." > content/_index.md

curl -X GET -skL -o Makefile https://gist.githubusercontent.com/strongjz/d703c05a0a79823ecf8b77529dbbf7b7/raw/d51964e81aac77baf5c1155fcbafc775e48eeafa/Makefile

make serve
}


usage() {

    echo "Usage: ./create.sh -p NAME_PRESENTATION -c CODE_DIR

    -p - Name of the presentation you want to create

    -c - Directory to store it, defaults to $HOME/Documents/code/, this will place -p there " 1>&2;
    exit 1;
}

while getopts ":h:p:c:" o; do
    case "${o}" in
        p)
            PRESENTATION=${OPTARG}
            ;;
        c)
            CODE_DIR=${OPTARG}
            ;;
        *)
            usage
            ;;
        h)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [[ -z "${PRESENTATION}" ]]; then
    usage
fi

create
