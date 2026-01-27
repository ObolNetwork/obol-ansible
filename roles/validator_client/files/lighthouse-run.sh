#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="/opt/lighthouse"
VALIDATOR_KEYS_DIR="/opt/charon/validator_keys"

mkdir -p "${DATA_DIR}"

for f in "${VALIDATOR_KEYS_DIR}"/keystore-*.json; do
    [ -f "$f" ] || continue
    echo "Importing key ${f}"
    lighthouse --network "${NETWORK}" account validator import \
        --reuse-password \
        --keystore "$f" \
        --password-file "${f%.json}.txt" \
        --validators-dir "${DATA_DIR}"
done

builder_args=""
if [ "${BUILDER_API_ENABLED:-false}" = "true" ]; then
    builder_args="--builder-proposals"
fi

exec lighthouse --network "${NETWORK}" validator \
    --beacon-nodes "${BEACON_NODE_ADDRESS}" \
    --validators-dir "${DATA_DIR}" \
    --suggested-fee-recipient "${FEE_RECIPIENT}" \
    --metrics \
    --metrics-address "0.0.0.0" \
    --metrics-port "${LIGHTHOUSE_METRICS_PORT}" \
    --use-long-timeouts \
    --distributed \
    ${builder_args}
