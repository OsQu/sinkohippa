find ./test -name "*.coffee" | xargs fswatch -0 | while read -d "" file
do
  npm test -- $file
done
