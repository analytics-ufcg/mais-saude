#!/bin/bash

rm ../data/faixas/*

for i in ../data/INDICADOR_*.csv; do
	echo "Checking $i"
	./normality_tests.R $i


#	mv *png *norm.txt ../data/nortest/
done

echo "Check results at data/faixas/"
