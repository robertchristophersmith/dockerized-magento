#!/bin/bash

if [ "$1" == "--help" ]; then
echo "
Usage: docker-cleanup [OPTION] [MATCH]
Cleans docker items at various levels. Only 1 (ONE) option is allowed as they are
mutually exclusive, however the --purge option takes one argument to it, see usage below
DO NOT USE --nuclear unless you are aware of the consequences listed below:
    [no option]         remove all stopped containers and untagged images
    --reset             remove all stopped|running containers and untagged images
    --purge {match}     remove containers|images|tags matching {repository|image|
                           repository\\image|tag|image:tag) pattern and untagged images
    --nuclear           USE WITH EXTREME CAUTION removes/destroys absolutely everything
    --help              displays this help information
"
exit 0
fi

if [ "$1" == "--reset" ]; then
    # Remove all containers regardless of state
    docker rm -vf $(docker ps -a -q) 2>/dev/null || echo "No more containers to remove."
elif [ "$1" == "--purge" ]; then
    # Attempt to remove running containers that are using the images we're trying to purge first.
    (docker rm -vf $(docker ps -a | grep "$2/\|/$2 \| $2 \|:$2\|$2-\|$2:\|$2_" | awk '{print $1}') 2>/dev/null || echo "No containers using the \"$2\" image, continuing purge.") &&\
    # Remove all images matching arg given after "--purge"
    docker rmi $(docker images | grep "$2/\|/$2 \| $2 \|$2 \|$2-\|$2_" | awk '{print $3}') 2>/dev/null || echo "No images matching \"$2\" to purge."
else
    # This alternate only removes "stopped" containers
    docker rm -vf $(docker ps -a | grep "Exited" | awk '{print $1}') 2>/dev/null || echo "No stopped containers to remove."
fi

if [ "$1" == "--nuclear" ]; then
    docker rm -vf $(docker ps -a -q) 2>/dev/null || echo "No more containers to remove."
    docker rmi $(docker images -q) 2>/dev/null || echo "No more images to remove."
else
    # Always remove untagged images
    docker rmi $(docker images | grep "<none>" | awk '{print $3}') 2>/dev/null || echo "No untagged images to delete."
fi

exit 0
