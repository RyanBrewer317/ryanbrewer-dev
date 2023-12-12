#!/bin/bash
echo "enter a commit message:"
read msg
gleam format
gleam build
gleam run -m build
npx vite build # this doesn't hang because of vite-plugin-close.ts
git add .
git commit -m "$msg"
git pull
git push
# a github action deploys to firebase when commits are pushed
echo "Success!"
