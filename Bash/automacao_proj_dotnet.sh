#!/bin/bash

verificar_comando(){
    if command -v "$1" &> /dev/null # se o comando estiver instalado irá jogar o resultado para o /dev/null
    then
        echo "$1 está instalado."
        return 0
    else
        echo "$1 não está instalado. Por favor, instale-o antes de continuar."
        return 1
    fi
}

if verificar_comando dotnet
then
    dotnet --version
    echo "==================.NET instalado.==================="
    echo ""
    echo "Digite o nome do projeto: "
    read nome_projeto
    mkdir "$nome_projeto"
    cd "$nome_projeto"

    dotnet new webapi --use-controllers -o "$nome_projeto".API
    dotnet new console -n "$nome_projeto".Domain
    dotnet new console -n "$nome_projeto".Application
    dotnet new console -n "$nome_projeto".Infrastructure

    cd "$nome_projeto".API
    dotnet add reference ../"$nome_projeto".Domain/"$nome_projeto".Domain.csproj  
    dotnet add reference ../"$nome_projeto".Application/"$nome_projeto".Application.csproj
    dotnet add reference ../"$nome_projeto".Infrastructure/"$nome_projeto".Infrastructure.csproj

    cd "../$nome_projeto".Application
    dotnet add reference ../"$nome_projeto".Domain/"$nome_projeto".Domain.csproj  
    dotnet add reference ../"$nome_projeto".Infrastructure/"$nome_projeto".Infrastructure.csproj

    cd "../$nome_projeto".Infrastructure
    dotnet add reference ../"$nome_projeto".Domain/"$nome_projeto".Domain.csproj
else
    echo "==================.NET não instalado.==================="
    echo "Iniciando instalação....."
    echo ""
    curl -4 -fsSL https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.425/dotnet-sdk-8.0.425-linux-x64.tar.gz -o /tmp/dotnet-sdk.tar.gz && sudo mkdir -p /usr/share/dotnet && sudo tar -xzf /tmp/dotnet-sdk.tar.gz -C /usr/share/dotnet && sudo ln -sf /usr/share/dotnet/dotnet /usr/bin/dotnet && rm /tmp/dotnet-sdk.tar.gz && dotnet --version
    exit 1
fi
