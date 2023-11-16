if [[ -z "$1" ]]
then
  echo "No commit message provided. Exiting..."
else
  gleam build
  echo "// NOTE: AUTOGENERATED CODE. EDITING WILL HAVE NO EFFECT.\n\n$(cat build/dev/javascript/ryanbrewerdev/ryanbrewerdev.mjs)" > public/main.mjs
  git add .
  git commit -m "$1"
  git pull
  git push
  echo "Success!"
fi