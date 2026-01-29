#!/bin/bash
if [ -z "$1" ]; then
    echo "Uso: $0 <porta_inicial> [max_tentativas]" >&2
    exit 1
fi
start_port=$1
max_attempts=${2:-100}

port=$start_port
attempts=0

while [ $attempts -lt $max_attempts ]; do
    if ! lsof -i :$port > /dev/null 2>&1; then
        echo $port
        exit 0
    fi
    port=$((port + 1))
    attempts=$((attempts + 1))
done

echo "Nenhuma porta disponível encontrada após $max_attempts tentativas" >&2
exit 1
