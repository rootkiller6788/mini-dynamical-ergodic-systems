#!/bin/bash
set -e
echo "Building mini-complex-dynamics..."
lake build
echo "Build succeeded."
lake env lean --run Test/Smoke.lean
