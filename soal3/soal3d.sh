#!/bin/bash

password=$(date +'%m%d%Y')

cd ~/Downloads/soal-shift-sisop-modul-1-A02-2021/soal3res || exit

for file in $(ls)
do
zip -r -P "$password" Koleksi.zip $file;
rm -rf $file
done
