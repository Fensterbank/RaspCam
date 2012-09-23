#!/bin/bash
onlinefile="/media/sshfs/online"
targetpath="/media/sshfs/"
logfile="/home/pi/webcam.log"
failcounter_sshfs=1

echo "$(date +%Y-%m-%d_%H-%M-%S)  Script gestartet" >> $logfile

while [ true ]
do
	if [ -f $onlinefile ]
	then
		failcounter_sshfs=1
		echo "$(date +%Y-%m-%d_%H-%M-%S)  Raspberry ist online, starte Streaming..." >> $logfile
		filename=$(date +%Y-%m-%d_%H-%M-%S_stream.mpg)
		fullfilename=$targetpath$filename
		echo $filename > ${targetpath}tograb.dat
		ffmpeg -f video4linux2 -s 320x240 -i /dev/video0 $fullfilename
		echo "$(date +%Y-%m-%d_%H-%M-%S)  Streaming beendet." >> $logfile
		cp $logfile ${targetpath}webcam.log
		sleep 1
	else
		echo "$(date +%Y-%m-%d_%H-%M-%S)  Raspberry ist nicht online." >> $logfile
		if [ $failcounter_sshfs -gt 3 ]
		then
			echo "$(date +%Y-%m-%d_%H-%M-%S)  ${failcounter_sshfs}. Fehlversuch: Versuche sshfs erneut zu mounten..." >> $logfile
			umount $targetpath
			sleep 10
			mount -a
			sleep 20
		else
			echo "$(date +%Y-%m-%d_%H-%M-%S)  ${failcounter_sshfs}. Fehlversuch: Warte 20 Sekunden..." >> $logfile
			failcounter_sshfs=$[failcounter_sshfs+1]
			sleep 20
		fi
	fi
done
