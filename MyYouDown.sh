#!/bin/bash
DD=$(date +"%m-%Y")
ODIR=$DD"/%(title)s.%(ext)s" 
name=$0


function usage(){
	printf "usage: $name [options] URL(URL or txt with URLs)"
	printf "options: \n"
	printf "\t-q|--quiet            : Mode silencieux. Attention a mettre en 1er. \n"
	printf "\t-u|--url              : Telecharge une (1 url) ou plusieurs (fichier) musiques via URLs.\n"
	printf "\t-s|--search           : Fait une recherche youtube de l'entree. \n"
	printf "\t-i|--install          : affiche les instructions d'installation. \n"
	printf "\t-h|--help             : affiche ce message.\n"
}


function install(){
	printf "#############INSTALLATION############## \n"
	printf "sudo apt udpate \n"
	printf "sudo apt udgrade \n"
	printf "AND \n"
	printf "sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl \n"
	printf "sudo chmod a+rx /usr/local/bin/youtube-dl \n"
	printf "OR \n"
	printf "sudo apt install youtube-dl \n \n"
	printf "Attention il faut aussi ffmpeg:\n"
	printf "sudo apt install ffmpeg \n \n"
	printf "Pour l'intergrer dans mes commandes linux: (on peut aussi le renomer)\n"
	printf "cp $name /usr/bin/  \n"
	printf "chmod 770 $name  \n"
}

function url_down(){
	if [[ $1 -eq 1 ]]; then
		if [[ -f $IN_URL ]]; then
			youtube-dl --quiet --extract-audio --embed-thumbnail --add-metadata --audio-format mp3 --audio-quality 0 --output $ODIR --batch-file="$IN_URL"
		else
			youtube-dl --quiet --extract-audio --embed-thumbnail --add-metadata --audio-format mp3 --audio-quality 0 --output $ODIR "$IN_URL"
		fi
	else
		if [[ -f $IN_URL ]]; then
			youtube-dl --extract-audio --embed-thumbnail --add-metadata --audio-format mp3 --audio-quality 0 --output $ODIR --batch-file="$IN_URL"
		else
			youtube-dl --extract-audio --embed-thumbnail --add-metadata --audio-format mp3 --audio-quality 0 --output $ODIR "$IN_URL"
		fi
	fi
}

function search_down(){
	if [[ $1 -eq 1 ]]; then
		if [[ -f $IN_URL ]]; then
			while IFS='' read -r line || [[ -n "$line" ]] && [[ ! -z "$line" ]]; do
				youtube-dl --quiet --extract-audio --embed-thumbnail --add-metadata --audio-format mp3 --audio-quality 0 --output $ODIR "ytsearch:$line"
			done < "$IN_URL"
		else
			youtube-dl --quiet --extract-audio --embed-thumbnail --add-metadata --audio-format mp3 --audio-quality 0 --output $ODIR "ytsearch:$IN_URL"
		fi
	else
		if [[ -f $IN_URL ]]; then
			while IFS='' read -r line || [[ -n "$line" ]] && [[ ! -z "$line" ]]; do
				youtube-dl --extract-audio --embed-thumbnail --add-metadata --audio-format mp3 --audio-quality 0 --output $ODIR "ytsearch:$line"
			done < "$IN_URL"
		else
			youtube-dl --extract-audio --embed-thumbnail --add-metadata --audio-format mp3 --audio-quality 0 --output $ODIR "ytsearch:$IN_URL"
		fi
	fi

}


function test(){
	if [[ ! -f $IN_URL ]]; then
	echo $IN_URL
	fi
}

if [[ $# -eq 0 ]]; then
	usage
fi


q=0
while [[ $# -gt 0 ]]; do
	key="$1"
	case $key in
		-q|--quiet)
		q=1
		shift # past argument
		;;
	    -s|--search)
	    IN_URL="$2"
	    search_down $q
	    shift # past argument
	    shift # past value
	    ;;
	    -u|--url)
		IN_URL="$2"	 
		url_down $q
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