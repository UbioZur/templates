#!/usr/bin/env bash

## ---------------------------------------
##  _   _ _     _        ______
## | | | | |   (_)      |___  /
## | | | | |__  _  ___     / / _   _ _ __
## | | | | '_ \| |/ _ \   / / | | | | '__|
## | |_| | |_) | | (_) |./ /__| |_| | |
##  \___/|_.__/|_|\___/ \_____/\__,_|_|
## 
##   UbioZur / ubiozur.tk
##        https://git.ubiozur.tk
##
## ---------------------------------------

## ---------------------------------------
##
## Script name : Template script
## Description : A skeleton template script for bash
## Dependencies:
## Repository  : https://github.com/UbioZur-Tech/Templates
## License     : https://github.com/UbioZur-Tech/Templates/LICENSE
##
## ---------------------------------------

## ---------------------------------------
##   Fail Fast and cleanup
## E: any trap on ERR is inherited by shell functions, 
##    command substitutions, and commands executed in a subshell environment.
## e: Exit immediately if a pipeline returns a non-zero status.
## u: Treat unset variables and parameters other than the special parameters ‘@’ or ‘*’ 
##    as an error when performing parameter expansion
## o pipefail: If set, the return value of a pipeline is the value of the last (rightmost) 
##             command to exit with a non-zero status, or zero if all commands in the
##             pipeline exit successfully.
## ---------------------------------------
set -Eeuo pipefail
# Set the trap to run the cleanup function.
trap cleanup SIGINT SIGTERM ERR EXIT

# Get the script file path and directory.
readonly _SCRIPT_FILE="$( readlink -f "$BASH_SOURCE" )"
readonly _SCRIPT_DIR="$( dirname "$(readlink -f "${BASH_SOURCE}")" )"

# Get the program name
readonly _PROG="$( basename $0 )"

# Source my loglib library if used (Search for LOGLIBDO in the template)
source "${_SCRIPT_DIR}/lib/loglib.sh"
# Source my utils library if used (Search for UTILSLIBDO in the template)
source "${_SCRIPT_DIR}/lib/utilslib.sh"
# Source my env library if used (Search for ENVLIBDO in the template)
source "${_SCRIPT_DIR}/lib/envlib.sh"

# Flag to know if we stop if user is root
ROOT_OK=0

## ---------------------------------------
##   Script main function
## Usage: main "$@"
## ---------------------------------------
function main {
    # Initialization
    parse_params "$@"
    # LOGLIBDO | Initialize the loglib if it's included!
    _loglib_init

    # Check if user is root or not
    if _is_root; then
        [[ $ROOT_OK = 0 ]] && _die "Script shouldn't be run as root!";
        _log war "You are running the script as root!"
    fi

    # TODO Run your script here
}

## ---------------------------------------
##   Cleaning up at the script exist (on error or normal)
## Usage: cleanup
## ---------------------------------------
function cleanup {
  trap - SIGINT SIGTERM ERR EXIT
  # TODO script cleanup here (clean temp file etc)
}

## ---------------------------------------
##   Display the usage/help for the script
## Usage: usage
## ---------------------------------------
function usage {
    # TODO create your help here
    cat << EOF # remove the space between << and EOF, this is due to web plugin issue
Usage:  $_PROG [-h]
        $_PROG [-v] [--dry-run] [--no-color] [-q] [-l] [--log-file /path/to/log [--log-append]] [--root-ok] arg1

Script description here.

Available options:

    -h, --help          FLAG, Print this help and exit
    -v, --verbose       FLAG, Print script debug info
    --dry-run           FLAG, Display the commands the script will run.
    --root-ok           FLAG, Allow script to be run as root, usefull for container CI.

Log options:

    --no-color          FLAG, Remove style and colors from output.
    -q, --quiet         FLAG, Non error logs are not output to stderr.
    -l, --log-to-file   FLAG, Write the log to a file (Default: /var/log/$_PROG.log).
    --log-file          PARAM, File to write the log to (Also set the --log-to-file flag).
    --log-append        FLAG, Append the log to the file (Also set the --log-to-file flag).

EOF
    exit
}

## ---------------------------------------
##   Parse the script parameters and set the Flags
## Usage: parse_params "$@"
## ---------------------------------------
function parse_params {
    # default values of variables set from params
    flag=0
    param=''

    while :; do
        case "${1-}" in
            # --------------------------
            #   Common Flags
            # --------------------------
            -h | --help) usage ;;
            -v | --verbose) set -x ;;
            --root-ok) ROOT_OK=1 ;;

            # --------------------------
            #   LOGLIBDO Log Library flags
            # --------------------------
            --no-color) NO_COLOR=1 ;;
            -q | --quiet) LOG_QUIET=1 ;;
            -l | --log-to-file) LOG_TO_FILE=1 ;;
            --log-file) LOG_TO_FILE=1
                        LOG_FILE="${2-}"
                        shift ;;
            --log-append) LOG_TO_FILE=1
                          LOG_FILE_APPEND=1 ;;

            # --------------------------
            #   UTILSLIBDO Utils Library flags
            # --------------------------
            --dry-run) DRY_RUN=1 ;;
            
            # TODO Add your flags and parameters here
            -f | --flag) flag=1 ;; # example flag
            -p | --param) # example named parameter
                param="${2-}"
                shift
                ;;
            # UTILSLIBDO die is part of utilslib
            -?*) _die "Unknown option: $1" ;;
            *) break ;;
        esac
        shift
    done

    args=("$@")

    # check required params and arguments
    #[[ -z "${param-}" ]] && die "Missing required parameter: param"
    #[[ ${#args[@]} -eq 0 ]] && die "Missing script arguments"

    return 0
}

main "$@"; exit