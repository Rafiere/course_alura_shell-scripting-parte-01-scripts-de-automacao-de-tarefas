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
