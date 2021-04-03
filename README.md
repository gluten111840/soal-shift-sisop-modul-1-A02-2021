# Soal Shift Modul 1 Kelompok A02 2021

Nama Anggota Kelompok :
1. Bayu Eka Prawira         (05111940000042)
2. Putu Ananda Satria Adi   (05111940000113)
3. Izzulhaq Fawwaz Syauqiy  (05111840000023)

## Soal 1
### Narasi Soal
Ryujin baru saja diterima sebagai IT support di perusahaan Bukapedia. Dia diberikan tugas untuk membuat laporan harian untuk aplikasi internal perusahaan, *ticky*. Terdapat 2 laporan yang harus dia buat, yaitu laporan **daftar peringkat pesan error** terbanyak yang dibuat oleh *ticky* dan laporan **penggunaan user** pada aplikasi *ticky*. Untuk membuat laporan tersebut, Ryujin harus melakukan beberapa hal berikut:


### 1a
**Soal**  
Mengumpulkan informasi dari log aplikasi yang terdapat pada file `syslog.log`. Informasi yang diperlukan antara lain: jenis log (ERROR/INFO), pesan log, dan username pada setiap baris lognya. Karena Ryujin merasa kesulitan jika harus memeriksa satu per satu baris secara manual, dia menggunakan regex untuk mempermudah pekerjaannya. Bantulah Ryujin membuat regex tersebut.  
  
**Jawab**  
Pada soal ini diminta untuk menampilkan jenis log (ERROR/INFO), pesan log, dan username pada setiap baris log. Berikut adalah baris kode untuk dapat menampilkan log sesuai permintaan soal:
```Shell
grep -oE '(INFO\s.*)|(ERROR\s.*)' syslog.log
```
Penjelasan:
- Command `grep` digunakan untuk mencari teks dengan regex yang sudah ditentukan.
  - Option `-o` berfungsi untuk hanya menampilkan teks sesuai dengan regex.
  - Option `-E` menginterpretasi argumen selanjutnya sebagai Extended Regular Expressions (EREs).
- Regex yang digunakan adalah `'(INFO\s.*)|(ERROR\s.*)'` untuk dapat mendapatkan hasil sesuai dengan permintaan soal.
  - Dalam regex ini terdapat operator | (OR) untuk memilih regex mana yang sesuai dengan baris tersebut. Untuk kasus ini ada `(INFO\s.*)` dan `(ERROR\s.*)`
  - Secara umum pola yang digunakan adalah `(<teks>.*)`, dimana \<teks\> merupakan teks yang dicari, dan `.*` digunakan untuk *match* semua huruf dibelakang pola teks.

Ketika command diatas dijalankan, berikut adalah output yang dihasilkan:
![Hasil 1a]()  

### 1b
**Soal**  
Kemudian, Ryujin harus menampilkan semua pesan error yang muncul beserta jumlah kemunculannya.  
  
**Jawab**  
Pada soal ini saya sendiri (Ananda) sedikit bingung permintaan soal, apakah diminta jumlah ERROR yang muncul atau jumlah setiap pesan ERROR yang muncul. Karena saat pertama membaca soal yang muncul dibenak saya untuk menghitung jumlah ERROR yang muncul, maka implementasinya adalah sebagai berikut:
```Shell
grep -oE 'ERROR.*' syslog.log
echo Total Error Count = $(grep -cE "ERROR" syslog.log)
```

Penjelasan:
- Baris pertama dari potongan kode diatas mirip dengan soal 1a, untuk menampilkan semua pesan ERROR dalam `syslog.log`
- Untuk baris kedua menampilkan jumlah ERROR yang muncul dalam `syslog.log`
  - Pada bagian kanan terdapat command `grep` dengan regex "ERROR"
  - Menggunakan option `-c` untuk menampilkan jumlah kata yang *match* dengan regex diatas
  
Ketika command diatas dijalankan, berikut adalah output yang dihasilkan:
![Hasil 1b]()  

### 1c
**Soal**  
Ryujin juga harus dapat menampilkan jumlah kemunculan log ERROR dan INFO untuk setiap user-nya.  
  
**Jawab**  
Pada soal ini diminta untuk menampilkan jumlah kemunculan log ERROR dan INFO dari setiap user yang ada pada `syslog.log`. Implementasi dari kami adalah sebagai berikut:

```Shell
usernames=$(grep -oE '(\(.*\))' syslog.log)
echo "$usernames" | tr -d ')' | tr -d '(' | sort | uniq |
    while read -r user
    do
        userError=0
        userInfo=0
        for msg in $(grep -wh "$user" syslog.log)
        do
            if [ "$msg" = "ERROR" ]
            then
                userError=$((userError+1))
            fi
            if [ "$msg" = "INFO" ]
            then
                userInfo=$((userInfo+1))
            fi
        done
        echo $user,$userError,$userInfo
    done
```

Penjelasan:
- Pada baris pertama hasil dari `grep -oE '(\(.*\))' syslog.log` dimasukkan kedalam variabel *`usernames`*.
- Variabel *`usernames`* di-*echo* kemudian di-*pipe* dalam beberapa command.
  - Command `tr -d ')'` dan `tr -d '('` berguna untuk menghapus kurung yang masih terdapat dalam variabel *`usernames`*
  - Kemudian dilakukan `sort` dan `uniq` untuk mendapatkan hasil yang sorted dan uniq untuk setiap user.
  - Digunakan `while read` loop untuk membaca setiap line dari command sebelumnya.
  - Dilakukan `grep` dengan option `-wh` untuk mengambil baris yang sesuai dengan nama *`username`* yang sedang dicari.
  - Dilanjutkan dengan `for` loop hasil dari `grep` diatas, lalu dicek apakah *`msg`* tersebut mengandung ERROR atau INFO. Jumlah kemunculan ERROR dan INFO dimasukkan kedalam variabel.
  - Terakhir, jika loop sudah selesai maka hasil akan di-*echo* dengan format `$user, $userError, $userInfo` sesuai dengan permintaan soal.

Ketika command diatas dijalankan, berikut adalah output yang dihasilkan:
![Hasil 1c]()  

### 1d
**Soal**  
Semua informasi yang didapatkan pada poin **b** dituliskan ke dalam `file error_message.csv` dengan header **Error,Count** yang kemudian diikuti oleh daftar pesan error dan jumlah kemunculannya **diurutkan** berdasarkan jumlah kemunculan pesan error dari yang terbanyak.  
Contoh:
```
Error,Count
Permission denied,5
File not found,3
Failed to connect to DB,2
```  
  
**Jawab**  
Pada soal ini diminta hasil dari soal **b** dimasukkan ke dalam file `error_message.csv` dengan header **Error, Count** yang kemudian **diurutkan** berdasarkan kemunculan pesan error dari yang terbanyak. Berhubung implementasi kami dari soal **b** belum sesuai dengan permintaan pada soal **d** ini, berikut adalah implementasi kami untuk soal **d**:
```Shell
echo "Error","Count" > error_message.csv
errMessages=$(grep -oE 'ERROR.*' syslog.log)
echo "$errMessages" | grep -oP "(?<=ERROR\s).*(?=\()" | sort | uniq |
    while read -r errMsg
    do
        number=$(grep -c "$errMsg" syslog.log)
        errMsg+=','$number
        echo "$errMsg"
    done | sort -rnk 2 -t',' >> error_message.csv
```

Penjelasan:
- Karena soal meminta output dimasukkan kedalam file `error_message.csv` dengan header **Error, Count** maka pada baris pertama diinisialisasi header tersebut kedalam file `error_message.csv` dengan mode *overwrite*.
- Pada baris selanjutnya hasil dari `grep -oE 'ERROR.*' syslog.log` dimasukkan kedalam variabel *`errMessages`*.
- Variabel *`errMessages`* di-*echo* kemudian di-*pipe* kedalam beberapa command.
  - Command pertama adalah `grep -oP "(?<=ERROR\s).*(?=\()"`, pada soal ini saya belajar bagaimana cara menggunakan *lookbehind* dan *lookahead* yang seharusnya bisa diimplementasikan pada soal c diatas untuk menghindari penggunaan `tr -d`.
  - Kemudian di-*pipe* dalam `sort` dan `uniq` untuk mendapatkan output yang *sorted* dan *unique*.
  - Kembali menggunakan `while read` loop untuk membaca setiap line dari hasil *pipe* dan dimasukkan ke variabel *`errMsg`*.
  - Menghitung kemunculan pesan ERROR terkait dengan menggunakan `grep -c "$errMsg" syslog.log` kemudian dimasukkan kedalam variabel *`number`*.
  - Hasil *`number`* di-*concatenate* dalam *`errMsg`* untuk kemudian di-*echo* lalu di-*pipe* dalam `sort -rnk 2 -t','`.
    - Option `-r` digunakan untuk *sort descending*.
    - Option `-n` digunakan untuk *numerical sort*.
    - Option `-k` digunakan untuk menspesifikasikan *key*.
    - Option `-t` digunakan untuk menspesifikasikan *separator* yang digunakan.

Ketika command diatas dijalankan, berikut adalah output yang dihasilkan:
![Hasil 1d]()  

### 1e
**Soal**  
Semua informasi yang didapatkan pada poin **c** dituliskan ke dalam file `user_statistic.csv` dengan header **Username,INFO,ERROR diurutkan** berdasarkan username secara ***ascending***.  
Contoh:
```
Username,INFO,ERROR
kaori02,6,0
kousei01,2,2
ryujin.1203,1,3
```  
  
**Jawab**  
Pada soal ini diminta untuk memasukkan hasil dari poin **c** dituliskan ke dalam file `user_statistic.csv` dengan header **Username,INFO,HEADER diurutkan** berdasarkan username secara **ascending**.
```Shell
echo Username,INFO,ERROR > user_statistic.csv
usernames=$(grep -oE '(\(.*\))' syslog.log)
echo "$usernames" | tr -d ')' | tr -d '(' | sort | uniq |
    while read -r user
    do
        userError=0
        userInfo=0
        for msg in $(grep -wh "$user" syslog.log)
        do
            if [ "$msg" = "ERROR" ]
            then
                userError=$((userError+1))
            fi
            if [ "$msg" = "INFO" ]
            then
                userInfo=$((userInfo+1))
            fi
        done
        echo $user,$userError,$userInfo >> user_statistic.csv
    done
```

Penjelasan:
Untuk dapat menyelesaikan soal 1e ini hanya diperlukan beberapa tambahan kode.
- Pada bagian awal ditambahkan `echo Username,INFO,ERROR > user_statistic.csv` untuk *overwrite* file `user_statistic.csv`
- Pada bagian `echo $user,$userError,$userInfo` ditambahkan ` >> user_statistic.csv` untuk append hasil ke dalam `user_statistic.csv`.

Ketika command diatas dijalankan, berikut adalah output yang dihasilkan:
![Hasil 1e]()  

## Soal 2
### Narasi Soal
Steven dan Manis mendirikan sebuah *startup* bernama “TokoShiSop”. Sedangkan kamu dan Clemong adalah karyawan pertama dari TokoShiSop. Setelah tiga tahun bekerja, Clemong diangkat menjadi manajer penjualan TokoShiSop, sedangkan kamu menjadi kepala gudang yang mengatur keluar masuknya barang.

Tiap tahunnya, TokoShiSop mengadakan Rapat Kerja yang membahas bagaimana hasil penjualan dan strategi kedepannya yang akan diterapkan. Kamu sudah sangat menyiapkan sangat matang untuk raker tahun ini. Tetapi tiba-tiba, Steven, Manis, dan Clemong meminta kamu untuk mencari beberapa kesimpulan dari data penjualan `Laporan-TokoShiSop.tsv`.

### 2a
**Soal**  
Steven ingin mengapresiasi kinerja karyawannya selama ini dengan mengetahui **Row ID** dan ***profit percentage* terbesar** (jika hasil profit *percentage* terbesar lebih dari 1, maka ambil Row ID yang paling besar). Karena kamu bingung, Clemong memberikan definisi dari *profit percentage*, yaitu:

`Profit Percentage = (Profit / Cost Price) 100`

*Cost Price* didapatkan dari pengurangan *Sales* dengan *Profit*. (**Quantity diabaikan**).
  
**Jawab**  


### 2b
**Soal**  
Clemong memiliki rencana promosi di Albuquerque menggunakan metode MLM. Oleh karena itu, Clemong membutuhkan daftar **nama *customer* pada transaksi tahun 2017 di Albuquerque**.
  
**Jawab**  


### 2c
**Soal**  
TokoShiSop berfokus tiga *segment customer*, antara lain: *Home Office*, *Customer*, dan *Corporate*. Clemong ingin meningkatkan penjualan pada *segment customer* yang paling sedikit. Oleh karena itu, Clemong membutuhkan **segment *customer*** dan **jumlah transaksinya yang paling sedikit**.
  
**Jawab**


### 2d
**Soal**  
TokoShiSop membagi wilayah bagian (*region*) penjualan menjadi empat bagian, antara lain: *Central*, *East*, *South*, dan *West*. Manis ingin mencari **wilayah bagian (*region*) yang memiliki total keuntungan (*profit*) paling sedikit** dan **total keuntungan wilayah tersebut**.
  
**Jawab**  


### 2e
**Soal**  
kamu diharapkan bisa membuat sebuah script yang akan menghasilkan file “hasil.txt” yang memiliki format sebagai berikut:

Transaksi terakhir dengan profit percentage terbesar yaitu ***ID Transaksi*** dengan persentase ***Profit Percentage***%.

Daftar nama customer di Albuquerque pada tahun 2017 antara lain:
***Nama Customer1***
***Nama Customer2* dst**

Tipe segmen customer yang penjualannya paling sedikit adalah ***Tipe Segment*** dengan ***Total Transaksi*** transaksi.

Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah ***Nama Region*** dengan total keuntungan ***Total Keuntungan (Profit)***
  
**Jawab**

## Soal 3
### Narasi Soal
Kuuhaku adalah orang yang sangat suka mengoleksi foto-foto digital, namun Kuuhaku juga merupakan seorang yang pemalas sehingga ia tidak ingin repot-repot mencari foto, selain itu ia juga seorang pemalu, sehingga ia tidak ingin ada orang yang melihat koleksinya tersebut, sayangnya ia memiliki teman bernama Steven yang memiliki rasa kepo yang luar biasa. Kuuhaku pun memiliki ide agar Steven tidak bisa melihat koleksinya, serta untuk mempermudah hidupnya, yaitu dengan meminta bantuan kalian. Idenya adalah :

### 3a
**Soal**  
Membuat script untuk **mengunduh** 23 gambar dari `"https://loremflickr.com/320/240/kitten"` serta **menyimpan** log-nya ke file `"Foto.log"`. Karena gambar yang diunduh acak, ada kemungkinan gambar yang sama terunduh lebih dari sekali, oleh karena itu kalian harus **menghapus** gambar yang sama (tidak perlu mengunduh gambar lagi untuk menggantinya). Kemudian **menyimpan** gambar-gambar tersebut dengan nama "Koleksi_XX" dengan nomor yang berurutan **tanpa ada nomor yang hilang** (contoh : Koleksi_01, Koleksi_02, ...)

**Jawab**  


### 3b
**Soal**  
Karena Kuuhaku malas untuk menjalankan script tersebut secara manual, ia juga meminta kalian untuk menjalankan script tersebut **sehari sekali pada jam 8 malam** untuk tanggal-tanggal tertentu setiap bulan, yaitu dari **tanggal 1 tujuh hari sekali** (1,8,...), serta dari **tanggal 2 empat hari sekali** (2,6,...). Supaya lebih rapi, gambar yang telah diunduh beserta **log-nya**, **dipindahkan ke folder** dengan nama **tanggal unduhnya** dengan **format** "DD-MM-YYYY" (contoh : "13-03-2023").


**Jawab**  


### 3c
**Soal**  
Agar kuuhaku tidak bosan dengan gambar anak kucing, ia juga memintamu untuk **mengunduh** gambar kelinci dari `"https://loremflickr.com/320/240/bunny"`. Kuuhaku memintamu **mengunduh** gambar kucing dan kelinci secara **bergantian** (yang pertama bebas. contoh : tanggal 30 kucing > tanggal 31 kelinci > tanggal 1 kucing > ... ). Untuk membedakan folder yang berisi gambar kucing dan gambar kelinci, **nama folder diberi awalan** "Kucing_" atau "Kelinci_" (contoh : "Kucing_13-03-2023")

**Jawab**  


### 3d
**Soal**  
Untuk mengamankan koleksi Foto dari Steven, Kuuhaku memintamu untuk membuat script yang akan **memindahkan seluruh folder ke zip** yang diberi nama “Koleksi.zip” dan **mengunci** zip tersebut dengan **password** berupa tanggal saat ini dengan format "MMDDYYYY" (contoh : “03032003”).


**Jawab**  


### 3e
**Soal**  
Karena kuuhaku hanya bertemu Steven pada saat kuliah saja, yaitu setiap hari kecuali sabtu dan minggu, dari jam 7 pagi sampai 6 sore, ia memintamu untuk membuat koleksinya **ter-zip** saat kuliah saja, selain dari waktu yang disebutkan, ia ingin koleksinya **ter-unzip** dan **tidak ada file zip** sama sekali.


**Jawab**  

