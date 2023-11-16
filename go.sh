gleam build
git add .
git commit -m "$1"
git pull
git push
echo "Success!"