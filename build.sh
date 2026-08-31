#!/bin/bash
# Build script for the MFR gamemode (Linux).
# Downloads the community Pawn compiler on first run, then compiles nmss.pwn.
#
# On Windows simply use pawncc.exe 3.10.10 from
# https://github.com/pawn-lang/compiler/releases with the same flags:
#   pawncc nmss.pwn -iinclude "-;+" "-(+" -d0
set -e
cd "$(dirname "$0")"

COMPILER_DIR="pawnc-3.10.10-linux"
if [ ! -x "$COMPILER_DIR/bin/pawncc" ]; then
    echo ">> Downloading Pawn compiler 3.10.10..."
    curl -sL -o pawnc.tar.gz https://github.com/pawn-lang/compiler/releases/download/v3.10.10/pawnc-3.10.10-linux.tar.gz
    tar xzf pawnc.tar.gz && rm pawnc.tar.gz
    echo ">> NOTE: the compiler is a 32-bit binary; on 64-bit Debian/Ubuntu run:"
    echo "     sudo dpkg --add-architecture i386 && sudo apt-get update && sudo apt-get install libc6:i386"
fi

# The source includes files as <YSI\foreach_new> (backslash). Windows resolves
# that to include/YSI/ automatically; on Linux we mirror them as literal
# backslash-named files.
for n in foreach_new y_va y_scripting y_bit; do
    [ -f "include/YSI\\$n.inc" ] || printf '#include "YSI/%s.inc"\n' "$n" > "include/YSI\\$n.inc"
done

export LD_LIBRARY_PATH="$PWD/$COMPILER_DIR/lib"
"$COMPILER_DIR/bin/pawncc" nmss.pwn -iinclude '-;+' '-(+' -d0 "$@"
ls -la nmss.amx
