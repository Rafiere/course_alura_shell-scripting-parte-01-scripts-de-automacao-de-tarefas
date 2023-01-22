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

varrer_diretorio(){
	cd ~/Downloads/imagens-novos-livros

	for arquivo in *
	do
		if [ -d $arquivo ] then

		else

		fi
	done
}

for arquivo in *
do
	#Se for um diretório, entraremos no diretório e varreremos o conteúdo.
	if [ -d $arquivo ] then
		cd $arquivo
		for conteudo_arquivo in *
	else
		#Se for uma imagem, faremos a conversão da imagem.
	fi
done
```

# AULA 04 - NOMES DOS PROCESSOS

# AULA 05 - SALVANDO PROCESSOS EM ARQUIVOS SEPARADOS
