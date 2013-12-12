#!/bin/bash

rm ../data/faixas/*

for i in ../data/INDICADOR_*.csv; do
	echo "Checking $i"
	./calc_faixas.R $i ../data/nortest/nortest_results.csv ${i##*/}
    mv DESVIOS* ../data/faixas/
done

echo "Check results at data/faixas/"
