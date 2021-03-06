#!/bin/bash
DD=$(date +"%m-%Y")
ODIR=$DD"/%(title)s.%(ext)s"
name=$0

# set -x
set -e


function usage(){
	printf "usage: $name [options] URL(URL or txt with URLs)"
	printf "options: \n"
	printf "\t-q|--quiet                                       : Mode silencieux. Attention a mettre en 1er. \n"
	printf "\t-u|--url url|fichier                             : Telecharge une (1 url) ou plusieurs (fichier) musiques via URLs.\n"
	printf "\t-s|--search title|fichier                        : Fait une recherche youtube de l'entree. \n"
	printf "\t-c|--couper val_debut(s) val_duration(s) fichier : Permet de couper la video entre debut et duration. \n"
	printf "\t-v|--video url|fichier                           : Telecharger la video. \n	"
	printf "\t-i|--install                                     : affiche les instructions d'installation. \n"
	printf "\t-h|--help                                        : affiche ce message.\n"
}


function install(){
	printf "#############INSTALLATION############## \n"
	printf "sudo apt udpate \n"
	printf "sudo apt udgrade \n"
	printf "AND \n"
	printf "sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl \n"
	printf "    OR \n"
	printf "sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl \n"
	printf "sudo chmod a+rx /usr/local/bin/youtube-dl \n"
	printf "OR \n"
	printf "sudo apt install youtube-dl \n \n"
	printf "Attention il faut aussi ffmpeg:\n"
	printf "sudo apt install ffmpeg \n \n"
	printf "Pour l'intergrer dans mes commandes linux: (on peut aussi le renomer)\n"
	printf "sudo cp $name /usr/bin/  \n"
	printf "sudo chmod 777 $name  \n"
	printf "\n"
	printf "if not working do sudo apt autoremove youtube-dl and do it again with curl or wget\n"
	printf "To update: sudo youtube-dl -U\n"
}

function url_down(){
	if [[ $1 -eq 1 ]]; then
		if [[ -f $IN_URL ]]; then
			youtube-dl --quiet --restrict-filenames --extract-audio --embed-thumbnail --add-metadata --audio-format mp3 --audio-quality 0 --output $ODIR --batch-file="$IN_URL" || echo "$line : File not downloaded ! " >> errorfile
		else
			youtube-dl --quiet --restrict-filenames --extract-audio --embed-thumbnail --add-metadata --audio-format mp3 --audio-quality 0 --output $ODIR "$IN_URL" || echo "$line : File not downloaded ! " >> errorfile
		fi
	else
		if [[ -f $IN_URL ]]; then
			youtube-dl --extract-audio --restrict-filenames --embed-thumbnail --add-metadata --audio-format mp3 --audio-quality 0 --output $ODIR --batch-file="$IN_URL" || echo "$line : File not downloaded ! " >> errorfile
		else
			youtube-dl --extract-audio --restrict-filenames --embed-thumbnail --add-metadata --audio-format mp3 --audio-quality 0 --output $ODIR "$IN_URL" || echo "$line : File not downloaded ! " >> errorfile
		fi
	fi
}

function search_down(){
	if [[ $1 -eq 1 ]]; then
		if [[ -f $IN_URL ]]; then
			while IFS='' read -r line || [[ -n "$line" ]] && [[ ! -z "$line" ]]; do
				echo $line
				# youtube-dl --quiet --restrict-filenames --extract-audio --embed-thumbnail --add-metadata --audio-format mp3 --audio-quality 0 --output $ODIR "ytsearch:$line"
			done < "$IN_URL"
		else
			youtube-dl --quiet --restrict-filenames --extract-audio --embed-thumbnail --add-metadata --audio-format mp3 --audio-quality 0 --output $ODIR "ytsearch:$IN_URL" || echo "$line : File not downloaded ! " >> errorfile
		fi
	else
		if [[ -f $IN_URL ]]; then
			while IFS='' read -r line || [[ -n "$line" ]] && [[ ! -z "$line" ]]; do
				youtube-dl -s ytsearch:"$line" --get-duration --get-title --get-url --get-filename || echo "$line : File not downloaded ! " >> errorfile
				echo -ne "\n-----\n"
				# youtube-dl --extract-audio --restrict-filenames --embed-thumbnail --add-metadata --audio-format mp3 --audio-quality 0 --output $ODIR "ytsearch:$line"
			done < "$IN_URL"
		else
			youtube-dl --extract-audio --restrict-filenames --embed-thumbnail --add-metadata --audio-format mp3 --audio-quality 0 --output $ODIR "ytsearch:$IN_URL" || echo "$line : File not downloaded ! " >> errorfile
		fi
	fi
}


function test(){
	if [[ -f $1 ]]; then
		echo $1
	else
		echo non
	fi
}

function couper(){
	if [[ $4 -eq 0 ]]; then
		if [[ $2 -gt 1 ]] && [[ -f "$3" ]]; then
		debut=$1
		duration=$2
		file="$3"
		file_out=$(echo $file | cut -f1 -d.)
		ext=$(echo $file | cut -f2 -d.)
		file_out="$file_out""_cut.$ext"
		ffmpeg -ss $debut -t $duration -i "$file" "$file_out" -y
		#-ss debut -t duree -i inuput ouput -y(pour overwrite)
		printf "$file_out created\n"
		else
			usage
			exit
		fi
	else
		if [[ $(($2-$1)) -gt 0 ]] && [[ -f "$3" ]]; then
		debut=$1
		duration=$2
		file="$3"
		file_out=$(echo $file | cut -f1 -d.)
		ext=$(echo $file | cut -f2 -d.)
		file_out="$file_out""_cut.$ext"
		ffmpeg -loglevel quiet -ss $debut -t $duration -i "$file" "$file_out" -y
		#-ss debut -t duree -i inuput ouput -y(pour overwrite)
		printf "$file_out created\n"
		else
			usage
			exit
		fi
	fi
}

video_down(){
	if [[ -f $IN_URL ]]; then
		echo "Ne fonctionne pas avec un fichier pour l'instant."
	else
		youtube-dl -F "$IN_URL"

		echo "Choisir le format:"
		read input
		youtube-dl -f "$input" --output $ODIR "$IN_URL"
	fi
}

if [[ $# -lt 2 ]]; then
	usage
	exit 0
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
		echo "searchdown"
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
    -c|--couper)
    shift # past value
    if [[ -z $1  ]] || [[ -z $2  ]] || [[ -z "$3" ]]; then
    	usage
    	exit
    fi
    couper "$1" "$2" "$3" $q
    shift # past argument
    shift # past value
    shift
		exit
		;;
		-v|--video)
		IN_URL="$2"
		video_down
		shift
		shift
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

#
# $ youtube-dl --get-filename -o '%(title)s.%(ext)s' BaW_jenozKc --restrict-filenames
# youtube-dl_test_video_.mp4          # A simple file name
#
# # Download YouTube playlist videos in separate directory indexed by video order in a playlist
# $ youtube-dl -o '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' https://www.youtube.com/playlist?list=PLwiyx1dc3P2JR9N8gQaQN_BCvlSlap7re
