#!/bin/bash

if [[ -z "$1" ]]
then
  echo "No commit message provided. Exiting..."
else
  gleam build
  npx vite build
  git add .
  git commit -m "$1"
  git pull
  git push
  # a github action deploys to firebase when commits are pushed
  echo "Success!"
fi
alias deploy=./go.sh