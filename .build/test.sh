#!/bin/sh
set -e # Error Sensitive Mode, which will break out of the script in case of unexpected errors.
#set noclobber # Noclobber mode which protects accidental file clobbering. Use >| operator to force the file to be overwritten.

args="$@"
echo "Arguments: $args"
SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")
cd "$SCRIPT_PATH/.."

build_path=$(pwd)

printf "Current work directory '$(pwd)'\n"

source ./.env # Get the script variables (Script Scope)

print_help() {
cat <<-HELP
This script will help you to get build applications from github 
into docker containers. You need to provide the following arguments:

  1) --app_name (Required): Application name which will also be the name of the docker container
  2) --app_version (Required): Application version tagged in github
  3) --docker_repository (Required): Docker repository (e.g. repository\app-name)
  4) --docker_distribution (Required): Provide the distribution os (e.g. alpine-3.6)

Example ./test.sh --app_name=mailpile --app_version=1.0.0rc2 --docker_repository=glego --docker_distribution=alpine-3.6
HELP
    exit 0
}

# Parsing Arguments
parse_arguments() {

    while [ "$#" -gt 0 ]; do
    case "$1" in
        --app_name=*)
            app_name="${1#*=}"
            ;;
        --app_version=*)
            app_version="${1#*=}"
            ;;
        --docker_repository=*)
            docker_repository="${1#*=}"
            ;;
        --docker_distribution=*)
            docker_distribution="${1#*=}"
            ;;
        --help) print_help;;
        *)
        >&2 printf "Error: Invalid argument, run --help for valid arguments.\n"
        exit 1
    esac
    shift
    done
}

check_arguments(){

    if [ "$app_name" = "" ];then
        >&2 printf "Error: Please provide a valid app_name.\n"
        exit 1
    else
        app_name=${app_name// /} # Replace all spaces
        app_name=$(echo "$app_name" | awk '{print tolower($0)}') # Set all to lower case
        printf "app_name: $app_name\n"
    fi

    if [ "$app_version" = "" ];then
        >&2 printf "Error: Please provide a valid app_version.\n"
        exit 1
    else
        printf "app_version: $app_version\n"
    fi

    if [ "$docker_repository" = "" ];then
        >&2 printf "Error: Please provide a valid docker_repository.\n"
        exit 1
    else
        printf "docker_repository: $docker_repository\n"
    fi

    if [ "$docker_distribution" = "" ];then
        >&2 printf "Error: Please provide a valid docker_distribution.\n"
        exit 1
    else
        printf "docker_distribution: $docker_distribution\n"
    fi

}

main () {
    parse_arguments $args
    check_arguments
}

main