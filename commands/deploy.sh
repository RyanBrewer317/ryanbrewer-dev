#!/bin/bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

echo "enter a commit message:" &&
read msg &&
gleam format &&
gleam run # build step
rm -r dist &&
mkdir dist &&
mkdir dist/priv &&
cp -r arctic_build/* dist &&
rm -r dist/public &&
cp -r arctic_build/public/* dist &&
cp -r build/dev/javascript/* dist/priv &&
rm -r dist/priv/lustre/priv &&
cp style.css dist/ &&
# npx vite build && # this doesn't hang because of vite-plugin-close.ts
git add . &&
git commit -m "$msg" &&
git pull &&
git push &&
# a github action deploys to firebase when commits are pushed
echo "Success!"
