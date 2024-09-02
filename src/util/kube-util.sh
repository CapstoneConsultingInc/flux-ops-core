#####################################################################
#
#  This script contains kubernetes utility functions. The intent is
#  to "source" this script from other scripts.
#
######################################################################

# Set the kubernetes context for the given cluster
function setKubeCtx() {

    # Docker desktop is useful during development. Setting
    # DOCKER_DESKTOP indicates a development environment is being
    # used and the k8s context needs to be set to "docker-desktop"
    
    if [ -z "$DOCKER_DESKTOP" ]; then
        CLUSTER="$1"
        kubectl config use-context "$CLUSTER"-admin@"$CLUSTER"
    else
        kubectl config use-context docker-desktop
    fi
}
