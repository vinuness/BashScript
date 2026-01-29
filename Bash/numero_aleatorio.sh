#!/bin/bash

#Numero de 1 a 100
numero=$((RANDOM%100+1))

for ((i = 1; i < 11; i++)); 
do
    echo "Digite o $iº numero: "
    read chute
    if [ "$chute" = "$numero" ]; then
        echo "Parabens, número correto"
        break
    else
        # -gt => greater than
        if [ "$chute" -gt "$numero" ]; then 
            echo "O numero é menor"
        
        # -lt => less than
        else [ "$chute" -lt "$numero" ]
            echo "O numero é maior"
        fi
    fi
done

echo "Numero correto: $numero"
