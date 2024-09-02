# Number of calls to set kube ctx
numSetKubeCtxCalls=0

function setKubeCtx() {
    ((++numSetKubeCtxCalls))
    echo $numSetKubeCtxCalls > /tmp/numSetKubeCtxCalls.txt
}

function assertIDeleteTest() {
    # A text file is used because this file is sourced at 2 levels in the call stack. Once in the test, and once in the called function.
    # This caused the environment variables tracking the calls to be defined in different scopes. The text file provides a mechanism
    # for the calls to be tracked.

    actualNumSetKubeCtxCalls=$(</tmp/numSetKubeCtxCalls.txt)

    assert [ "$actualNumSetKubeCtxCalls" -eq 1 ]
}