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

# Not using whoami because that returns root when the script is run by acpi, needs the actual person user instead
display=$(ls /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)
user=$(who | awk "/$display/"'{ print $1}')

echo "tabletmode.sh __ $tablet_mode __ $user"

if [ "$tablet_mode" = "$tablet_mode_on" ]; then
	echo "on"
	# Starts the "onboard" app in the background (&)
	sudo -iu $user /usr/bin/onboard &

	# Using native osk instead
    # echo $(sudo -iu $user gsettings get org.gnome.desktop.a11y.applications screen-keyboard-enabled)
    # sudo -iu $user gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true
    # echo $(sudo -iu $user gsettings get org.gnome.desktop.a11y.applications screen-keyboard-enabled)
	echo "on end"

elif [ "$tablet_mode" = "$tablet_mode_off" ]; then
	echo "off"
	# Finds "onboard" process and kills it
	pid=$(ps ax | awk '/usr\/bin\/onboard/ { print $1 }') && kill $pid

	# Using native osk instead
    # echo $(sudo -iu $user gsettings get org.gnome.desktop.a11y.applications screen-keyboard-enabled)
    # sudo -iu $user gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled false
    # echo $(sudo -iu $user gsettings get org.gnome.desktop.a11y.applications screen-keyboard-enabled)
	echo "off end"
fi
