#!/bin/bash

# Script: runall.sh
# Descripcion: Automatiza la creacion de la estructura del proyecto,
#              la generacion de datos simulados, la limpieza de datos
#              y la generacion de graficos.

# Crear la estructura de carpetas del proyecto
echo "Creando la estructura de carpetas..."
mkdir -p proyecto/data/raw
mkdir -p proyecto/data/processed
mkdir -p proyecto/src
mkdir -p proyecto/scripts
mkdir -p proyecto/results/figures
mkdir -p proyecto/results/tables

# Crear archivos vacios necesarios
echo "Creando archivos vacios..."
touch proyecto/environment.yml
touch proyecto/runall.sh
touch proyecto/README.md

# Generar datos simulados
echo "Generando datos simulados..."
python proyecto/scripts/simulated_data.py

# Verificar que los datos se hayan guardado correctamente
if [ -f "proyecto/data/raw/simulated_data.csv" ]; then
    echo "Los datos simulados se han guardado en proyecto/data/raw/simulated_data.csv"
else
    echo "Error: No se pudo generar el archivo de datos simulados."
    exit 1
fi

# Limpiar datos
echo "Limpiando datos..."
python proyecto/scripts/data_cleaning.py

# Verificar que los datos limpios se hayan guardado correctamente
if [ -f "proyecto/data/processed/clear_data.csv" ]; then
    echo "Los datos limpios se han guardado en proyecto/data/processed/clear_data.csv"
else
    echo "Error: No se pudo generar el archivo de datos limpios."
    exit 1
fi

# Generar graficos
echo "Generando graficos..."
python proyecto/scripts/graphs.py