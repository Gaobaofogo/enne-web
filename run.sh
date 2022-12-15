#! /bin/bash

set -e

make
./bin/enne-web < $1

gcc codigo_intermediario.c src/str_aux.c -I./src -lm -o bin/enne-maquina
./bin/enne-maquina
