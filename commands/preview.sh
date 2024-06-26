#!/bin/bash

if lsof -Pi :8085 -sTCP:LISTEN -t >/dev/null ; then
  echo "killing port in prep for server"
  commands/kill-port.sh
fi
gleam build &&
gleam run -m build && # lustre_ssg build step
npx vite build && # this doesn't hang because of vite-plugin-close.ts
( # subshell so we don't *actually* change directories
  cd $(pwd)/dist &&
  ( # subshell so we don't actually change directories
    cd ../ryanbrewerdev_server &&
    gleam run & 
  ) &&
  open http://localhost:8085
)
