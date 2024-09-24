[ ! "$MODPATH" ] && MODPATH=${0%/*}

# destination
MODAECS=`find $MODPATH -type f -name *audio*effects*.conf`
MODAEXS=`find $MODPATH -type f -name *audio*effects*.xml`

# function
remove_conf() {
for RMV in $RMVS; do
  sed -i "s|$RMV|removed|g" $MODAEC
done
sed -i 's|path /vendor/lib/soundfx/removed||g' $MODAEC
sed -i 's|path /system/lib/soundfx/removed||g' $MODAEC
sed -i 's|path /vendor/lib/removed||g' $MODAEC
sed -i 's|path /system/lib/removed||g' $MODAEC
sed -i 's|path /vendor/lib64/soundfx/removed||g' $MODAEC
sed -i 's|path /system/lib64/soundfx/removed||g' $MODAEC
sed -i 's|path /vendor/lib64/removed||g' $MODAEC
sed -i 's|path /system/lib64/removed||g' $MODAEC
sed -i 's|library removed||g' $MODAEC
sed -i 's|uuid removed||g' $MODAEC
sed -i "/^        removed {/ {;N s/        removed {\n        }//}" $MODAEC
sed -i 's|removed { }||g' $MODAEC
sed -i 's|removed {}||g' $MODAEC
}
remove_xml() {
for RMV in $RMVS; do
  sed -i "s|\"$RMV\"|\"removed\"|g" $MODAEX
done
sed -i 's|<library name="removed" path="removed"/>||g' $MODAEX
sed -i 's|<library name="proxy" path="removed"/>||g' $MODAEX
sed -i 's|<effect name="removed" library="removed" uuid="removed"/>||g' $MODAEX
sed -i 's|<effect name="removed" uuid="removed" library="removed"/>||g' $MODAEX
sed -i 's|<libsw library="removed" uuid="removed"/>||g' $MODAEX
sed -i 's|<libhw library="removed" uuid="removed"/>||g' $MODAEX
sed -i 's|<apply effect="removed"/>||g' $MODAEX
sed -i 's|<library name="removed" path="removed" />||g' $MODAEX
sed -i 's|<library name="proxy" path="removed" />||g' $MODAEX
sed -i 's|<effect name="removed" library="removed" uuid="removed" />||g' $MODAEX
sed -i 's|<effect name="removed" uuid="removed" library="removed" />||g' $MODAEX
sed -i 's|<libsw library="removed" uuid="removed" />||g' $MODAEX
sed -i 's|<libhw library="removed" uuid="removed" />||g' $MODAEX
sed -i 's|<apply effect="removed" />||g' $MODAEX
}

# remove dirac
RMVS="libdiraceffect.so libdiraceffect-afm.so
      dirac_gef 3799D6D1-22C5-43C3-B3EC-D664CF8D2F0D
      dirac_afm 743539F8-1076-451F-8395-84ACFAB0FAC7
      dirac_controller 128B9BA2-D0C9-47C6-AFF3-9F761CD0E228
      libdirac.so b437f4de-da28-449b-9673-667f8b9643fe
      dirac_music b437f4de-da28-449b-9673-667f8b964304
      dirac e069d9e0-8329-11df-9168-0002a5d5c51b"
for MODAEC in $MODAECS; do
  remove_conf
done
for MODAEX in $MODAEXS; do
  remove_xml
done

# remove misoundfx
RMVS="libmisoundfx.so misoundfx 5b8e36a5-144a-4c38-b1d7-0002a5d5c51b"
for MODAEC in $MODAECS; do
  remove_conf
done
for MODAEX in $MODAEXS; do
  remove_xml
done













