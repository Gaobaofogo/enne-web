#! /bin/bash

set -e

make
./bin/enne-web < $1

gcc codigo_intermediario.c -I./src/ -o bin/enne-maquina
./bin/enne-maquina
