#!/bin/bash

rm ./data/tabelas/*

for i in ./data/INDICADOR_*.csv; do
	echo "Checking $i"

    if [ -e ./data/tabelas/indicadores.csv ]; then
        ./scripts/join_indicadores.R ./data/tabelas/indicadores.csv $i
    else
        cp $i ./data/tabelas/indicadores.csv
    fi
done

echo "indicadores condensados"

for i in ./data/faixas/DESVIOS_*.csv; do
    echo "Checking $i"

    if [ -e ./data/tabelas/desvios.csv ]; then
        ./scripts/join_desvios.R ./data/tabelas/desvios.csv $i
    else
        cp $i ./data/tabelas/desvios.csv
    fi
done

echo "arquivos de médias/medianas"

for i in ./data/centro/CENTRO_*.csv; do
    echo "Checking $i"

    if [ -e ./data/tabelas/centro.csv ]; then
        ./scripts/join_centro.R ./data/tabelas/centro.csv $i
    else
        cp $i ./data/tabelas/centro.csv
    fi
done

cp ./data/tabelas/*.csv ./data/

echo "Check results at data/tabelas/"


