#!/bin/bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";

if [[ :$PATH: != *:"$SCRIPT_DIR":* ]] ; then
    export PATH=$PATH:"$SCRIPT_DIR/bin"
    . "$SCRIPT_DIR/bin/vm-lib.sh"
fi