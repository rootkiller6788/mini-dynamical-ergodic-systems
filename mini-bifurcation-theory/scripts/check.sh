#!/bin/bash
set -e
echo "Building mini-bifurcation-theory..."
lake build
echo "Build succeeded."
lake env lean --run Test/Smoke.lean
