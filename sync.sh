#!/bin/bash
source vars.sh

# Make the Directory if it doesn't exist
mkdir -p $SYNC_PATH

telegram_message() {
	curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" -d chat_id="${TG_CHAT_ID}" \
	-d text="$1"
}

# Change to the Source Directory
cd $SYNC_PATH

# Init Repo
repo init --depth=1 -u $MANIFEST -b $MANIFEST_BRANCH

# Sync the Sources
repo sync -j$(nproc --all) --force-sync --no-tags --no-clone-bundle

# Clone Trees
git clone --single-branch --depth=1 $DT_LINK $DT_PATH || { echo "ERROR: Failed to Clone the Device Trees!" && exit 1; }
git clone --single-branch --depth=1 $DCT_LINK $DCT_PATH
git clone --single-branch --depth=1 $VT_LINK $VT_PATH
git clone --single-branch --depth=1 $VCT_LINK $VCT_PATH
git clone --single-branch --depth=1 $KT_LINK $KT_PATH

# Exit
exit 0