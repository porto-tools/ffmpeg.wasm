#!/bin/bash

set -euo pipefail

# openh264 builds with its own Makefile (no ./configure). Key flags:
# - USE_ASM=No           : no x86 assembly under WebAssembly.
# - ARCH=x86_32          : matches the 32-bit wasm memory model used by the other libs.
# - -fno-stack-protector : required, or the wasm link fails on an undefined
#                          __stack_chk_guard symbol (emscripten/emscripten#9780).
# - -pthread -msimd128   : added only for the multi-threaded (video) core build.
emmake make \
      install-static \
      OS=linux \
      ARCH=x86_32 \
      USE_ASM=No \
      CC=emcc \
      CXX=em++ \
      AR=emar \
      CFLAGS="$CFLAGS -fno-stack-protector ${FFMPEG_MT:+-pthread -msimd128}" \
      PREFIX=$INSTALL_DIR \
      -j
