#!/bin/sh

while :
do
	dow=$(date +%w)
	if [ "$dow" -eq 0 ]
	then
		# Sunday
		# Closed
		sleep 3600
	elif [ "$dow" -eq 6 ]
	then
		# Saturday
		if [ "$(date +%H%M)" -ge "0645" ] && [ "$(date +%H%M)" -le "1315" ]
		# Open
		then
			vcgencmd display_power 1
			if [ ! -f "/var/run/displaycameras.pid" ]
			then
				displaycameras start
			fi
			while [ "$(date +%H%M)" -ge "0645" ] && [ "$(date +%H%M)" -le "1315" ]
			do
				displaycameras repair
				sleep 60
			done
		elif [ "$(date +%H%M)" -le "0645" ] || [ "$(date +%H%M)" -ge "1315" ]
		# Closed
		then
			if [ -f "/var/run/displaycameras.pid" ]
			then
				displaycameras stop
			fi
			vcgencmd display_power 0
			while [ "$(date +%H%M)" -le "0645" ] || [ "$(date +%H%M)" -ge "1315" ]
			do
				sleep 60
			done
		fi
	else
		# Weekday
		if [ "$(date +%H%M)" -ge "0645" ] && [ "$(date +%H%M)" -le "1715" ]
		# Open
		then
			vcgencmd display_power 1
			if [ ! -f "/var/run/displaycameras.pid" ]
			then
				displaycameras start
			fi
			while [ "$(date +%H%M)" -ge "0645" ] && [ "$(date +%H%M)" -le "1715" ]
			do
				displaycameras repair
				sleep 60
			done
		elif [ "$(date +%H%M)" -le "0645" ] || [ "$(date +%H%M)" -ge "1715" ]
		# Closed
		then
			if [ -f "/var/run/displaycameras.pid" ]
			then
				displaycameras stop
			fi
			vcgencmd display_power 0
			while [ "$(date +%H%M)" -le "0645" ] || [ "$(date +%H%M)" -ge "1715" ]
			do
				sleep 60
			done
		fi
	fi
done
