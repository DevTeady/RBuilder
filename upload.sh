#!/bin/bash
# Source Vars
source vars.sh

# A Function to Send Posts to Telegram
telegram_message() {
	curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" -d chat_id="${TG_CHAT_ID}" \
	-d parse_mode="Markdown" \
	-d text="$1"
}

# Change to the Source Directory
cd $SYNC_PATH

# Display a message
echo "============================"
echo "Uploading the Build..."
echo "============================"

# Change to the Output Directory
cd out/target/product/${DEVICE}

# Set FILENAME var
FILENAME=$(echo $OUTPUT)

# Upload to oshi.at
if [ -z "$TIMEOUT" ];then
    TIMEOUT=20160 # 14 Days
fi

# Upload to WeTransfer
# NOTE: the current Docker Image, "ghcr.io/sushrut1101/docker:latest", includes the 'transfer' binary by Default
transfer wet $FILENAME > link.txt || { echo "ERROR: Failed to Upload the Build!" && exit 1; }

# Mirror to oshi.at
curl -T $FILENAME https://oshi.at/${FILENAME}/${OUTPUT} > mirror.txt || { echo "WARNING: Failed to Mirror the Build!"; }

DL_LINK=$(cat link.txt | grep Download | cut -d\  -f3)
MIRROR_LINK=$(cat mirror.txt | grep Download | cut -d\  -f1)

# Show the Download Link
echo "=============================================="
echo "Download Link: ${DL_LINK}" || { echo "ERROR: Failed to Upload the Build!"; }
echo "Mirror: ${MIRROR_LINK}" || { echo "WARNING: Failed to Mirror the Build!"; }
echo "=============================================="

telegram_message \
"
O.o Saad's ROM Builder CI
✅ Build Completed Successfully!
📱 Device: ${DEVICE}
🖥 Build OS: ${MANIFEST_BRANCH}
⬇️ Download Link: [${DL_LINK}](Here)
📅 Date: $(date +'%d %B %Y')
⏱ Time: $(date +"%T")
"
echo " "

# Exit
exit 0