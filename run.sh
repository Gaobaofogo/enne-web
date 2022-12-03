#! /bin/bash

set -e

make
output=$( ./bin/enne-web < $1 )

gcc codigo_intermediario.c -o bin/enne-maquina
./bin/enne-maquina
