#!/system/bin/flash
resetprop() {
	if command -v resetprop >/dev/null 2>&1; then
		command resetprop "$1" "$2"
	else
		/data/adb/ksu/bin/resetprop "$1" "$2"
	fi
}

check_reset_prop() {
  local NAME=$1
  local EXPECTED=$2
  local VALUE=$(resetprop $NAME)
  [ -z $VALUE ] || [ $VALUE = $EXPECTED ] || resetprop -n $NAME $EXPECTED
}

resetprop -w sys.boot_completed 0

# 安全属性
check_reset_prop "ro.secure" "1"
# 启动/验证状态
check_reset_prop "ro.boot.selinux" "enforcing"

# 分区验证（隐藏警告）
check_reset_prop "partition.system.verified" "0"
check_reset_prop "partition.vendor.verified" "0"
check_reset_prop "partition.product.verified" "0"
check_reset_prop "partition.system_ext.verified" "0"
check_reset_prop "partition.odm.verified" "0"

# SELinux上下文
restorecon /dev/__properties__/u:object_r:adbd_config_prop:s0
restorecon /dev/__properties__/u:object_r:shell_prop:s0

# Found proper
setprop persist.logd.size ""
setprop persist.logd.size.crash ""
setprop persist.logd.size.system ""
setprop persist.logd.size.main ""

# 其它
echo 0 > /proc/sys/kernel/kptr_restrict
echo 0 > /proc/sys/kernel/dmesg_restrict
echo 0 > /proc/sys/fs/suid_dumpable
echo 0 > /proc/sys/kernel/core_pattern

