#!/bin/bash
echo 2 > /sys/class/gpio/export      #GPIO2の解放

lp=10
gpstat=0

gpio -g mode 19 in

for((i=0;i<$lp;i));do

    gpstat=`gpio -g read 19`

    if [ $gpstat = 1 ]; then
        
        mpg321 -g 50 /home/pi/音楽/ファミマ.mp3  #お好きな音楽に変えて下さい 
        
        ACCESS_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        MSG='受付に人が来ました。対応お願いします(_ _)'
        curl -sS -X POST -H "Authorization: Bearer $ACCESS_TOKEN" -F "message=$MSG" https://notify-api.line.me/api/notify

        
        echo out > /sys/class/gpio/gpio2/direction      #出力方向に切り替え
        for count in {0..10};      #10回繰り返す
        do      #ここから
        echo 1 > /sys/class/gpio/gpio2/value      #LEDを光らせる
        sleep 0.2
        echo 0 > /sys/class/gpio/gpio2/value      #LEDを消す
        sleep 0.2
        done      #ここまで
        
    fi

    sleep 0.1 

done
echo 2 > /sys/class/gpio/unexport      #GPIO2の解放をやめる
