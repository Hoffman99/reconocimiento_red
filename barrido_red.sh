#!/usr/bin/env bash

calcular_red() {
    local ip_mask="$1"  
    local ip=$(echo "$ip_mask" | cut -d/ -f1)
    local mask=$(echo "$ip_mask" | cut -d/ -f2)
    local o1=$(echo "$ip" | cut -d. -f1)
    local o2=$(echo "$ip" | cut -d. -f2)
    local o3=$(echo "$ip" | cut -d. -f3)
    case $mask in
        8)
            echo "$o1"
            ;;
        16)
            echo "$o1.$o2"
            ;;
        24)
            echo "$o1.$o2.$o3"
            ;;
        *)
            echo "Máscara no soportada: /$mask" >&2
            return 1
            ;;
    esac
}

escanear() {
    local prefijo="$1"
    local niveles="$2"

    if [ "$niveles" -eq 1 ]; then
        for host in {0..255}; do
            (
                if ping -c 1 -W 1 "$prefijo.$host" &> /dev/null; then
                    echo "Ping con $prefijo.$host"
                fi
            ) &
        done
        wait
    else
        for segmento in {0..255}; do
            escanear "$prefijo.$segmento" $(( niveles - 1 ))
        done
    fi
}

direccion_usr=$(ip a | grep "wlp" | grep "inet" | awk '{print $2}')
mask=$(echo "$direccion_usr" | cut -d/ -f2)
red=$(calcular_red "$direccion_usr")
niveles=$(( (32 - mask) / 8 ))

escanear "$red" "$niveles"
