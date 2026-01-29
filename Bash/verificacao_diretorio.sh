#!/bin/bash

echo "Digite o Diretorio:"
read d

cd /$d || exit

echo "Diretorio caminhado: $(pwd)"

echo "Tem algum tipo de arquivo especifico que queira buscar? (y/n)"
read option

if [ "${option^^}"  = "Y" ] || [ "${option^^}"  = "YES" ]; then
    echo "Digite o especificador de tipo do arquivo: "
    read arq
    for FILE in *.$arq; 
    do
        echo "Processing file: $FILE"
    done
else
    if [ "${option^^}" = "N" ] || [ "${option^^}"  = "NO" ]; then
        for FILE in *; 
        do
            echo "Processing file: $FILE"
        done  
    else [ "${option^^}" != "YES" ] && [ "${option^^}" != "NO" ] && [ "${option^^}" != "Y" ] && [ "${option^^}" != "N" ]
        echo "Opção inválida"
    fi
fi


