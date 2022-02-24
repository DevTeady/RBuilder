#!/bin/bash
source vars.sh

telegram_message() {
	curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" -d chat_id="${TG_CHAT_ID}" \
	-d text="$1"
}

# Change to the Source Directory
cd $SYNC_PATH

# Set-up ccache
if [ -z "$CCACHE_SIZE" ]; then
    ccache -M 50G
else
    ccache -M ${CCACHE_SIZE}
fi


# Send the Telegram Message
telegram_message \
"
O.o Saad's ROM Builder CI
✔️ The Build has been Triggered!
📱 Device: ${DEVICE}
🌲 Logs: [https://cirrus-ci.com/build/${CIRRUS_BUILD_ID}](https://cirrus-ci.com/build/${CIRRUS_BUILD_ID})
🖥 Build OS: ${MANIFEST_BRANCH}
"
echo " "

# Run the Extra Command
$EXTRA_CMD

# Prepare the Build Environment
source build/envsetup.sh

# lunch the target
lunch ${LUNCH_COMBO} || { echo "ERROR: Failed to lunch the target!" && exit 1; }

# Build the Code
if [ -z "$J_VAL" ]; then
    mka -j$(nproc --all) $TARGET || { echo "ERROR: Build Failed!" && exit 1; }
elif [ "$J_VAL"="0" ]; then
    mka $TARGET || { echo "ERROR: Build Failed!" && exit 1; }
else
    mka -j${J_VAL} $TARGET || { echo "ERROR: Build Failed!" && exit 1; }
fi

# Exit
exit 0