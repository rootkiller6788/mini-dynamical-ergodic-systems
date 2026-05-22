#!/bin/bash
set -e
echo "Building mini-ergodic-theory..."
lake build
echo "Build succeeded."
lake env lean --run Test/Smoke.lean
