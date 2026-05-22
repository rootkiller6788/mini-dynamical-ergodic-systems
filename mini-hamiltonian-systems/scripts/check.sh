#!/bin/bash
set -e
echo "Building mini-hamiltonian-systems..."
lake build
echo "Build succeeded."
lake env lean --run Test/Smoke.lean
