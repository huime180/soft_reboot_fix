#!/system/bin/sh

# 风险路径列表
RISK_PATHS="
/data/local/stryker
/data/system/AppRetention
/data/local/tmp/luckys
/data/local/tmp/input_devices
/data/local/tmp/HyperCeiler
/data/local/tmp/simpleHook
/data/local/tmp/DisabledAllGoogleServices
/data/local/MIO
/data/DNA
/data/local/tmp/cleaner_starter
/data/local/tmp/byyang
/data/local/tmp/mount_mask
/data/local/tmp/mount_mark
/data/local/tmp/scriptTMP
/data/local/luckys
/data/local/tmp/horae_control.log
/data/gpufreqtable.conf
/storage/emulated/0/MT2
/storage/emulated/0/Download/advanced
/storage/emulated/0/Documents/advanced
/data/system/NoActive
/data/system/Freezer
/storage/emulated/0/Android/naki
/data/swap_config.conf
/data/local/tmp/resetprop
"

# 转移目标目录
TARGET_DIR="/storage/emulated/0/Download/异常文件"
mkdir -p "$TARGET_DIR"

# 日志文件
LOG_FILE="$TARGET_DIR/log.txt"

echo "=== 异常文件排查开始 ==="
echo ""
date >> "$LOG_FILE"

for path in $RISK_PATHS; do
    if [ -d "$path" ]; then
        echo "[发现风险路径] $path"
        name=$(basename "$path")
        dest="$TARGET_DIR/$name"
        mkdir -p "$dest"
        cp -af "$path/"* "$dest/" 
        mount | grep " $path " >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            umount -l "$path" 2>/dev/null
        fi
        rm -rf "$path"
        echo "[已转移内容] $path -> $dest"
        echo "[已转移内容] $path -> $dest" >> "$LOG_FILE"
        echo ""
    fi
done

echo ""
echo "=== 异常文件排查结束 ==="
echo ""
echo "提示：若转移失败，请先取消对应模块挂载，MT管理器还需要设置自定义目录"
sleep 3