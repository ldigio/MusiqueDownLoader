#!/bin/bash
DD=$(date +"%m-%Y")
ODIR=$DD"/%(title)s.%(ext)s" 
$IN_URL=$1


function usage(){
	printf "usage: ./MyYouDown [options] URL(URL or txt with URLs)"
	printf "options: \n"
	printf "\t-u|--url              : Telecharge une (1 url) ou plusieurs (fichier) musiques via URLs.;\n"
	printf "\t-s|--search           : Fait une recherche youtube de l'entree. ;\n"
	printf "\t-h|--help             : affiche ce message.\n"
	printf "\t-i|--install          : affiche les instructions d'installation"
}

function install(){
	printf "#############INSTALLATION############## \n"
	printf "sudo apt udpate \n"
	printf "sudo apt udgrade \n"
	printf "AND \n"
	printf "sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl \n"
	printf "sudo chmod a+rx /usr/local/bin/youtube-dl \n"
	printf "OR \n"
	printf "sudo apt install youtube-dl \n"
}

function url_down(){
	if [[ -f $IN_URL ]]; then
		youtube-dl --extract-audio --embed-thumbnail --add-metadata --audio-format mp3 --audio-quality 0 --output $ODIR --batch-file=$IN_URL
	else
		youtube-dl --extract-audio --embed-thumbnail --add-metadata --audio-format mp3 --audio-quality 0 --output $ODIR $IN_URL
	fi
}

search_down(){
	if [[ -f $IN_URL ]]; then
		while IFS='' read -r line || [[ -n "$line" ]] && [[ ! -z "$line" ]]; do
			youtube-dl --extract-audio --embed-thumbnail --add-metadata --audio-format mp3 --audio-quality 0 --output $ODIR "ytsearch:$line"
		done < $IN_URL
	else
		youtube-dl --extract-audio --embed-thumbnail --add-metadata --audio-format mp3 --audio-quality 0 --output $ODIR "ytsearch:"$IN_URL
	fi
}

while [[ $# -gt 0 ]]; do
	key="$1"

	case $key in
	    -s|--search)
	    IN_URL="$2"
	    search_down
	    shift # past argument
	    shift # past value
	    ;;
	    -u|--url)
		IN_URL="$2"	 
		url_down 
		shift # past argument
	    shift # past value
	    ;;
	    -h|--help)
	    usage
	    exit
	    ;;
	    -i|--install)
	    install
	    exit
	    ;;
	    *)    # unknown option
	    usage
	    exit
	    ;;
	esac
done

exit 0