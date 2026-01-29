#!/bin/bash

numero="2"

for ((i = 1; i < 11; i++)); 
do
    echo "Digite o $iº numero: "
    read chute
    if [ "$chute" = "$numero" ]; then
        echo "Parabens, número correto"
        break
    else
        echo "Número errado"
    fi
done