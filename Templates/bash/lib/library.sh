#!/usr/bin/env bash

## ---------------------------------------
## 
##   UbioZur / ubiozur.tk
##        https://git.ubiozur.tk
##
## Script name : Library Name
## Description : Library Description
## Dependencies:
## Repository  : https://github.com/UbioZur/templates
## License     : https://github.com/UbioZur/templates/LICENSE
##
## ---------------------------------------

## ---------------------------------------
##   Variables to tweak the lib
## GLOBAL_VARIABLE: Description of a global variable used by the library
##
##   Functions to use the lib
## _lib_init arg    : Description of a function available in the library
## ---------------------------------------

## ---------------------------------------
##   Functions and global variables that should not be used by
## external programs should start with a __ (Double underscore).
## ---------------------------------------

# Avoid lib to be sourced more than once, Rename the Variable to a unique one.
[[ "${__LIBLOADED:-""}" == "yes" ]] && return 0
readonly __LIBLOADED="yes"

# If lib is run and not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This is a helper-script it does not do anything on its own."
    exit 1
fi

# Get the Lib file path and directory, Rename the Variable to a unique one.
readonly __LIB_FILE="$( readlink -f "$BASH_SOURCE" )"
readonly __LIB_DIR="$( dirname "$(readlink -f "${BASH_SOURCE}")" )"

# Set the Global variables to their default if not set
GLOBALVAR="${GLOBALVAR-"default"}"

# Library only global variable
__LIBRARY_GLOBAL="My var"


## ---------------------------------------
##   Usable function by the program
## $1: Argument description  Default: "argdefault"
## Usage: _foobar "arg"
## ---------------------------------------
function _foobar {
    local -r tmp="${1-"argdefault"}"

    # Do something ...
}

## ---------------------------------------
##   Function that should only be used by the library
## INTERNAL function, shouldn't be used outside of the library
## $1: Argument description  Default: "argdefault"
## Usage: __barfoo "arg"
## ---------------------------------------
function __barfoo {
    local -r tmp="${1-"argdefault"}"

    # Do something ...
}
