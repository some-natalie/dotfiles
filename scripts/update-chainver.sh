#!/bin/bash
# Script to update the chainver version on macbook to whatever's latest
# Usage: ./update-chainver.sh

# get existing version
VERSION=$(chainver version | sed -n 's/^ChainVer version \([0-9.]*\).*/\1/p')

# download latest version
LATEST=$(curl -s "https://storage.googleapis.com/us.artifacts.prod-enforce-fabc.appspot.com/?prefix=chainver/" | \
  grep -oE 'chainver/[0-9]+\.[0-9]+\.[0-9]+/' | \
  sed 's|chainver/||g' | sed 's|/$||g' | \
  sort -V | tail -1)

# if latest version is same as existing version, exit
if [ "$VERSION" == "$LATEST" ]; then
  echo "ChainVer is already up to date (version $VERSION)"
  exit 0
fi

# download latest version
echo "Downloading ChainVer version $LATEST..."
curl -LO "https://dl.enforce.dev/chainver/${LATEST}/chainver-v${LATEST}.zip"
unzip -o "chainver-v${LATEST}.zip" -d $HOME/.local/bin
tar -xf $HOME/.local/bin/chainver-package/archives/chainver_${LATEST}_Darwin_arm64.tar.gz -C $HOME/.local/bin/
rm "chainver-v${LATEST}.zip"
rm -rf $HOME/.local/bin/chainver-package
xattr -dr com.apple.quarantine $HOME/.local/bin/chainver

# verify installation
NEW_VERSION=$(chainver version | sed -n 's/^ChainVer version \([0-9.]*\).*/\1/p')
if [ "$NEW_VERSION" == "$LATEST" ]; then
  echo "ChainVer successfully updated to version $NEW_VERSION"
  exit 0
else
  echo "Failed to update ChainVer. Current version is still $NEW_VERSION"
  exit 1
fi
