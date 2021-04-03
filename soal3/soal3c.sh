#!/bin/bash
if [[ ! -d ~/Downloads/soal-shift-sisop-modul-1-A02-2021 ]]
then
    mkdir ~/Downloads/soal-shift-sisop-modul-1-A02-2021
    if [[ ! -d ~/Downloads/soal-shift-sisop-modul-1-A02-2021/soal3res ]]
    then
        mkdir ~/Downloads/soal-shift-sisop-modul-1-A02-2021/soal3res
    fi
fi

cd ~/Downloads/soal-shift-sisop-modul-1-A02-2021/soal3res || exit

downloadImage() {
    if [[ $(grep -c "$web$loc" ./$folder/Foto.log) -gt 1 ]]
    then
        # echo "SAMA"
        counter=$((counter-1))
    else
        wget -o - "$web$loc" -P "$folder" > webLog.log
    fi
}

downloadKitten() {
    counter=0
    for ((i=1; i<=23; i=i+1))
    do
        web="https://loremflickr.com"
        toDownload=$(curl -s -i https://loremflickr.com/320/240/kitten)
        loc=$(echo "$toDownload" | grep "location" | grep -oP "/cache.*" | tr -d $'\r')
        filename=$(echo "$toDownload" | grep "location" | grep -oP "/resized/\K.*" | tr -d $'\r')

        if [[ $i -eq 0 ]]
        then
            echo "$web$loc" > ./$folder/Foto.log
            downloadImage
        else
            echo "$web$loc" >> ./$folder/Foto.log
            downloadImage
        fi

        echo "$counter"
        if [[ $counter -lt 10 ]]
        then
            mv "./$folder/$filename" "./$folder/Koleksi_0$counter.JPG"
        else
            mv "./$folder/$filename" "./$folder/Koleksi_$counter.JPG"
        fi

        counter=$((counter+1))
    done    
}

downloadBunny() {
    counter=0
    for ((i=1; i<=23; i=i+1))
    do
        web="https://loremflickr.com"
        toDownload=$(curl -s -i https://loremflickr.com/320/240/bunny)
        loc=$(echo "$toDownload" | grep "location" | grep -oP "/cache.*" | tr -d $'\r')
        filename=$(echo "$toDownload" | grep "location" | grep -oP "/resized/\K.*" | tr -d $'\r')

        if [[ $i -eq 0 ]]
        then
            echo "$web$loc" > ./$folder/Foto.log
            downloadImage
        else
            echo "$web$loc" >> ./$folder/Foto.log
            downloadImage
        fi

        echo "$counter"
        if [[ $counter -lt 10 ]]
        then
            mv "./$folder/$filename" "./$folder/Koleksi_0$counter.JPG"
        else
            mv "./$folder/$filename" "./$folder/Koleksi_$counter.JPG"
        fi

        counter=$((counter+1))
    done    
}


currentDate=$(date +"%d-%m-%Y")
yesterDate=$(date -d "yesterday" +"%d-%m-%Y")

echo "$currentDate","$yesterDate"

if [[ $(ls -l | grep "$yesterDate" | grep -c "Kelinci") -eq 1 ]]
then
    if [[ ! -d "Kucing_$currentDate" ]]
    then
        mkdir "Kucing_$currentDate"
        folder="Kucing_$currentDate"
        downloadKitten
    fi
else
    if [[ ! -d "Kelinci_$currentDate" ]]
    then
        mkdir "Kelinci_$currentDate"
        folder="Kelinci_$currentDate"
        downloadBunny
    fi
fi