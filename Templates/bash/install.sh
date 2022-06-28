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
## Script name : Install Template script
## Description : A skeleton template install script for bash
## Dependencies: loglib.sh, utilslib.sh
## Repository  : https://github.com/UbioZur/templates
## License     : https://github.com/UbioZur/templates/LICENSE
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

# Flag to know if the script run in install or uninstall mode.
UNINSTALL=0
# Flag to know if we stop if user is root
ROOT_OK=0

# Script used variables to save the list of folders created (useful for DRY_RUN)
declare -a _FOLDER_LIST=()

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

    # uninstall the script!
    if [[ $UNINSTALL = 1 ]]; then
        # TODO Uninstalling
        _log sec "Uninstalling..."
        # Remove links
        exit
    fi

    # TODO Installing
    _log sec "Installing..."
    # Create the folders

    # Create links
}

## ---------------------------------------
##   Cleaning up at the script exist (on error or normal)
## Usage: cleanup
## ---------------------------------------
function cleanup {
    trap - SIGINT SIGTERM ERR EXIT
    # TODO script cleanup here (clean temp file etc)
    
    cleanup_folders
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
        $_PROG [-v] [--dry-run] [--no-color] [-q] [-l] [--log-file /path/to/log [--log-append]] [--root-ok] [-u]

Script description here.

Available options:

    -h, --help          FLAG, Print this help and exit
    -v, --verbose       FLAG, Print script debug info
    --dry-run           FLAG, Display the commands the script will run. ( Will create/delete the folders needed to avoid failure)
    --root-ok           FLAG, Allow script to be run as root, usefull for container CI.

Log options:

    --no-color          FLAG, Remove style and colors from output.
    -q, --quiet         FLAG, Non error logs are not output to stderr.
    -l, --log-to-file   FLAG, Write the log to a file (Default: /var/log/$_PROG.log).
    --log-file          PARAM, File to write the log to (Also set the --log-to-file flag).
    --log-append        FLAG, Append the log to the file (Also set the --log-to-file flag).

Install options:

    -u, --uninstall     FLAG, Uninstall the program.

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
            
            # --------------------------
            #   TODO Install flags
            # --------------------------
            -u | --uninstall) UNINSTALL=1 ;;

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

## ---------------------------------------
##   Symlink a directory/file to a destination.
## The function does not create folders! make sure they are created before hand!
## $1: local/repository directory/file source. root is $_SCRIPT_DIR
## $2: Destination directory/file
## Usage: link_create "repo/dir" "dest/dir"
## UTILSLIBDO | LOGLIBDO
## ---------------------------------------
function link_create {
    # Make sure we have the arguments!
    [[ -z "${2-}" ]] && _die "Missing destination argument in call \"link_create ${1-}\"!"
    [[ -z "${1-}" ]] && _die "Missing source argument in call \"link_create\""
    local -r src="$_SCRIPT_DIR/$1"
    local -r dst="$2"
    
    # Check that the source does exist
    if [[ ! -e "$src" ]]; then
        _log fai "'$src' does not exist, cannot create link!"
        return
    fi

    # Check we have write permission on the dest folder!
    local -r dstup="$( dirname "$(readlink -f "$dst")" )"
    if [[ ! -w "$dstup" ]]; then
        _log fai "'$dstup' doesn't have write permission!"
        return
    fi
    
    # Destination does not exist, creating it...
    if [[ ! -e "$dst" ]]; then
        _run "ln -s "$src" "$dst""
        _log suc "'$dst' sym-link created."
        return
    fi
    
    # Check we have write permission on the dst as it exist!
    if [[ ! -w "$dst" ]]; then
        _log fai "'$dst' doesn't have write permission!"
        return
    fi

    # if dest is a softlink recreate it
    if [[ -L "$dst" ]]; then
        _log war "'$dst' sym-link already exist, updating it!"
        _run "unlink "$dst""
        _run "ln -s "$src" "$dst""
        _log suc "'$dst' sym-link updated."
        return
    fi
    
    # if dest is a real directory/file, backup and create symlink
    _log war "'$dst' already exist! Backing it up and recreating it as symlink!"
    _run "mv "$dst" "$dst-$(/usr/bin/date +'%Y%m%d-%H%M').bak""
    _run "ln -s "$src" "$dst""
    _log suc "'$dst' is now a sym-link."
}

## ---------------------------------------
##   Create a symlink for each files inside a directory
## The function does not create folders! make sure they are created before hand!
## $1: local/repository directory source. root is $_SCRIPT_DIR
## $2: Destination directory
## Usage: link_each "repo/dir" "dest/dir"
## UTILSLIBDO | LOGLIBDO
## ---------------------------------------
function link_each {
    # Make sure we have the arguments!
    [[ -z "${2-}" ]] && _die "Missing destination argument in call \"link_each ${1-}\"!"
    [[ -z "${1-}" ]] && _die "Missing source argument in call \"link_each\""
    local -r src="$_SCRIPT_DIR/$1"
    local -r dst="$2"
    
    # make sure the source and destination are directories!
    [[ ! -d "$src" ]] && _die "'$src' is not a directory in \"link_each\""
    if [[ ! -d "$dst" ]]; then
        _log fai "'$dst' is not a directory in \"link_each\""
        return
    fi
    
    # Check we have write permission on the dest folder!
    if [[ ! -w "$dst" ]]; then
        _log fai "'$dst' doesn't have write permission!"
        return
    fi

    _run "cp -rs --remove-destination "$src/." "$dst/""
    _log suc "files from '$src' are sym-linked inside '$dst'."
}

## ---------------------------------------
##   Remove symlink.
## $1: link to remove.
## Usage: link_rm "link"
## UTILSLIBDO | LOGLIBDO
## ---------------------------------------
function link_rm {
    # Make sure we have the arguments!
    [[ -z "${1-}" ]] && _die "Missing argument in call \"link_rm\""
    local -r lnk="$1"

    # Make sure it's an existing path!
    if [[ ! -e "$lnk" ]]; then
        _log fai "'$lnk' does not exist!"
        return
    fi
    
    # Check we have write permission!
    if [[ ! -w "$lnk" ]]; then
        _log fai "'$lnk' doesn't have write permission!"
        return
    fi

    # if lnk is a softlink unlink it
    if [ -L "$lnk" ]; then
        _run "unlink "$lnk""
        _log suc "$lnk unlinked!"
        return
    fi

    # lnk is not a link!
    _log fai "'$lnk' is not a link!"
}

## ---------------------------------------
##   Remove symlink created by link_each.
## $1: folder of target of the links
## $2: folder with the links to remove.
## Usage: link_each_rm "repo/dir" "dest/dir"
## UTILSLIBDO | LOGLIBDO
## ---------------------------------------
function link_each_rm {
    # Make sure we have the arguments!
    [[ -z "${2-}" ]] && _die "Missing destination argument in call \"link_each_rm ${1-}\"!"
    [[ -z "${1-}" ]] && _die "Missing source argument in call \"link_each_rm\""
    local -r src="$_SCRIPT_DIR/$1"
    local -r dst="$2"

    # make sure the source and destination are directories!
    [[ ! -d "$src" ]] && _die "'$src' is not a directory in \"link_each_rm\""
    if [[ ! -d "$dst" ]]; then
        _log fai "'$dst' is not a directory in \"link_each_rm\""
        return
    fi

    # Check we have write permission on the dest folder!
    if [[ ! -w "$dst" ]]; then
        _log fai "'$dst' doesn't have write permission!"
        return
    fi
    
    # Remove the bin folders
    local -r filerm="$(find "$src" -xtype f | sed -e "s#^$src#$dst#")"
    _run "rm -vrf $filerm"
}

## ---------------------------------------
##   Create a folder (and it's parent if needed) and add it to the list.
## The list is important for cleaning up (especially in Dry Run mode)
## $@: list of folders to create
## Usage: create_folder "di1" "dir2"
## UTILSLIBDO
## ---------------------------------------
function create_folder {
    # Make sure we have at least 1 argument!
    [[ $# -eq 0 ]] && die "No arguments passed to \"create_folder\""

    mkdir -p "$@"
    _FOLDER_LIST=( "${_FOLDER_LIST[@]}" "$@" )
}

## ---------------------------------------
##   Clean up the list of folders (if empty) and their parents
## it use the list of folders created by create_folder
## Usage: cleanup_folders
## ---------------------------------------
function cleanup_folders {
    for dir in "${_FOLDER_LIST[@]}"
    do
        [[ -d "$dir" ]] && nofail_rmdir "$dir"
    done
}

## ---------------------------------------
##   Recursively remove empty directories
## No Program fail (no exit code except 0)
## Usage: nofail_rmdir
## ---------------------------------------
function nofail_rmdir {
    rmdir -p --ignore-fail-on-non-empty "$@" || test $? = 1;
}



main "$@"; exit