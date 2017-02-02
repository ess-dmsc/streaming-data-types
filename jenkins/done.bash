#!/bin/bash

function errmsg()
{
  echo "  error:"$1
}

FBSRC=schemas
FBFILES=$(find $FBSRC -name "*.fbs")
NBFILES=$(find $FBSRC -type f | wc -l)
NBFBFILES=$(find $FBSRC -name "*.fbs" | wc -l)

echo "Checking for non schema files"
if [[ $NBFILES != $NBFBFILES ]]; then
  errmsg "Illegal files in schema dir"
fi
echo

echo "Checking for illegal filenames"
for file in $FBFILES
do
  grep "-" $file &>/dev/null || errmsg "Invalid filename $file"
done
echo

echo "Checking that schemas compile"
for file in $FBFILES
do
  flatc $file &>/dev/null || errmsg "Schema $file does not compile"
done
echo

echo "Checking for doxygen comments"
for file in $FBFILES
do
  grep "@file" $file &>/dev/null || errmsg "No doxygen comment in $file"
done
echo

echo "Checking for copyright message"
for file in $FBFILES
do
  head -n 1 $file | grep -i "copyright" &>/dev/null || errmsg "No Copyright notice in $file"
done
