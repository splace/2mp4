#!/bin/bash
# Change Container type of video files

if [ "$1" == "-h" ]; then
  echo "Usage: $(basename "$0") [-h][ext][ext cp] 
  
Change Container type of any video files in current directory.   

where:

-h	Show this help text.
ext	Extension to re-containerise too. \(default:mp4\)
cp	Conversion program. \(default:avconv\)

support:

the codec in the source file must be compatible with the target container, and supported by the conversion program. 

"
  exit 0
fi;

EXT=${1-mp4}  # default to mp4 target.
case $1 in
	flv ) MIME="x-flv";;
	wmv ) MIME="x-ms-wmv";;
	avi ) MIME="x-msvideo";;
	mov ) MIME="quicktime";;
	3pg ) MIME="3gpp";;
	* ) MIME=$EXT;;
esac;

CON=${2-avconv}  # default to avconv for conversion.

echo Recontainering to $EXT \(video/$MIME\):

# with all files in current dir;
for filename in *; do
	# select by OS type definition;
	echo -n -e "\t\"$filename\"..."
	case $(mimetype -b "$filename") in
		# if file already in required container, but without extension, add it.
		video/$MIME ) if [[ ! "$filename" =~ .*\.$EXT ]];then if [ ! -f "$filename.$EXT" ];then mv "$filename" "$filename.$EXT";echo -e "\trenamed.";else echo -e "\trename to \"$filename.$EXT\"blocked."; fi;else echo -e "\tnothing to do, Skipping.";fi;;
		# any other video run conversion
		# add extension, erase original, if success was reported.
		# skip, and report, if file with the same stem name already exists.
		# append any error to log.
		video/* ) if [ ! -f "$filename.$EXT" ];then if $CON -loglevel error -i "$filename" -acodec copy -vcodec copy "$filename.$EXT" 2>>"error.log";then echo -e "\tsuccess.";rm "$filename"; fi;else echo -e "\tto \"$filename.$EXT\"blocked.";fi;;
		# not video;
		* ) echo -e "\tSkipping, not recognised as video.($(mimetype -b "$filename"))";;
	esac
done;

# tidy up; remove an empty log file
if [[ -e "error.log" && ! -s "error.log" ]];then rm "error.log";fi;

    
