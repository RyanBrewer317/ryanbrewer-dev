#!/bin/bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

if lsof -Pi :8085 -sTCP:LISTEN -t >/dev/null ; then
  echo "killing port in prep for server"
  commands/kill-port.sh
fi &&
gleam run && # build step
rm -r dist &&
mkdir dist &&
mkdir dist/priv &&
cp -r arctic_build/* dist &&
rm -r dist/public &&
cp -r public/* dist &&
cp -r build/dev/javascript/* dist/priv &&
rm -r dist/priv/lustre/priv &&
cp style.css dist/ &&
# npx vite build && # this doesn't hang because of vite-plugin-close.ts
( # subshell so we don't *actually* change directories
  cd $(pwd)/dist &&
  ( # subshell so we don't actually change directories
    cd ../ryanbrewerdev_server &&
    gleam run & 
  ) &&
  open http://localhost:8085
)
