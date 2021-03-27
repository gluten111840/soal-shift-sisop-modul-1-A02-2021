#!/bin/bash

password=$(date +'%m%d%Y')

for i in ./soal3res/* ; 
do
    echo "$i"
    zip -r -P "$password" Koleksi.zip . -i "$i*"
    rm -rf "$i"
done