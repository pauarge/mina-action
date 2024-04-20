#!/bin/sh -l

if [$INPUT_DEBUG]
then
    DEBUG_FLAG="--verbose"
else
    DEBUG_FLAG=""
fi

log() {
  echo ">> [mina-action]" $@
}

minaDeploy() {
  log "Running mina $INPUT_ENVIRONMENT $INPUT_COMMAND $DEBUG_FLAG"
  /usr/local/bundle/bin/mina $INPUT_ENVIRONMENT $INPUT_COMMAND $DEBUG_FLAG
}

configureSSH() {
  log "Configuring SSH."
  eval `ssh-agent -s`
}

cleanup() {
  log "Killing ssh agent."
  ssh-agent -k
}
trap cleanup EXIT

log "Starting mina action."
configureSSH
minaDeploy
