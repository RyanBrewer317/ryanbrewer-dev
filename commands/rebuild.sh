#!/bin/bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

gleam run && # build step
rm -r dist &&
mkdir dist &&
mkdir dist/priv &&
cp -r arctic_build/* dist &&
rm -r dist/public &&
cp -r public/* dist &&
cp -r build/dev/javascript/* dist/priv &&
rm -r dist/priv/lustre/priv &&
cp style.css dist/