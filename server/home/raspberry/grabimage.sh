#!/bin/bash
outputfile="/var/www/webcam/lastframe.png"

while [ true ]
do
	filename="/home/raspberry/"$(cat /home/raspberry/tograb.dat)
	command="ffprobe -loglevel quiet -show_streams ${filename}"
	duration=$($command  | grep "duration=" | sed -e 's/duration=//g')

	duration=${duration%.*}
	framecount=$[duration*30]
	lastframe=$[framecount-1]

	ffmpeg -loglevel quiet -i ${filename} -vf "select='eq(n,$lastframe)'" -vframes 1 ${outputfile}
	sleep 1
done

