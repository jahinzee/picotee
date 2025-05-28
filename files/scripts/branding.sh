#!/usr/bin/env bash

# Based on:
#    https://github.com/winblues/blue95/blob/main/files/scripts/00-image-info.sh
# Authors:
#    * jahinzee
#    * blue95 contributors
# License:
#     Apache License 2.0 <https://apache.org/licenses/LICENSE-2.0.txt>
# Changes:
#     * Edited branding info w/ details relevant to Picotee
#     * Added separate DEFAULT_HOSTNAME variable

set -euo pipefail

IMAGE_VENDOR="jahinzee"
IMAGE_NAME="picotee"
IMAGE_PRETTY_NAME="Picotee"
IMAGE_LIKE="fedora"
DEFAULT_HOSTNAME="picotee"
VERSION_CODENAME="indev"

HOME_URL="https://github.com/jahinzee/picotee"
DOCUMENTATION_URL="https://github.com/jahinzee/picotee"
SUPPORT_URL="https://github.com/jahinzee/picotee"
BUG_SUPPORT_URL="https://github.com/jahinzee/picotee/issues"

IMAGE_INFO="/usr/share/ublue-os/image-info.json"
IMAGE_REF="ostree-image-signed:docker://ghcr.io/$IMAGE_VENDOR/$IMAGE_NAME"

FEDORA_MAJOR_VERSION=$(awk -F= '/VERSION_ID/ {print $2}' /etc/os-release)
BASE_IMAGE="ghcr.io/ublue-os/kinoite-main"

cat >$IMAGE_INFO <<EOF
{
  "image-name": "$IMAGE_NAME",
  "image-vendor": "$IMAGE_VENDOR",
  "image-ref": "$IMAGE_REF",
  "image-tag": "latest",
  "base-image-name": "$BASE_IMAGE",
  "fedora-version": "$FEDORA_MAJOR_VERSION"
}
EOF

# OS Release File
sed -i "s/^VARIANT_ID=.*/VARIANT_ID=$IMAGE_NAME/" /usr/lib/os-release
sed -i "s/^PRETTY_NAME=.*/PRETTY_NAME=\"${IMAGE_PRETTY_NAME}\"/" /usr/lib/os-release
sed -i "s/^NAME=.*/NAME=\"$IMAGE_PRETTY_NAME\"/" /usr/lib/os-release
sed -i "s/^ID=.*/ID=\"$IMAGE_NAME\"/" /usr/lib/os-release
sed -i "s|^HOME_URL=.*|HOME_URL=\"$HOME_URL\"|" /usr/lib/os-release
sed -i "s|^DOCUMENTATION_URL=.*|DOCUMENTATION_URL=\"$DOCUMENTATION_URL\"|" /usr/lib/os-release
sed -i "s|^SUPPORT_URL=.*|SUPPORT_URL=\"$SUPPORT_URL\"|" /usr/lib/os-release
sed -i "s|^BUG_REPORT_URL=.*|BUG_REPORT_URL=\"$BUG_SUPPORT_URL\"|" /usr/lib/os-release
sed -i "s/^DEFAULT_HOSTNAME=.*/DEFAULT_HOSTNAME=\"${DEFAULT_HOSTNAME,}\"/" /usr/lib/os-release
sed -i "s/^ID=fedora/ID=${IMAGE_PRETTY_NAME,}\nID_LIKE=\"${IMAGE_LIKE}\"/" /usr/lib/os-release
sed -i "/^REDHAT_BUGZILLA_PRODUCT=/d; /^REDHAT_BUGZILLA_PRODUCT_VERSION=/d; /^REDHAT_SUPPORT_PRODUCT=/d; /^REDHAT_SUPPORT_PRODUCT_VERSION=/d" /usr/lib/os-release
sed -i "s/^VERSION_CODENAME=.*/VERSION_CODENAME=${VERSION_CODENAME,,}/" /usr/lib/os-release

#if [[ -n "${SHA_HEAD_SHORT:-}" ]]; then
#  echo "BUILD_ID=\"$SHA_HEAD_SHORT\"" >> /usr/lib/os-release
#fi

# Fix issues caused by ID no longer being fedora
sed -i "s/^EFIDIR=.*/EFIDIR=\"fedora\"/" /usr/sbin/grub2-switch-to-blscfg