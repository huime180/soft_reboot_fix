#!/system/bin/sh

ui_print ""
ui_print "软重启修复"
ui_print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 只允许 KernelSU
if [ "$KSU" != "true" ]; then
  abort "本模块仅限 KernelSU 临时root（越狱模式）使用！\n请勿在 Magisk / APatch 等环境下安装。"
fi

ui_print "→ KernelSU v$KSU_VER ($KSU_VER_CODE) 检测通过"

MODDIR="/data/adb/modules_update/ksu_soft_reroot_fix"
mkdir -p "$MODDIR"

# 机型检测
brand=$(getprop ro.product.brand)
manufacturer=$(getprop ro.product.manufacturer)
name=$(getprop ro.product.name)
model=$(getprop ro.product.model)

if echo "$brand $manufacturer $name $model" | grep -qi "oneplus"; then
    ui_print "检测到机型为OnePlus，将创建 post_fs_data.sh 自动关闭 oplus_secure_guard_new 内核模块"

    cat > "$MODDIR/post_fs_data.sh" <<EOF
#!/system/bin/sh
rmmod oplus_secure_guard_new
EOF
fi

# 设置执行权限
ui_print "配置执行权限"
chmod 0755 "$MODDIR/bin/fb_selinux_0.sh" \
           "$MODDIR/bin/switch_selinux.sh" \
           "$MODDIR/bin/fastboot" \
           "$MODDIR/webroot/sh/get_config.sh" \
           "$MODDIR/webroot/sh/set_config.sh" 2>/dev/null

# 迁移旧配置
OLD_CONF="/data/adb/modules/ksu_soft_reroot_fix/config.ini"
CONF="$MODDIR/config.ini"

if [ -f "$OLD_CONF" ]; then
    cp "$OLD_CONF" "$CONF"
fi

OLD_CONFJS="/data/adb/modules/ksu_soft_reroot_fix/webroot/config_loader.js"
CONFJS="$MODDIR/webroot/config_loader.js"

if [ -f "$OLD_CONFJS" ]; then
    cp "$OLD_CONFJS" "$CONFJS"
fi

ui_print ""
ui_print "来源: MKSU 和 KernelSU group"
ui_print "安装完成"
