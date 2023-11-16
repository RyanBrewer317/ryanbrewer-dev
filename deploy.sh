#!/bin/bash

if [[ -z "$1" ]]
then
  echo "No commit message provided. Exiting..."
else
  gleam format
  gleam build
  gleam run -m build
  npx vite build # this doesn't hang because of vite-plugin-close.ts
  git add .
  git commit -m "$1"
  git pull
  git push
  # a github action deploys to firebase when commits are pushed
  echo "Success!"
fi
