#!/usr/bin/env sh

BINARY_DIR="/usr/local/bin/"
BINARY_NAME="coder"

cd "${BINARY_DIR}"

case "$(uname -m)" in
  x86_64)
    ARCH="amd64"
    ;;
  aarch64)
    ARCH="arm64"
    ;;
  *)
    echo "Unsupported architecture" >&2
    exit 1
    ;;
esac

BINARY_URL=${ACCESS_URL%%/}/bin/coder-linux-${ARCH}

wget -q "${BINARY_URL}" -O "${BINARY_NAME}"

if ! chmod +x "${BINARY_NAME}"; then
	echo "Failed to make binary executable"
	exit 1
fi
