#!/bin/bash
set -e
echo "Building mini-stability-theory..."
lake build
echo "Build succeeded."
lake env lean --run Test/Smoke.lean
