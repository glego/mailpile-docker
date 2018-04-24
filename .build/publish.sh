
#to-do
check_arguments(){

    if [ "$DOCKER_USERNAME" = "" ];then
        echo "ERROR: Please provide a valid docker username."
        exit 1
    fi

    if [ "$DOCKER_PASSWORD" = "" ];then
        echo "ERROR: Please provide a valid docker password."
        exit 1
    fi
}
