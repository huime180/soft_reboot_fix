#!/system/bin/sh
MODDIR=${0%/*}
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "— 请选择操作："
echo "— [ 音量 加(+): 切换USB/WIFI ADB状态 ]"
echo "— [ 音量 减(-)：切换SElinux状态 ]"
echo "— [ 等待超时 : 对另一台设备宽容(需要双头Type-C线) ]"

START_TIME=$(date +%s)
while true; do
  NOW_TIME=$(date +%s)
  timeout 1 getevent -lc 1 2>&1 | grep KEY_VOLUME > "$TMPDIR/events"

  if [ $(( NOW_TIME - START_TIME )) -gt 5 ]; then
    echo "— 超时未检测到按键，正在对另一台设备宽容..."
    sh $MODDIR/bin/fb_selinux_0.sh
    break
  elif grep -q KEY_VOLUMEUP "$TMPDIR/events"; then
    echo "— 检测到音量加键 → 开始切换USB/WIFI ADB状态..."
    sh $MODDIR/bin/switch_adb.sh
    sh $MODDIR/bin/write_description.sh
    break
  elif grep -q KEY_VOLUMEDOWN "$TMPDIR/events"; then
    echo "— 检测到音量减键 → 开始切换SElinux状态..."
    sh $MODDIR/bin/switch_selinux.sh
    sh $MODDIR/bin/write_description.sh
    break
  fi
done
