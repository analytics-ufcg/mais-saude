#!/bin/bash

rm ../data/tabelas/*

for i in ../data/INDICADOR_*.csv; do
	echo "Checking $i"

    if [ -e ../data/tabelas/indicadores.csv ]; then
        ./join_indicadores.R ../data/tabelas/indicadores.csv $i
    else
        cp $i ../data/tabelas/indicadores.csv
    fi
done

echo "indicadores condensados"

for i in ../data/faixas/DESVIOS_*.csv; do
    echo "Checking $i"

    if [ -e ../data/tabelas/desvios.csv ]; then
        ./join_desvios.R ../data/tabelas/desvios.csv $i
    else
        cp $i ../data/tabelas/desvios.csv
    fi
done


echo "Check results at data/tabelas/"


