#!/system/bin/sh

ui_print ""
ui_print "软重启修复"
ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 只允许 KernelSU
if [ "$KSU" != "true" ]; then
  abort "本模块仅限 KernelSU 临时root（越狱模式）使用！\n请勿在 Magisk / APatch 等环境下安装。"
fi

ui_print "→ KernelSU v$KSU_VER ($KSU_VER_CODE) 检测通过"

/data/adb/ksud module uninstall ksu_soft_reroot_fix
MODDIR="/data/adb/modules_update/soft_reboot_fix"
# 机型检测
brand=$(getprop ro.product.brand)
manufacturer=$(getprop ro.product.manufacturer)
name=$(getprop ro.product.name)
model=$(getprop ro.product.model)
echo "当前机型：$brand $manufacturer $name $model"
if echo "$brand $manufacturer $name $model" | grep -qi "oneplus"; then
    ui_print "检测到机型为OnePlus，将创建 post-fs-data.sh 自动关闭 oplus_secure_guard_new 内核模块"

    cat > "$MODDIR/post-fs-data.sh" <<EOF
#!/system/bin/sh
rmmod oplus_secure_guard_new
EOF
fi

#冻结系统更新
echo "自动冻结系统更新，注意：非root状态也不会恢复"
pm hide com.oplus.ota com.android.updater 2>/dev/null

if pm list packages | grep -q "com.tencent.tmgp.sgame"; then
    echo "检测到已安装王者，自动执行防闪退"
    APP_DIR=$(pm path com.tencent.tmgp.sgame 2>/dev/null | head -1 | cut -d: -f2 | sed 's/\/base\.apk$//')
    chmod 000 "$APP_DIR/lib/arm64/libQAPECSharp.qti.so"
fi

# 设置执行权限
ui_print "配置执行权限"
chmod 0755 "$MODDIR/bin/fastboot" 2>/dev/null

# 迁移旧配置
OLD_CONF="/data/adb/modules/soft_reboot_fix/config.ini"
CONF="$MODDIR/config.ini"

if [ -f "$OLD_CONF" ]; then
    cp "$OLD_CONF" "$CONF"
fi

OLD_CONFJS="/data/adb/modules/soft_reboot_fix/webroot/config_loader.js"
CONFJS="$MODDIR/webroot/config_loader.js"

if [ -f "$OLD_CONFJS" ]; then
    cp "$OLD_CONFJS" "$CONFJS"
fi

ui_print ""
ui_print "来源: MKSU 和 KernelSU group"
ui_print "安装完成"
