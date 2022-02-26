# sync
mkdir -p $HOME/work && cd $HOME/work
repo init -u https://github.com/Project-Awaken/android_manifest -b 12 && repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all)
git clone --single-branch --depth=1 https://github.com/mishrabiswajit/device_realme_r5x.git device/realme/r5x && git clone --single-branch --depth=1 https://github.com/mishrabiswajit/vendor_realme_r5x vendor/realme/r5x && git clone --single-branch --depth=1 https://github.com/mishrabiswajit/kernel_realme_r5x kernel/realme/r5x && git clone --single-branch --depth=1 https://github.com/LineageOS/android_external_ant-wireless_antradio-library.git external/ant-wireless/antradio-library/
# build
source build/envsetup.sh
cd $HOME/work && export USE_CCACHE=1 && ccache -M 50G && export CONFIG_STATE_NOTIFIER=y && export SELINUX_IGNORE_NEVERALLOWS=true && lunch awaken_r5x-userdebug && make bacon -j$(nproc --all)
