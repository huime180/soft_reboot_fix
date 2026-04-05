#!/system/bin/sh

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "— 请选择操作："
echo "— [ 音量 加(+): 切换SElinux状态 ]"
echo "— [ 音量 减(-): 对另一台设备宽容(需要双头Type-C线) ]"

START_TIME=$(date +%s)
while true; do
  NOW_TIME=$(date +%s)
  timeout 1 getevent -lc 1 2>&1 | grep KEY_VOLUME > "$TMPDIR/events"

  if [ $(( NOW_TIME - START_TIME )) -gt 9 ]; then
    ui_print "— 超时未检测到按键，默认执行切换宽容模式..."
    sh /data/adb/modules/soft_reboot_fix/bin/switch_selinux.sh
    break
  elif grep -q KEY_VOLUMEUP "$TMPDIR/events"; then
    ui_print "— 检测到音量加键 → 切换宽容模式"
    sh /data/adb/modules/soft_reboot_fix/bin/switch_selinux.sh
    break
  elif grep -q KEY_VOLUMEDOWN "$TMPDIR/events"; then
    ui_print "— 检测到音量减键 → 对另一台手机宽容"
    sh /data/adb/modules/soft_reboot_fix/bin/fb_selinux_0.sh
    break
  fi
done
