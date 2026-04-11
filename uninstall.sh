if pm list packages | grep -q "com.tencent.tmgp.sgame"; then
    APP_DIR=$(pm path com.tencent.tmgp.sgame 2>/dev/null | head -1 | cut -d: -f2 | sed 's/\/base\.apk$//')
    chmod 755 "$APP_DIR/lib/arm64/libQAPECSharp.qti.so"
fi
