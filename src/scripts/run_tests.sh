#!/bin/bash

rm ./data/nortest/*

echo "\"INDICADOR\",\"ANO\",\"NORMAL\",\"STATISTIC\",\"P.VALUE\"" > ./data/nortest/nortest_results.csv

for i in ./data/INDICADOR_*.csv; do
	echo "Checking $i"
	./scripts/normality_tests.R $i ./data/nortest/nortest_results.csv
	mv *png ./data/nortest/
done

echo "Check results at data/nortest/"
