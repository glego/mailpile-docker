#!/bin/sh
set -e # Error Sensitive Mode, which will break out of the script in case of unexpected errors.
#set noclobber # Noclobber mode which protects accidental file clobbering. Use >| operator to force the file to be overwritten.

args="$@" # Catch all arguments
printf "Script arguments: $args \n" 

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
  3) --app_distribution (Required): Provide the distribution os (e.g. alpine-3.6)
  4) --docker_repository (Required): Docker repository (e.g. repository\app-name)


Example ./build.sh --app_name=mailpile --app_version=1.0.0rc2 --app_distribution=alpine-3.6 --docker_repository=glego 
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
        --docker_no_cache=*)
            docker_no_cache="--no-cache"
            ;;
        --app_distribution=*)
            app_distribution="${1#*=}"
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

    if [ "$app_distribution" = "" ];then
        >&2 printf "Error: Please provide a valid app_distribution.\n"
        exit 1
    else
        printf "app_distribution: $app_distribution\n"
    fi

}


get_cpu_architecture()
{
    # Get CPU Architecture
    build_architecture=$(lscpu | grep "Architecture" | awk '{print $2}')
    echo "Architecture: $build_architecture"

    if [ "$build_architecture" = "armv7l" ];then
        app_distribution_arch="arm32v6"
        docker_tag_version="$arch-$app_version"
        docker_tag_latest="$arch-latest"
    elif [ "$build_architecture" = "x86_64" ];then
        app_distribution_arch="x86_64"
        docker_tag_version="$app_version"
        docker_tag_latest="latest"
    else
       >&2 printf "Error: '$build_architecture' does not match any valid architecture...\n"
        exit 1
    fi
}

check_lscpu() {
    printf "Checking if lscpu is installed... \n"

    build_os_release_id=$(grep '^ID=.*' /etc/os-release | awk -F\= {'print $2'})
    if [ "$build_os_release_id" == "alpine" ]; then
        printf "Installing util-linux for alpine... \n"
        apk update && \
            apk add --no-cache \
            util-linux
    fi

    printf "Testing lscpu... \n"
    lscpu >/dev/null 2>&1 || { >&2 printf "lscpu is required but it's not installed.\n"; exit 1; }
}

print_build_banner(){
    printf "                                \n"
    printf "********************************\n"
    printf "Building App: $1 \n"
    printf "Repository: $docker_repository \n"
    printf "Distribution: $app_distribution \n"
    printf "Architecture: $app_distribution_arch \n" 
    printf "Version: $app_version \n"
    printf "Tag Version: $docker_tag_version \n" 
    printf "Tag Latest: $docker_tag_latest \n"
    printf "********************************\n"
    printf "                                \n"
}

build()
{
    print_build_banner "$app_name"

    cd "$build_path"
    docker build $docker_no_cache \
        -t $docker_repository/$app_name:$docker_tag_version \
        -t $docker_repository/$app_name:$docker_tag_latest \
        --build-arg APP_NAME=$app_name \
        --build-arg APP_VERSION=$app_version \
        -f ./dockerfiles/$app_distribution/$app_distribution_arch/Dockerfile .
}

main()
{
    parse_arguments $args   # Parse all arguments
    check_arguments         # Check if the argument values are correct 
    check_lscpu             # Check if lscpu is installed (required for get_cpu_architecture)
    get_cpu_architecture    # Get the cpu architure to prepare build
    build                   # Start building docker image
}

main