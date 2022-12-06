MODPATH=${0%/*}
APP="MiSound Dirac DiracAudioControlService"
PKG="com.miui.misound se.dirac.acs"
for APPS in $APP; do
  rm -f `find /data/system/package_cache -type f -name *$APPS*`
  rm -f `find /data/dalvik-cache /data/resource-cache -type f -name *$APPS*.apk`
done
for PKGS in $PKG; do
  rm -rf /data/user/*/$PKGS/*
done


