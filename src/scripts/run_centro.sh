#!/bin/bash

rm ./data/centro/*

for i in ./data/INDICADOR_*.csv; do
	echo "Checking centro $i"
	./scripts/calc_centro.R $i ./data/nortest/nortest_results.csv ${i##*/}
    mv CENTRO_* ./data/centro/
done

echo "Check results at data/centro/"
