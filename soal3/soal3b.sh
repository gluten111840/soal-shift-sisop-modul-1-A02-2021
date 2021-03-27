#!/bin/bash

if [[ ! -d ~/Downloads/soal-shift-sisop-modul-1-A02-2021 ]]
then
    mkdir ~/Downloads/soal-shift-sisop-modul-1-A02-2021
    if [[ ! -d ~/Downloads/soal-shift-sisop-modul-1-A02-2021/soal3res ]]
    then
        mkdir ~/Downloads/soal-shift-sisop-modul-1-A02-2021/soal3res
    fi
fi

if [[ ! -d ~/Downloads/soal-shift-sisop-modul-1-A02-2021/soal3res/$(date +"%d-%m-%Y") ]]
then
    mkdir ~/Downloads/soal-shift-sisop-modul-1-A02-2021/soal3res/$(date +"%d-%m-%Y")
fi

cd ~/Downloads/soal-shift-sisop-modul-1-A02-2021/soal3res/$(date +"%d-%m-%Y") || exit

downloadImage() {
    if [[ $(grep -c "$web$loc" Foto.log) -gt 1 ]]
    then
        counter=$((counter-1))
    else
        wget -o - "$web$loc" > webLog.log
    fi
}

counter=0
for ((i=0; i<23; i=i+1))
do
    web="https://loremflickr.com"
    toDownload=$(curl -s -i https://loremflickr.com/320/240/kitten)
    loc=$(echo "$toDownload" | grep "location" | grep -oP "/cache.*" | tr -d $'\r')
    filename=$(echo "$toDownload" | grep "location" | grep -oP "/resized/\K.*" | tr -d $'\r')

    if [[ $i -eq 0 ]]
    then
        echo "$web$loc" > Foto.log
        downloadImage
    else
        echo "$web$loc" >> Foto.log
        downloadImage
    fi

    echo "$counter"
    if [[ $counter -lt 10 ]]
    then
        mv "$filename" "Koleksi_0$counter.JPG"
    else
        mv "$filename" "Koleksi_$counter.JPG"
    fi

    counter=$((counter+1))
done

