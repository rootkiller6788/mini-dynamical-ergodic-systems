#!/bin/bash
set -e
echo "Building mini-random-dynamical-systems..."
lake build
echo "Build succeeded."
lake env lean --run Test/Smoke.lean
