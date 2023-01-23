#!/bin/bash

converte_imagem(){
    local caminho_imagem=$1
    local imagem_sem_extensao=$(ls $caminho_imagem | awk -F. '{ print $1 }')

    # Estamos realizando a conversão.
    convert $imagem_sem_extensao.jpg $imagem_sem_extensao.png
}

varrer_diretorio(){
    # Estamos entrando no diretório que foi passado como parâmetro.
    cd $1

    local diretorio_raiz="/home/rafael/Desktop/codes/courses/alura/shell-scripting-parte-01-scripts-de-automacao-de-tarefas/convert-jpg-to-png"

    for arquivo in *
    do

        local caminho_arquivo=$(find $diretorio_raiz -name "$arquivo")
        if [ -d $caminho_arquivo ]
        then
            #Se for um diretório, varreremos o conteúdo desse diretório.
            varrer_diretorio $caminho_arquivo
        else
            # Se for uma imagem, faremos a conversão da imagem.
            converte_imagem $caminho_arquivo
        fi
    done
}

# Diretório raiz em que os arquivos estão inseridos.
varrer_diretorio ./imagens-novos-livros

# Estamos verificando o status de saída da função.
if [ $? -eq 0 ]  
then
    echo "Conversão realizada com sucesso!"
else
    echo "Houve um problema na conversão!"
fi