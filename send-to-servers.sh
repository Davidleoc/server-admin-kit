#! /bin/bash

lista_servidores="$2"
TIPO="$3"

# Validação da lista de servidores

if [ ! -f "$lista_servidores" ]; then
    echo -e "\e[31m❌\e[0m Arquivo de lista de servidores '$lista_servidores' não encontrado."
    exit 1
fi

while true; do
read -p "Digite o caminho do arquivo que será enviado: " file_envio
        if [ ! -f "$file_envio" ]; then
                echo "O arquivo $file_envio não existe.Abortado."
                exit 1
        fi

                read -p "Caminho do arquivo no servidor destino: " file_destino
while read -r servername;
do
    user="srvlinuxmgmt"
    user_host="$user@$servername"

        if ssh -qno StrictHostKeyChecking=no -tt "$user_host" sudo -n true < /dev/null 2>/dev/null ; then

                echo -e "\e[32m-------------------------------------------------------------------------------------------------\e[0m"
                echo

                if ssh $user_host "[ -f "$file_envio" ]" < /dev/null 2>/dev/null; then
                        echo -e "\e[32m✓\e[0m O "$file_envio" ja existe no servidor "$servername". Nada foi alterado."

                else
                        echo "Enviando "$file_envio" para "$file_destino" no servidor "$servername"."
                        scp -q $file_envio $user_host:$file_destino < /dev/null 2>/dev/null

                        if [ $? -eq 0 ]; then
                                echo -e "\e[32m✓\e[0m Script copiado com sucesso para "$servername"."
                        else
                                echo -e "\e[31m❌\e[0m Falha ao copiar o script para "$servername"."
                        fi
                fi
        fi
done < "$lista_servidores"

        echo
        read -p "Deseja enviar outro arquivo para a mesma lista de servidores? (s/n): " resposta
        [[ "$resposta" =~ ^[sS]$ ]] || break
done
