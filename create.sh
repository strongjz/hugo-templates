#!/usr/bin/env bash

# Creates Hugo Presentation skeleton structure
# https://github.com/dzello/reveal-hugo
#

CODE_DIR="$HOME/Documents/code/"
PDF='false'
CREATE='false'

create() {

    cd ${CODE_DIR} || echo "Code directory: ${CODE_DIR} does not exist" && exit 1

    hugo new site ${NAME_PRESENTATION}

    cd ${PRESENTATION} || exit 1

    git init

    git submodule add git@github.com:dzello/reveal-hugo.git themes/reveal-hugo

    echo "theme = \"reveal-hugo\"
    [outputFormats.Reveal]
    baseName = \"index\"
    mediaType = \"text/html\"
    isHTML = true" >  config.toml

    echo "+++
    title = \"${NAME_PRESENTATION}\"
    outputs = [\"Reveal\"]
    +++

    # Hello world!

    This is my first slide." > content/_index.md

    hugo_makefile

    make serve
}

hugo_makefile() {
    echo "Downloading Hugo Makefile"

    curl -X GET -skL -o Makefile https://gist.githubusercontent.com/strongjz/d703c05a0a79823ecf8b77529dbbf7b7/raw/d51964e81aac77baf5c1155fcbafc775e48eeafa/Makefile

}

install_decktape() {

    echo "Installing Decktape"

    npm install -g decktape
}

# Creates the reveal presentation as a PDF
pdf() {

echo "Generating PDF"

if [[ -e Makefile ]]; then
    hugo_makefile
fi

make serve &

decktape reveal http://localhost:1313/${NAME_PRESENTATION} ${NAME_PRESENTATION}.pdf

}

usage() {

    echo "Usage: ./create.sh -c -n NAME_PRESENTATION -d CODE_DIR

    -n - Name of the presentation you want to create

    -d - Directory to store it, defaults to $HOME/Documents/code/, this will place -p there

    -c - Create new presentation

    -p - Generate PDF of presentation" 1>&2;

    exit 1;
}

while getopts ":h:n:d:c:p" o; do
    case "${o}" in
        n)
            NAME_PRESENTATION=${OPTARG}
            ;;
        d)
            CODE_DIR=${OPTARG}
            ;;
        p)
            PDF='true'
            ;;
        c)
            CREATE='true'
            ;;
        *)
            usage
            ;;
        '?')
            usage
            ;;
        ':')
            usage
            ;;
        h)
            usage
            ;;
    esac
done

if [[ $OPTIND -eq 1 ]]; then
    echo "No options were passed"
    usage
fi

shift $((OPTIND-1))

if [[ -z "${NAME_PRESENTATION}" ]]; then
    echo "Presentation name not defined"
    usage
fi

if ${CREATE}; then
    echo "Creating NAME_PRESENTATION: ${NAME_PRESENTATION}"
    create
fi

if ${PDF}; then
    echo "Generating PDF for ${NAME_PRESENTATION}"
    pdf
fi

echo "Issue starting"
usage





