#/bin/sh
# ref: https://discuss.getsol.us/d/690-onboard-detecting-tablet-mode/2
# expects 0 or 1 to be passed in as arg from /etc/acpi/events/tabletmode-(on|off)

tablet_mode=$1
tablet_mode_on="1"
tablet_mode_off="0"


display=$(ls /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)
user=$(who | awk "/$display/"'{ print $1}')

if   [ "\${1}" -eq 0 ]; then
	# Starts the "onboard" app in the background (&)
	sudo -iu $user /usr/bin/onboard &
elif [ "\${1}" -eq 1 ];  then
	# Finds "onboard" process and kills it
	pid=$(ps ax | awk '/usr\/bin\/onboard/ { print $1 }') && kill $pid
fi
