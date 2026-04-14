set_system_prop() {
	if command -v resetprop >/dev/null 2>&1; then
		resetprop "$1" "$2"
	else
		setprop "$1" "$2"
	fi
}

put_global() {
	settings put global "$1" "$2" >/dev/null 2>&1
}

restart_adbd() {
	stop adbd >/dev/null 2>&1
	start adbd >/dev/null 2>&1
	if [ "$(getprop init.svc.adbd)" != "running" ]; then
		setprop ctl.stop adbd >/dev/null 2>&1
		setprop ctl.start adbd >/dev/null 2>&1
	fi
}

stop_adbd() {
	stop adbd >/dev/null 2>&1
	if [ "$(getprop init.svc.adbd)" != "running" ]; then
		setprop ctl.stop adbd >/dev/null 2>&1
	fi
}

adb_on() {
	put_global adb_enabled 1
	put_global adb_wifi_enabled 1
	set_system_prop service.adb.tcp.port 5555
	set_system_prop persist.sys.usb.config adb
	restart_adbd
}

adb_off() {
	put_global adb_enabled 0
	put_global adb_wifi_enabled 0
	set_system_prop service.adb.tcp.port -1
	set_system_prop persist.sys.usb.config none
	stop_adbd
}

do_switch() {
    query_usb_adb() { settings get global adb_enabled 2>/dev/null; }
	if [ "$(query_usb_adb)" = "0" ]; then
		adb_on
	else
		adb_off
	fi
}

do_switch
