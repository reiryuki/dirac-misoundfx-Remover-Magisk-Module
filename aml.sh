MODPATH=${0%/*}

# magisk
if [ -d /sbin/.magisk ]; then
  MAGISKTMP=/sbin/.magisk
else
  MAGISKTMP=`realpath /dev/*/.magisk`
fi

# path
VENDOR=`realpath $MAGISKTMP/mirror/vendor`

# destination
if [ -d $VENDOR/lib/soundfx ]; then
  LIBPATH="\/vendor\/lib\/soundfx"
else
  LIBPATH="\/system\/lib\/soundfx"
fi
MODAEC=`find $MODPATH/system -type f -name *audio*effects*.conf`
MODAEX=`find $MODPATH/system -type f -name *audio*effects*.xml`
MODAP=`find $MODPATH/system -type f -name *policy*.conf -o -name *policy*.xml`

# function
remove_conf() {
for RMVS in $RMV; do
  sed -i "s/$RMVS/removed/g" $MODAEC
done
sed -i 's/path \/vendor\/lib\/soundfx\/removed//g' $MODAEC
sed -i 's/path \/system\/lib\/soundfx\/removed//g' $MODAEC
sed -i 's/path \/vendor\/lib\/removed//g' $MODAEC
sed -i 's/path \/system\/lib\/removed//g' $MODAEC
sed -i 's/library removed//g' $MODAEC
sed -i 's/uuid removed//g' $MODAEC
sed -i "/^        removed {/ {;N s/        removed {\n        }//}" $MODAEC
}
remove_xml() {
for RMVS in $RMV; do
  sed -i "s/\"$RMVS\"/\"removed\"/g" $MODAEX
done
sed -i 's/<library name="removed" path="removed"\/>//g' $MODAEX
sed -i 's/<library name="proxy" path="removed"\/>//g' $MODAEX
sed -i 's/<effect name="removed" library="removed" uuid="removed"\/>//g' $MODAEX
sed -i 's/<effect name="removed" uuid="removed" library="removed"\/>//g' $MODAEX
sed -i 's/<libsw library="removed" uuid="removed"\/>//g' $MODAEX
sed -i 's/<libhw library="removed" uuid="removed"\/>//g' $MODAEX
sed -i 's/<apply effect="removed"\/>//g' $MODAEX
sed -i 's/<library name="removed" path="removed" \/>//g' $MODAEX
sed -i 's/<library name="proxy" path="removed" \/>//g' $MODAEX
sed -i 's/<effect name="removed" library="removed" uuid="removed" \/>//g' $MODAEX
sed -i 's/<effect name="removed" uuid="removed" library="removed" \/>//g' $MODAEX
sed -i 's/<libsw library="removed" uuid="removed" \/>//g' $MODAEX
sed -i 's/<libhw library="removed" uuid="removed" \/>//g' $MODAEX
sed -i 's/<apply effect="removed" \/>//g' $MODAEX
}

# remove dirac
RMV="libdiraceffect.so dirac_gef 3799D6D1-22C5-43C3-B3EC-D664CF8D2F0D
     dirac_afm 743539F8-1076-451F-8395-84ACFAB0FAC7
     dirac_controller 128B9BA2-D0C9-47C6-AFF3-9F761CD0E228
     libdirac.so b437f4de-da28-449b-9673-667f8b9643fe
     dirac_music b437f4de-da28-449b-9673-667f8b964304
     dirac e069d9e0-8329-11df-9168-0002a5d5c51b"
if [ "$MODAEC" ]; then
  remove_conf
fi
if [ "$MODAEX" ]; then
  remove_xml
fi

# remove misoundfx
RMV="libmisoundfx.so misoundfx 5b8e36a5-144a-4c38-b1d7-0002a5d5c51b"
if [ "$MODAEC" ]; then
  remove_conf
fi
if [ "$MODAEX" ]; then
  remove_xml
fi


