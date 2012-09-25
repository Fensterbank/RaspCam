#!/bin/bash
outputfile="/home/raspberry/lastframe.jpg"

while [ true ]
do
	filename="/home/raspberry/videos/"$(cat /home/raspberry/tograb.dat)
	command="ffprobe -loglevel quiet -show_streams ${filename}"
	duration=$($command  | grep "duration=" | sed -e 's/duration=//g')
	duration=${duration%.*}
	echo "duration=${duration}"
	ffmpeg -ss ${duration} -i ${filename} -vf select="eq(pict_type\,I)" -vframes 1 ${outputfile}
	sleep 1
done

