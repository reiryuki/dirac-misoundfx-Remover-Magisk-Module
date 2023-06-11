# space
ui_print " "

# info
MODVER=`grep_prop version $MODPATH/module.prop`
MODVERCODE=`grep_prop versionCode $MODPATH/module.prop`
ui_print " ID=$MODID"
ui_print " Version=$MODVER"
ui_print " VersionCode=$MODVERCODE"
if [ "$KSU" == true ]; then
  ui_print " KSUVersion=$KSU_VER"
  ui_print " KSUVersionCode=$KSU_VER_CODE"
  ui_print " KSUKernelVersionCode=$KSU_KERNEL_VER_CODE"
else
  ui_print " MagiskVersion=$MAGISK_VER"
  ui_print " MagiskVersionCode=$MAGISK_VER_CODE"
fi
ui_print " "

# huskydg function
get_device() {
PAR="$1"
DEV="`cat /proc/self/mountinfo | awk '{ if ( $5 == "'$PAR'" ) print $3 }' | head -1 | sed 's/:/ /g'`"
}
mount_mirror() {
SRC="$1"
DES="$2"
RAN="`head -c6 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9'`"
while [ -e /dev/$RAN ]; do
  RAN="`head -c6 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9'`"
done
mknod /dev/$RAN b `get_device "$SRC"; echo $DEV`
if mount -t ext4 -o ro /dev/$RAN "$DES"\
|| mount -t erofs -o ro /dev/$RAN "$DES"\
|| mount -t f2fs -o ro /dev/$RAN "$DES"\
|| mount -t ubifs -o ro /dev/$RAN "$DES"; then
  blockdev --setrw /dev/$RAN
  rm -f /dev/$RAN
  return 0
fi
rm -f /dev/$RAN
return 1
}
unmount_mirror() {
DIRS="$MIRROR/system_root $MIRROR/system $MIRROR/vendor
      $MIRROR/product $MIRROR/system_ext $MIRROR/odm
      $MIRROR/my_product $MIRROR"
for DIR in $DIRS; do
  umount $DIR
done
}
mount_odm_to_mirror() {
DIR=/odm
if [ -d $DIR ]; then
  ui_print "- Mount $MIRROR$DIR..."
  mkdir -p $MIRROR$DIR
  if mount_mirror $DIR $MIRROR$DIR; then
    ui_print "  $MIRROR$DIR mount success"
  else
    ui_print "  ! $MIRROR$DIR mount failed"
    rm -rf $MIRROR$DIR
    if [ -d $MIRROR/system_root$DIR ]; then
      ln -sf $MIRROR/system_root$DIR $MIRROR
    fi
  fi
  ui_print " "
fi
}
mount_my_product_to_mirror() {
DIR=/my_product
if [ -d $DIR ]; then
  ui_print "- Mount $MIRROR$DIR..."
  mkdir -p $MIRROR$DIR
  if mount_mirror $DIR $MIRROR$DIR; then
    ui_print "  $MIRROR$DIR mount success"
  else
    ui_print "  ! $MIRROR$DIR mount failed"
    rm -rf $MIRROR$DIR
    if [ -d $MIRROR/system_root$DIR ]; then
      ln -sf $MIRROR/system_root$DIR $MIRROR
    fi
  fi
  ui_print " "
fi
}
mount_partitions_to_mirror() {
unmount_mirror
# mount system
if [ "$SYSTEM_ROOT" == true ]; then
  DIR=/system_root
  ui_print "- Mount $MIRROR$DIR..."
  mkdir -p $MIRROR$DIR
  if mount_mirror / $MIRROR$DIR; then
    ui_print "  $MIRROR$DIR mount success"
    rm -rf $MIRROR/system
    ln -sf $MIRROR$DIR/system $MIRROR
  else
    ui_print "  ! $MIRROR$DIR mount failed"
    rm -rf $MIRROR$DIR
  fi
else
  DIR=/system
  ui_print "- Mount $MIRROR$DIR..."
  mkdir -p $MIRROR$DIR
  if mount_mirror $DIR $MIRROR$DIR; then
    ui_print "  $MIRROR$DIR mount success"
  else
    ui_print "  ! $MIRROR$DIR mount failed"
    rm -rf $MIRROR$DIR
  fi
fi
ui_print " "
# mount vendor
DIR=/vendor
ui_print "- Mount $MIRROR$DIR..."
mkdir -p $MIRROR$DIR
if mount_mirror $DIR $MIRROR$DIR; then
  ui_print "  $MIRROR$DIR mount success"
else
  ui_print "  ! $MIRROR$DIR mount failed"
  rm -rf $MIRROR$DIR
  ln -sf $MIRROR/system$DIR $MIRROR
fi
ui_print " "
# mount product
DIR=/product
ui_print "- Mount $MIRROR$DIR..."
mkdir -p $MIRROR$DIR
if mount_mirror $DIR $MIRROR$DIR; then
  ui_print "  $MIRROR$DIR mount success"
else
  ui_print "  ! $MIRROR$DIR mount failed"
  rm -rf $MIRROR$DIR
  ln -sf $MIRROR/system$DIR $MIRROR
fi
ui_print " "
# mount system_ext
DIR=/system_ext
ui_print "- Mount $MIRROR$DIR..."
mkdir -p $MIRROR$DIR
if mount_mirror $DIR $MIRROR$DIR; then
  ui_print "  $MIRROR$DIR mount success"
else
  ui_print "  ! $MIRROR$DIR mount failed"
  rm -rf $MIRROR$DIR
  if [ -d $MIRROR/system$DIR ]; then
    ln -sf $MIRROR/system$DIR $MIRROR
  fi
fi
ui_print " "
mount_odm_to_mirror
mount_my_product_to_mirror
}

# magisk
MAGISKPATH=`magisk --path`
if [ "$BOOTMODE" == true ]; then
  if [ "$MAGISKPATH" ]; then
    mount -o rw,remount $MAGISKPATH
    MAGISKTMP=$MAGISKPATH/.magisk
    MIRROR=$MAGISKTMP/mirror
  else
    MAGISKTMP=/mnt
    mount -o rw,remount $MAGISKTMP
    MIRROR=$MAGISKTMP/mirror
    mount_partitions_to_mirror
  fi
fi

# path
SYSTEM=`realpath $MIRROR/system`
PRODUCT=`realpath $MIRROR/product`
VENDOR=`realpath $MIRROR/vendor`
SYSTEM_EXT=`realpath $MIRROR/system_ext`
if [ "$BOOTMODE" == true ]; then
  if [ ! -d $MIRROR/odm ]; then
    mount_odm_to_mirror
  fi
  if [ ! -d $MIRROR/my_product ]; then
    mount_my_product_to_mirror
  fi
fi
ODM=`realpath $MIRROR/odm`
MY_PRODUCT=`realpath $MIRROR/my_product`

# optionals
OPTIONALS=/sdcard/optionals.prop
if [ ! -f $OPTIONALS ]; then
  touch $OPTIONALS
fi

# mount
if [ "$BOOTMODE" != true ]; then
  if [ -e /dev/block/bootdevice/by-name/vendor ]; then
    mount -o rw -t auto /dev/block/bootdevice/by-name/vendor /vendor
  else
    mount -o rw -t auto /dev/block/bootdevice/by-name/cust /vendor
  fi
  mount -o rw -t auto /dev/block/bootdevice/by-name/product /product
  mount -o rw -t auto /dev/block/bootdevice/by-name/system_ext /system_ext
  mount -o rw -t auto /dev/block/bootdevice/by-name/odm /odm
  mount -o rw -t auto /dev/block/bootdevice/by-name/my_product /my_product
  mount -o rw -t auto /dev/block/bootdevice/by-name/persist /persist
  mount -o rw -t auto /dev/block/bootdevice/by-name/metadata /metadata
fi

# sepolicy
FILE=$MODPATH/sepolicy.rule
DES=$MODPATH/sepolicy.pfsd
if [ "`grep_prop sepolicy.sh $OPTIONALS`" == 1 ]\
&& [ -f $FILE ]; then
  mv -f $FILE $DES
fi

# .aml.sh
mv -f $MODPATH/aml.sh $MODPATH/.aml.sh

# cleaning
ui_print "- Cleaning..."
rm -rf /metadata/magisk/$MODID
rm -rf /mnt/vendor/persist/magisk/$MODID
rm -rf /persist/magisk/$MODID
rm -rf /data/unencrypted/magisk/$MODID
rm -rf /cache/magisk/$MODID
ui_print " "

# function
conflict() {
for NAMES in $NAME; do
  DIR=/data/adb/modules_update/$NAMES
  if [ -f $DIR/uninstall.sh ]; then
    sh $DIR/uninstall.sh
  fi
  rm -rf $DIR
  DIR=/data/adb/modules/$NAMES
  rm -f $DIR/update
  touch $DIR/remove
  FILE=/data/adb/modules/$NAMES/uninstall.sh
  if [ -f $FILE ]; then
    sh $FILE
    rm -f $FILE
  fi
  rm -rf /metadata/magisk/$NAMES
  rm -rf /mnt/vendor/persist/magisk/$NAMES
  rm -rf /persist/magisk/$NAMES
  rm -rf /data/unencrypted/magisk/$NAMES
  rm -rf /cache/magisk/$NAMES
done
}

# function
hide_oat() {
for APP in $APPS; do
  REPLACE="$REPLACE
  `find $MODPATH/system -type d -name $APP | sed "s|$MODPATH||"`/oat"
done
}
replace_dir() {
if [ -d $DIR ]; then
  REPLACE="$REPLACE $MODDIR"
fi
}
hide_app() {
DIR=$SYSTEM/app/$APP
MODDIR=/system/app/$APP
replace_dir
DIR=$SYSTEM/priv-app/$APP
MODDIR=/system/priv-app/$APP
replace_dir
DIR=$PRODUCT/app/$APP
MODDIR=/system/product/app/$APP
replace_dir
DIR=$PRODUCT/priv-app/$APP
MODDIR=/system/product/priv-app/$APP
replace_dir
DIR=$MY_PRODUCT/app/$APP
MODDIR=/system/product/app/$APP
replace_dir
DIR=$MY_PRODUCT/priv-app/$APP
MODDIR=/system/product/priv-app/$APP
replace_dir
DIR=$PRODUCT/preinstall/$APP
MODDIR=/system/product/preinstall/$APP
replace_dir
DIR=$SYSTEM_EXT/app/$APP
MODDIR=/system/system_ext/app/$APP
replace_dir
DIR=$SYSTEM_EXT/priv-app/$APP
MODDIR=/system/system_ext/priv-app/$APP
replace_dir
DIR=$VENDOR/app/$APP
MODDIR=/system/vendor/app/$APP
replace_dir
DIR=$VENDOR/euclid/product/app/$APP
MODDIR=/system/vendor/euclid/product/app/$APP
replace_dir
}

# hide
APPS="MiSound Dirac DiracAudioControlService"
for APP in $APPS; do
  hide_app
done

# hide
if [ "`grep_prop hide.parts $OPTIONALS`" == 1 ]; then
  APPS="XiaomiParts ZenfoneParts ZenParts GalaxyParts
       KharaMeParts DeviceParts PocoParts"
  ui_print "- Hides * Parts app"
  for APP in $APPS; do
    hide_app
  done
  ui_print " "
fi

# run
. $MODPATH/copy.sh
. $MODPATH/.aml.sh

# unmount
if [ "$BOOTMODE" == true ] && [ ! "$MAGISKPATH" ]; then
  unmount_mirror
fi












