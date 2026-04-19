# dirac & misoundfx Remover Magisk Module

## Descriptions
- Removes dirac sound effect & misoundfx and their apps systemlessly
- Required for most of audio mods to be working properly

## Changelog

v1.1
- Fix wrong target in latest KernelSU
- ro.audio.soundfx.dirac=false

v1.0
- Abort installation if fail to mount mirror system

v0.9
- Improve /odm and /my_product support detection

v0.8
- Fix bug in uninstall.sh

v0.7
- Removes Dirac from Nothing Phone

v0.6
- Improve xml patch detection
- Add libdiraceffect-afm.so to the removal list
- Fix conflict with modules_update while installing via recovery if Magisk installed

v0.5
- New Magisk and Kitsune Mask support (independent mirror)
- Remount partitions before mounting mirror to prevent mount failure caused by device/resource busy
- Add LineageParts.apk to hide.parts optional list

v0.4
- Redirect /sdcard to /data/media/"$UID"
- Add optional debug.log=1 for more detailed install log
- Kitsune Mask detection
- Restarts android.hardware.audio@4.0-service-mediatek

v0.3
- Save install log at /sdcard/..._recovery.log if installing via Recovery
- Save uninstall log at /data/media/0/..._uninstall.log
- Fix mount required partitions while installing via Recovery
- Fix Magisk v26.1 support
- Fix KernelSU support

v0.2
- KernelSU support
- Magisk v26.1 support
- Mount required partitions in Recovery

## Requirements
- Magisk or Kitsune Mask or KernelSU or Apatch installed

## Installation Guide & Download Link
- Install this module https://devuploads.com/oxtlqx7m82ly via Magisk app or Kitsune Mask app or KernelSU app or Apatch app or Recovery if Magisk or Kitsune Mask installed
- This is also an audio mod so, you need to install AML Magisk Module https://t.me/ryukinotes/34 if using any other else audio mod module
- Reboot
- You can use https://github.com/reiryuki/Z-Folder-Script and check loaded_soundfx.txt created is your dirac or misoundfx effect removed or not.

## Optionals
- Global: https://t.me/ryukinotes/35

## Troubleshootings
- Global: https://t.me/ryukinotes/34

## Support & Bug Report
- https://t.me/ryukinotes/54 (Z folder is enough, no need logs)
- If you don't do above, issues will be closed immediately

## Credits and Contributors
- @HuskyDG
- https://t.me/viperatmos
- https://t.me/androidryukimodsdiscussions
- You can contribute ideas about this Magisk Module here: https://t.me/androidappsportdevelopment

## Sponsors
- https://t.me/ryukinotes/25


