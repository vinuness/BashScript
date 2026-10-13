#!/usr/bin/env bash

COMANDOS=("nvim" "npm" "npx" "node" "gdb" "java" "dotnet" "shellcheck" "shfmt")

cd "$HOME" || exit 1

# Instalar dependências caso necessário
install_comands(){
    case "$1" in
        nvim)
            sudo apt update || return 1
            sudo apt install -y \
                git curl wget ca-certificates \
                build-essential cmake gcc g++ clang clangd clang-format \
                make pkg-config libc6-dev libstdc++-13-dev \
                unzip zip tar gzip ripgrep fd-find \
                xclip wl-clipboard \
                python3 python3-pip python3-venv python3-dev \
                shellcheck shfmt \
                gdb valgrind clang-tidy clang-tools || return 1
            sudo apt install -y default-jdk maven gradle neovim || return 1
            ;;

        npm|npx|node)
            if ! command -v node >/dev/null 2>&1 ||
               ! command -v npm >/dev/null 2>&1 ||
               ! command -v npx >/dev/null 2>&1
            then
                curl -fsSL https://deb.nodesource.com/setup_22.x |
                    sudo -E bash - || return 1

                sudo apt install -y nodejs || return 1
            fi
            ;;

        gdb)
            sudo apt update || return 1
            sudo apt install -y \
                gdb valgrind clang-tidy clang-tools || return 1
            ;;

        java)
            sudo apt update || return 1
            sudo apt install -y default-jdk maven gradle || return 1
            ;;

        dotnet)
            curl -4 -fsSL https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.425/dotnet-sdk-8.0.425-linux-x64.tar.gz \
                -o /tmp/dotnet-sdk.tar.gz || return 1

            sudo mkdir -p /usr/share/dotnet || {
                rm -f /tmp/dotnet-sdk.tar.gz
                return 1
            }

            sudo tar -xzf /tmp/dotnet-sdk.tar.gz \
                -C /usr/share/dotnet || {
                rm -f /tmp/dotnet-sdk.tar.gz
                return 1
            }

            sudo ln -sf /usr/share/dotnet/dotnet /usr/bin/dotnet || {
                rm -f /tmp/dotnet-sdk.tar.gz
                return 1
            }

            rm -f /tmp/dotnet-sdk.tar.gz

            dotnet --version || return 1
            ;;

        shellcheck|shfmt)
            sudo apt update || return 1
            sudo apt install -y shellcheck shfmt || return 1
            ;;

        *)
            echo "Não existe uma instalação configurada para: $1"
            return 1
            ;;
    esac
}

# Verificar se o comando existe
verify_command(){
    local comando="$1"
    local tentativa="${2:-0}"

    if command -v "$comando" >/dev/null 2>&1; then
        echo "$comando está instalado."
        return 0
    fi

    if [ "$tentativa" -ge 1 ]; then
        echo "Falha: $comando continua indisponível após a instalação."
        return 1
    fi

    echo "$comando não está instalado. Tentando instalar..."
    install_comands "$comando" || return 1
    hash -r

    verify_command "$comando" "$((tentativa + 1))"
}

# Verificar todos os comandos
for comando in "${COMANDOS[@]}"; do
    verify_command "$comando" || {
        echo "Falha ao verificar ou instalar: $comando"
        exit 1
    }
done

echo
echo "Verificação concluída."
