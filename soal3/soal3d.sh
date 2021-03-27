#!/bin/bash

password=$(date +'%m%d%Y')

cd ~/Downloads/soal-shift-sisop-modul-1-A02-2021/soal3res || exit

for i in ./*
do
    echo "$i"
    zip -r -P "$password" Koleksi.zip . -i "$i"
    rm -rf "$i"
done
