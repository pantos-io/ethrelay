#!/bin/sh

if [[ -z "${GOETHRELAY}" ]]; then
  echo "Warning: environment variable GOETHRELAY not set."
  echo "    e.g., 'export GOETHRELAY=~/code/../go-ethrelay'"
  exit 0
fi

EXPORT_PATH=${GOETHRELAY:-${GOPATH}/src/github.com/pantos-io/go-ethrelay}
echo "Exporting into ${EXPORT_PATH}..."

# Create ABI file
solc --abi contracts/Ethash.sol --overwrite -o ./abi --allow-paths *,
solc --bin contracts/Ethash.sol --overwrite -o ./bin --allow-paths *,
solc --abi contracts/Testimonium.sol --overwrite -o ./abi --allow-paths *,
solc --bin contracts/Testimonium.sol --overwrite -o ./bin --allow-paths *,

# Generate Go file and export to go-ethrelay project
abigen --bin=bin/Ethash.bin --abi=abi/Ethash.abi --pkg=ethash --out=${EXPORT_PATH}/ethereum/ethash/EthashContract.go
abigen --bin=bin/Testimonium.bin --abi=abi/Testimonium.abi --pkg=testimonium --out=${EXPORT_PATH}/testimonium/TestimoniumContract.go

