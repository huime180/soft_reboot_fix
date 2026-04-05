#!/system/bin/sh

CONF="/data/adb/modules/ksu_soft_reroot_fix/config.ini"

# 退出 zygiskd（如果存在）
[ -f /data/adb/modules/zygisksu/bin/zygiskd ] && \
    /data/adb/modules/zygisksu/bin/zygiskd exit

# 清理守护进程
if [ -f "$CONF" ]; then
    . "$CONF"
    if [ -n "$DAEMON_LIST" ]; then
        for p in $DAEMON_LIST; do
            killall "$p" 2>/dev/null || pkill -f "$p" 2>/dev/null
        done
    fi
fi

# 根据配置决定是否刷 PID
if [ -f "$CONF" ]; then
    . "$CONF"
    if [ "$ENABLE_PID" = "1" ]; then
        last_pid=$(sh -c 'echo $PPID')
        wrapped=0
        while :; do
            : &
            current_pid=$!
            if [ "$current_pid" -lt "$last_pid" ]; then
                wrapped=1
            fi
            if [ "$wrapped" -eq 1 ] && [ "$current_pid" -ge 1700 ]; then
                break
            fi
            last_pid=$current_pid
        done
    fi
fi
