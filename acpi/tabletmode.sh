#/bin/sh
# ref: https://discuss.getsol.us/d/690-onboard-detecting-tablet-mode/2
# expects the acpi event to be passed in as arg from /etc/acpi/events/tabletmode
# video/tabletmode TBLT 0000008A 00000001

# 4th params gives tablet status
# 00000001 entering tablet mode
# 00000000 exiting tablet mode
tablet_mode=$4
tablet_mode_on="00000001"
tablet_mode_off="00000000"


display=$(ls /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)
user=$(who | awk "/$display/"'{ print $1}')

if [ "$tablet_mode" = "$tablet_mode_on" ]; then
	# Starts the "onboard" app in the background (&)
	sudo -iu $user /usr/bin/onboard &
elif [ "$tablet_mode" = "$tablet_mode_off" ]; then
	# Finds "onboard" process and kills it
	pid=$(ps ax | awk '/usr\/bin\/onboard/ { print $1 }') && kill $pid
fi
