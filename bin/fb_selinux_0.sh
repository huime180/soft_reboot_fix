#!/bin/bash
# =============================================
# 功能：临时关闭 SELinux（通过 Qualcomm 漏洞方式）
#       1. 重启到 bootloader
#       2. 发送特殊 oem 命令注入 androidboot.selinux=permissive
#       3. continue 继续启动系统

echo "========================================"
echo "设置SELinux宽容"
echo "功能: 重启到 bootloader 并设置 SELinux Permissive"
echo "========================================"
echo "开始执行"
echo "请先让设备进入fastboot模式"
echo ""   
# 步骤1：执行关键命令（利用漏洞注入 selinux=permissive）
echo "执行 oem set-gpu-preemption 注入 SELinux permissive..."
/data/adb/modules/ksu_soft_reroot_fix/bin/fastboot oem set-gpu-preemption 0 androidboot.selinux=permissive

# 步骤2：启动系统
echo "执行 continue，让设备正常开机（SELinux 将处于 permissive 模式）..."
/data/adb/modules/ksu_soft_reroot_fix/bin/fastboot continue

echo "========================================"
echo "执行完成！"
