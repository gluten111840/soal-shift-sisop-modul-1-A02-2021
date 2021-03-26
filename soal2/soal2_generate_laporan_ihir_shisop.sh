#!/bin/bash

awk -F '\t' '
BEGIN{
    cons = 0;
    hom = 0;
    corp = 0;
    profC = 0;
    profW = 0;
    profS = 0;
    profE = 0;
}

(NR>1){
    rowId = $1;
    orderDate = $3;
    cusName = $7;
    segment = $8;
    city = $10;
    region = $13;
    sales = $18;
    profit = $21;
    
    # 2 a
    profitPercentage=profit/(sales-profit)*100;
    if(profitPercentage >= maxProfit)
    {
        maxId = rowId;
        maxProfit = profitPercentage;
    }

    # printf "%s %f\n",rowId,profitPercentage;

    # 2 b
    if(city == "Albuquerque" && substr($3,7) == "17")
    {
        datCus[cusName]=1;
    }

    # 2 c
    if(segment == "Consumer")
    {
        cons++;
    }
    else if(segment == "Home Office")
    {
        hom++;
    }
    else if(segment == "Corporate")
    {
        corp++;
    }

    # 2 d
    if(region == "Central")
    {
        profC += profit;
    }
    else if(region == "West")
    {
        profW += profit;
    }
    else if(region == "South")
    {
        profS += profit;
    }
    else if(region == "East")
    {
        profE += profit;
    }
}

END{
    # 2 e
    printf "Transaksi terakhir dengan profit percentage terbesar yaitu " maxId " dengan persentase "maxProfit"%.\n";
    printf "Daftar nama customer di Albuquerque pada tahun 2017 antara lain:\n";
    for(i in datCus)
    {
        printf "%s\n",i;
    }
    # 2 c (lanj.)
    if(cons > hom)
    {
        minSeg = hom;
        segCusMin = "Home Office";
    }
    else if(hom > corp)
    {
        minSeg = corp;
        segCusMin = "Corporate";
    }
    else if(corp > cons)
    {
        minSeg = cons;
        segCusMin = "Consumer";
    }
    
    printf "Tipe segmen customer yang penjualannya paling sedikit adalah " segCusMin " dengan " minSeg " transaksi.\n";

    if(profC < profW)
    {
        regMin = profC;
        regName = "Central";
    }

    else if(profW < profS)
    {
        regMin = profW;
        regName = "West";
    }

    else if(profS < profE)
    {
        regMin = profS;
        regName = "South";
    }

    else if(profE < profC)
    {
        regMin = profE;
        regName = "East";
    }

    printf "Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah " regName " dengan total keuntungan " regMin "\n";
}
' Laporan-TokoShiSop.tsv > hasil.txt