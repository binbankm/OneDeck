#!/usr/bin/env bash
# =============================================================================
# OneDeck - Automated Build Script for Unsigned Release IPA
# For TrollStore, AltStore, Sideloadly, Scarlet, or Custom Sideloading
# =============================================================================

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

BUILD_DIR="$PROJECT_ROOT/build"
DIST_DIR="$PROJECT_ROOT/dist"
APP_PATH="$BUILD_DIR/Release-iphoneos/OneDeck.app"

echo "======================================================================"
echo "🚀 Building OneDeck Unsigned Release IPA"
echo "======================================================================"

# 1. Clean previous builds
echo "▶ 1. Cleaning previous build artifacts..."
rm -rf "$BUILD_DIR"
mkdir -p "$DIST_DIR"

# 2. Build Release for iOS Device without Code Signing
echo "▶ 2. Compiling Release arm64 binary (CODE_SIGNING_ALLOWED=NO)..."
xcodebuild clean build \
    -project OneDeck.xcodeproj \
    -scheme OneDeck \
    -configuration Release \
    -destination "generic/platform=iOS" \
    CODE_SIGNING_ALLOWED=NO \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGN_IDENTITY="" \
    EXPANDED_CODE_SIGN_IDENTITY="" \
    BUILD_DIR="$BUILD_DIR"

if [[ ! -d "$APP_PATH" ]]; then
    echo "❌ Error: OneDeck.app not found at $APP_PATH"
    exit 1
fi

# 2b. Validate bundle metadata, privacy manifest, and localized InfoPlist strings
echo "▶ 2b. Verifying Info.plist, PrivacyInfo.xcprivacy, and localizations..."
if [[ ! -f "$APP_PATH/Info.plist" ]]; then
    echo "❌ Error: Info.plist missing from $APP_PATH"
    exit 1
fi
plutil -lint "$APP_PATH/Info.plist" >/dev/null

if [[ ! -f "$APP_PATH/PrivacyInfo.xcprivacy" ]]; then
    echo "❌ Error: PrivacyInfo.xcprivacy missing from $APP_PATH"
    exit 1
fi
plutil -lint "$APP_PATH/PrivacyInfo.xcprivacy" >/dev/null

for lproj in en.lproj zh-Hans.lproj zh-Hant.lproj; do
    if [[ ! -f "$APP_PATH/$lproj/InfoPlist.strings" ]]; then
        echo "❌ Error: $lproj/InfoPlist.strings missing from $APP_PATH"
        exit 1
    fi
done

# 3. Strip any residual signature or provisioning profiles
echo "▶ 3. Stripping any signature metadata..."
rm -rf "$APP_PATH/_CodeSignature"
rm -f "$APP_PATH/embedded.mobileprovision"

# 4. Package into standard Payload IPA structure
echo "▶ 4. Packaging into IPA archive..."
PAYLOAD_DIR="$DIST_DIR/Payload"
rm -rf "$PAYLOAD_DIR"
mkdir -p "$PAYLOAD_DIR"
cp -R "$APP_PATH" "$PAYLOAD_DIR/"

# Remove macOS metadata files if present
find "$PAYLOAD_DIR" -name ".DS_Store" -delete

VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$APP_PATH/Info.plist" 2>/dev/null || echo "1.0")
IPA_NAME="OneDeck_v${VERSION}_Release_unsigned.ipa"

cd "$DIST_DIR"
rm -f "$IPA_NAME" "OneDeck_unsigned.ipa"
zip -qr -9 "$IPA_NAME" Payload
cp "$IPA_NAME" "OneDeck_unsigned.ipa"
rm -rf Payload
cd "$PROJECT_ROOT"

# 5. Output Summary
FILE_SIZE=$(ls -lh "$DIST_DIR/$IPA_NAME" | awk '{print $5}')
SHA256_HASH=$(shasum -a 256 "$DIST_DIR/$IPA_NAME" | awk '{print $1}')

echo "======================================================================"
echo "✅ Unsigned Release IPA Created Successfully!"
echo "----------------------------------------------------------------------"
echo "📦 Output IPA: $DIST_DIR/$IPA_NAME"
echo "📦 Symlink:    $DIST_DIR/OneDeck_unsigned.ipa"
echo "📊 File Size:  $FILE_SIZE"
echo "🔒 SHA-256:    $SHA256_HASH"
echo "======================================================================"

