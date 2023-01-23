# AULA 01 - MONTANDO-UM-SCRIPT-PARA-CONVERTER-IMAGENS

## INTRODUÇÃO

Nesse curso, criaremos muitos scripts utilizando o Shell Script.

## CONVERTENDO IMAGEM E MONTANDO SCRIPT

Para descompactarmos um arquivo que possui a extensão `.zip`, devemos utilizar o comando `unzip nome-do-arquivo`.

O Ubuntu contém a aplicação `image-magic`, assim, podemos utilizar o comando `convert nome-do-arquivo.jpg nome-do-arquivo.png` para convertermos uma imagem no formato `.jpg` para o formato `.png`.

O `Shell` é a interface que o usuário possui para acessar os recursos do sistema operacional. Com o `Shell Script`, criaremos vários scripts de automatização.

Abaixo, criaremos o código do script para convertermos os arquivos do formato `.jpg` para o formato `png`.

```shell
#convert-jpg-to-png.sh
#!/bin/bash

CAMINHO_IMAGENS=~/Downloads/imagens-livros

for imagem in $@
do
	convert $CAMINHO_IMAGENS/$imagem.jpg $CAMINHO_IMAGENS/$imagem.png
done
```

O `#!/bin/bash` indica qual será o interpretador utilizado para executar esse script.

O `$@` representa **todos** os parâmetros que foram passados pelo usuário, ou seja, uma lista com esses parâmetros.

Para executarmos o script, devemos executar o comando `bash convert-jpg-to-png.sh nome-do-livro-1 nome-do-livro-2`.

# AULA 02 - REALIZANDO A CONVERSÃO EM UM DIRETÓRIO

## CONVERTENDO AUTOMATICAMENTE TODOS OS ARQUIVOS

Nessa aula, vamos aprimorar o script da aula anterior.

```shell
converte_imagem(){
	#O "-d" verifica se o diretório "png" existe. Se não existir, ele será criado.
	if [ ! -d png ]
	then
		mkdir png
	fi

	for imagem in *.jpg
	do
		local IMAGEM_SEM_EXTENSAO = $(ls $imagem | awk -F. '{ print $1 }')
		convert $imagem_sem_extensao.jpg png/$imagem_sem_extensao.png
	done
}

cd ~/Downloads/imagens-livros

converte_imagem 2>erros_conversao.txt

if [ $? -eq 0]
then
	echo "Conversão realizada com sucesso!"
else
	echo "Uma falha ocorreu!"
fi
```

O `AWK` é uma **linguagem de programação** que permite a manipulação de textos através de uma sequência de padrões.

Quando colocamos o `$()`, indicamos que o código que está dentro desse símbolo **deve ser executado**, ao invés de ser, por exemplo, entendido como uma string.

O `ls $imagem` exibe, na saída padrão, o nome do arquivo, assim, estamos enviando esse nome para a entrada padrão do comando `awk -F. '{ print $1 }'`.

O comando `awk -F. '{ print $1 }'` diz que estamos fazendo o "corte" no `.`, assim, se tivermos a string `teste.jpg`, o primeiro campo terá o conteúdo `teste` e o segundo campo terá o conteúdo `jpg`, e o corte foi feito no `.`. Ao utilizarmos o `print $1`, estamos imprimindo o primeiro campo, que é o nome do arquivo.

Quando utilizamos a palavra-chave `local`, estamos dizendo que o conteúdo de uma variável só pode ser acessado dentro do escopo em que ela foi declarada. Caso contrário, haverá um vazamento de escopo e essa variável poderá ser acessada de qualquer lugar do script. Basicamente, por padrão, as variáveis declaradas são globais.

No Linux, quando um comando é executado, ele exibe um status de saída. O status `0` significa que o programa foi executado com sucesso. Os status de saída de erro podem variar de `1` até `255`.

O `$?` está obtendo o status de saída da função `converte_imagem`, ou seja, está obtendo o **status de saída** da função anterior.

O `2>erros_conversao.txt` está redirecionando a saída de erro da função `converte_imagem` para o arquivo `erros_conversao.txt`.

# AULA 03 - CONVERSÃO DE ARQUIVOS EM DIFERENTES DIRETÓRIOS

## IMAGENS ESPALHADAS EM VÁRIOS DIRETÓRIOS

Nessa aula, vamos criar um script semelhante ao anterior, porém, ele converterá as imagens que estejam espalhadas em vários diretórios.

```shell
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
```

# AULA 04 - NOMES DOS PROCESSOS

Existem dez processos que estão alocando muita memória no sistema, dessa forma, devemos criar um script que obtenha os dez processos que estão com mais consumo de data no momento em que o script foi executado.

O script deverá criar **um arquivo para cada processo**, exibindo, dentro do arquivo, as informações no formato abaixo.

`2017-07-21, 15:09:30, 150MB`

No exemplo acima, o primeiro valor é a **data**, o segundo valor é o **horário** e o terceiro valor é a **quantidade de memória** que o processo está executando no momento.

O código do script será inserido abaixo.

```shell
#!/bin/bash

# Estamos obtendo apenas os PIDs dos processos, que estão ordenados pela quantidade de memória alocada.

processos=$(ps -e -o pid --sort -size | head -n 11 | grep [0-9])

for pid in $processos
do
	echo $(ps -p $pid -o comm)
done
```

O comando `ps -e -o pid --sort -size` realiza uma listagem dos `PIDs` dos processos ordenados pela quantidade de memória alocada. Com o `PID` do processo, teremos todas as informações que precisamos.

O comando `head` exibe apenas as dez primeiras linhas de um comando.

# AULA 05 - SALVANDO PROCESSOS EM ARQUIVOS SEPARADOS

Nessa aula, criaremos um arquivo, que possuirá as informações requisitadas na aula passada, para cada processo que estiver na lista dos dez processos que mais estarão consumindo memória quando o script for executado.

```shell
#!/bin/bash

# Se o diretório "log" não existir, ele será criado.
if [ ! -d log ]
then
	mkdir log
fi

processos_memoria(){

	# Estamos obtendo o PIDs dos processos, que estão ordenados pela quantidade de memória alocada.

	processos=$(ps -e -o pid --sort -size | head -n 11 | grep [0-9])

	# Para cada processo, o bloco de código abaixo será executado.

	for pid in $processos
	do

	nome_processo=$(ps -p $pid -o comm | tail -n 1 )
	echo -n $(date +%F,%H:%M:%S, ) >> log/$nome_processo.log

	tamanho_processo=$(ps -p $pid -o size | grep [0-9])

	#Estamos obtendo o tamanho do processo em MB.

	echo "$(bc <<< "scale=2;$tamanho_processo/1024") MB" >> log/$nome_processo.log

	done
}

processos_memoria
if [ $? -eq 0 ]
then
	echo "Os arquivos foram salvos com sucesso!"
else
	echo "Um erro ocorreu!"
fi
```

O comando `date +%F, %H:%M:%S` exibe o dia e o horário em que o comando foi executado.

O comando `bc <<< "scale=2;931348/1024"` realiza a divisão desses dois valores.
