#!/usr/bin/env bash

NOME_PROJETO="csproj"

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

#caso nao exista, ele cria o comando global e adiciona no PATH do bashrc
if ! verificar_comando "$NOME_PROJETO"; then
    chmod +x "$(readlink -f "${BASH_SOURCE[0]}")"
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(readlink -f "${BASH_SOURCE[0]}")" "$HOME/.local/bin/csproj"

    if ! grep -qxF 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    fi

    export PATH="$HOME/.local/bin:$PATH"
    echo "comando adicionado com sucesso!!"
    printf "Abra um novo terminal para utilizar o comando "$NOME_PROJETO" globalmente."
fi

if verificar_comando dotnet
then

    echo "VERSÃO DO .NET: $(dotnet --version)"
    echo "==================.NET instalado.==================="
    echo ""
    echo "Digite o nome do projeto: "
    read nome_projeto
    mkdir "$nome_projeto"
    cd "$nome_projeto"

    #Adicionando projetos
    dotnet new webapi --use-controllers -n "$nome_projeto".API
    dotnet new classlib -n "$nome_projeto".Domain
    dotnet new classlib -n "$nome_projeto".Application
    dotnet new classlib -n "$nome_projeto".Infrastructure

    #Adicionando referências
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

    #instalando o .NET SDK 8.0.425 e configurando o PATH
    curl -4 -fsSL https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.425/dotnet-sdk-8.0.425-linux-x64.tar.gz -o /tmp/dotnet-sdk.tar.gz && sudo mkdir -p /usr/share/dotnet && sudo tar -xzf /tmp/dotnet-sdk.tar.gz -C /usr/share/dotnet && sudo ln -sf /usr/share/dotnet/dotnet /usr/bin/dotnet && rm /tmp/dotnet-sdk.tar.gz && dotnet --version
    exit 1
fi
