#!/bin/sh
###
#This script was created to move commits from one repository to another, 
# this situation came up when it was decided to rename the root folder,
# when a rename occurs to the root folder git does not track the history
# as a result all the history is lost. With this script after rename 
# we can move the last 150 commits from old repo to new repo. One caveat is that 
# it will show all the commits were made on the same date.
###
git log -150 --reverse --pretty=format:"%h,%an,%s" > gitHistory.txt
file="gitHistory.txt"
while read -r line; do
  commitNumber="$(echo $line | cut -d ',', -f1)"
  author="$(echo $line | cut -d ',', -f2)"
  commitMessage="$(echo $line | cut -d ',', -f3)"
  if[ "$author" != "xxxxx"];
  then
     echo "checking out commit == $commitNumber $author $commitMessage"
     git checkout $commitNumber
     rm -rf ../../<target repo>
     cp -r <current repo> <target repo>
     cd <target repo>
     git add .
     git commit -m "$commitMessage"
     cd <source branch>
     git checkout "<branchName>"
  fi
done <$file
