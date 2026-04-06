模块功能：  
   为Ksu越狱模式隐藏环境，软重启前杀死守护进程，运行切换SElinux状态或对另一台设备宽容(需要双头Type-C线)  
   
对另一台设备宽容:仅适用arm64  
   考虑到不能使用模块的情况，提供不需要root的方案，需要下载MT管理器的target28版本，解压后执行脚本即可对另一台设备宽容[noroot_SElinux_0(MT2-target28）](https://github.com/huime180/soft_reboot_fix/releases/download/v1.0.3/noroot_SElinux_0.MT2-target28.zip)  
    
创建原因：  
   目前KernelSU正式版的软重启模块和lsp已经修复，但会软重启时会残留并再次加载模块的守护进程(比如lsp），软重启次数多了，守护进程的占用内存会越来越大，并且无法通过软重启正常更新有守护进程的模块。 
  
解决办法:  
1.不行就多硬重启  
2.在data/adb/emulated-soft-reboot.d目录下创建脚本xxx.sh并赋予执行权限，让软重启前杀掉守护进程  
/data/adb/modules/zygisksu/bin/zygiskd exit 
killall lspd  
killall daemon #daemon换成其它守护进程  
3.用ksu_soft_reroot_fix.zip这个模块  
  
参考自[@mksu_ci](https://t.me/mksu_ci)和[@KernelSU_group](https://t.me/KernelSU_group)  
