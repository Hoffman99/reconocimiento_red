# Reconocimiento de RED con BASH

## Características
- Detecta automáticamente la red de la interfaz `wlp` (WiFi)
- Soporta máscaras /8, /16, /24 mediante recursión
- Ejecución paralela para /24 (rápido)

## Uso
```bash
chmod +x ping_sweep.sh
./ping_sweep.sh
