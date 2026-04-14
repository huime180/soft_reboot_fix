#!/system/bin/sh
MODDIR=${0%/*}
if [ "$MODDIR" = "$0" ] || [ ! -f "$MODDIR/module.prop" ]; then
	if [ -f "/data/adb/modules/soft_reboot_fix/module.prop" ]; then
		MODDIR="/data/adb/modules/soft_reboot_fix"
	elif [ -f "/data/adb/modules_update/soft_reboot_fix/module.prop" ]; then
		MODDIR="/data/adb/modules_update/soft_reboot_fix"
	fi
fi
MODULE_PROP="$MODDIR/module.prop"
CONF_PATH="$MODDIR/config.ini"
daemonList=$(grep '^DAEMON_LIST=' ${CONF_PATH} | cut -d= -f2 | tr -d '"')

query_usb_adb() { settings get global adb_enabled 2>/dev/null; }
query_wifi_adb() { settings get global adb_wifi_enabled 2>/dev/null; }
query_tcp_port() { getprop service.adb.tcp.port 2>/dev/null; }

query_adbd() { getprop init.svc.adbd 2>/dev/null; }

status_label() {
	case "$1" in
	1) echo "ON" ;;
	0 | "") echo "OFF" ;;
	*) echo "$1" ;;
	esac
}

update_description() {
	USB="$(status_label "$(query_usb_adb)")"
	WIFI="$(status_label "$(query_wifi_adb)")"
	PORT="$(query_tcp_port)"
	ADBD="$(query_adbd)"

	[ "$PORT" = "5555" ] && WIFI_REAL="ON" || WIFI_REAL="$WIFI"

	DESC="ADB: ${USB} | PORT: ${PORT} | adbd: ${ADBD} | SElinux: $(getenforce) | daemon List: ${daemonList}"

	write_description "$DESC"
}

write_description() {
	DESC="$1"
	[ -f "$MODULE_PROP" ] || return 0

	TMP_PROP="${MODULE_PROP}.tmp"
	UPDATED=0

	: >"$TMP_PROP" 2>/dev/null || return 0

	while IFS= read -r LINE || [ -n "$LINE" ]; do
		case "$LINE" in
		description=*)
			printf '%s\n' "description=${DESC}" >>"$TMP_PROP"
			UPDATED=1
			;;
		*)
			printf '%s\n' "$LINE" >>"$TMP_PROP"
			;;
		esac
	done <"$MODULE_PROP"

	[ "$UPDATED" -eq 1 ] || printf '%s\n' "description=${DESC}" >>"$TMP_PROP"
	mv "$TMP_PROP" "$MODULE_PROP" >/dev/null 2>&1
}
update_description
