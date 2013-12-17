#!/bin/bash

./scripts/run_tests.sh

./scripts/run_centro.sh

./scripts/run_faixas.sh

./scripts/build_data.sh

zip -r data/dados.zip data/INDICADOR_&* data/dicionario.csv
