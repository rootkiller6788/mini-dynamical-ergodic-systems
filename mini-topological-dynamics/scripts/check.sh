#!/bin/bash
set -e
echo "Building mini-topological-dynamics..."
lake build
echo "Build succeeded."
lake env lean --run Test/Smoke.lean
