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
  mkdir -p ~/.ssh/ && touch ~/.ssh/known_hosts
  ssh-keyscan "${INPUT_HOSTNAME}" >> ~/.ssh/known_hosts
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
