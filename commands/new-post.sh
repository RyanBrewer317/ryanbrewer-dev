echo "Enter name:"
read name
echo "Enter id:"
read id
draft_filename="$HOME/Documents/ryanbrewer-dev/drafts/$id.txt"
prod_filename="$HOME/Documents/ryanbrewer-dev/posts/$id.txt"
if test -f $draft_filename;
then
  echo "That id is in use already!"
else
  if test -f $prod_filename;
  then
    echo "That id is in use already!"
  else
    IFS='' read -r -d '' String <<EOF
id: $id
name: $name
date: $(date +'%Y-%m-%d')
tags: 
description: 

@paragraph@
Hello world!
@end@
EOF
    touch $draft_filename
    echo "${String}" >> $draft_filename
  fi
fi