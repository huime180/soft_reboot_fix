case "$(getenforce)" in
    Permissive)
        setenforce 1
        echo "SELinux 已切换到 强制模式"
        ;;
    Enforcing)
        setenforce 0
        echo "SELinux 已切换到 宽容模式"
        ;;
    *)
        echo "未知状态"
        ;;
esac