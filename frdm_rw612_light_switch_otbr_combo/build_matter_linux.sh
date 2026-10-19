#!/bin/bash
# ==============================================================================
# Route 2: Build Matter Light Switch OTBR Combo for FRDM-RW612 (Linux / WSL)
# Reference: Section 5.2 of FRDM-RW612 Execution Procedure PDF
# ==============================================================================
set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
MATTER_ROOT="${SCRIPT_DIR}/matter"

echo "[1/5] Checking prerequisites..."
sudo apt-get update && sudo apt-get install -y \
    git gcc g++ pkg-config libssl-dev libdbus-1-dev \
    libglib2.0-dev libavahi-client-dev ninja-build python3-venv python3-dev \
    python3-pip unzip libgirepository1.0-dev libcairo2-dev libreadline-dev

if [ ! -d "${MATTER_ROOT}" ]; then
    echo "[2/5] Cloning NXP Matter repository (v1.4.0.0)..."
    git clone -b v1.4.0.0 https://github.com/NXP/matter.git "${MATTER_ROOT}"
    cd "${MATTER_ROOT}"
    scripts/checkout_submodules.py --shallow --platform nxp --recursive
    source ./scripts/activate.sh
    ./third_party/nxp/nxp_matter_support/scripts/update_nxp_sdk.py --platform common
else
    echo "[2/5] Matter repository already exists at ${MATTER_ROOT}"
    cd "${MATTER_ROOT}"
    source ./scripts/activate.sh
fi

echo "[3/5] Overlaying light-switch-combo-app examples..."
cp -r -f "${SCRIPT_DIR}/examples/"* "${MATTER_ROOT}/examples/"

echo "[4/5] Generating GN build configuration for FRDM-RW612..."
cd "${MATTER_ROOT}/examples/light-switch-combo-app/nxp/rt/rw61x"
gn gen --args='chip_enable_wifi=true chip_enable_openthread=true nxp_enable_matter_cli=true board_version="frdm" nxp_use_factory_data=false chip_enable_ota_requestor=false no_mcuboot=true' out/debug

echo "[5/5] Building firmware with Ninja..."
ninja -C out/debug

echo "=============================================================================="
echo "Build complete!"
echo "Output files located in: ${MATTER_ROOT}/examples/light-switch-combo-app/nxp/rt/rw61x/out/debug/"
echo "Copy chip-rw61x-light-switch-combo-example.hex/.srec to ${SCRIPT_DIR} for flashing."
echo "=============================================================================="

