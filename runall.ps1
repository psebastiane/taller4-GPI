# Script: runall.ps1
# Descripcion: Automatiza la creacion de la estructura del proyecto,
#              la generacion de datos simulados, la limpieza de datos
#              y la generacion de graficos.

# Ruta base del proyecto
$proyecto_path = "proyecto"

# Crear la estructura de carpetas del proyecto
Write-Output "Creando la estructura de carpetas..."
New-Item -ItemType Directory -Path "$proyecto_path/data/raw" -Force
New-Item -ItemType Directory -Path "$proyecto_path/data/processed" -Force
New-Item -ItemType Directory -Path "$proyecto_path/src" -Force
New-Item -ItemType Directory -Path "$proyecto_path/scripts" -Force
New-Item -ItemType Directory -Path "$proyecto_path/results/figures" -Force
New-Item -ItemType Directory -Path "$proyecto_path/results/tables" -Force

# Crear archivos vacios necesarios
Write-Output "Creando archivos vacios..."
New-Item -ItemType File -Path "$proyecto_path/environment.yml" -Force
New-Item -ItemType File -Path "$proyecto_path/README.md" -Force

# Generar datos simulados
Write-Output "Generando datos simulados..."
python "$proyecto_path/scripts/simulated_data.py"

# Verificar que los datos se hayan guardado correctamente
if (Test-Path "$proyecto_path/data/raw/simulated_data.csv") {
    Write-Output "Los datos simulados se han guardado en $proyecto_path/data/raw/simulated_data.csv"
} else {
    Write-Output "Error: No se pudo generar el archivo de datos simulados."
    exit 1
}

# Limpiar datos
Write-Output "Limpiando datos..."
python "$proyecto_path/scripts/data_cleaning.py"

# Verificar que los datos limpios se hayan guardado correctamente
if (Test-Path "$proyecto_path/data/processed/clear_data.csv") {
    Write-Output "Los datos limpios se han guardado en $proyecto_path/data/processed/clear_data.csv"
} else {
    Write-Output "Error: No se pudo generar el archivo de datos limpios."
    exit 1
}

# Generar graficos
Write-Output "Generando graficos..."
python "$proyecto_path/scripts/graphs.py"

# Verificar que los graficos se hayan guardado correctamente
if (Test-Path "$proyecto_path/results/figures/figure1.pdf") {
    Write-Output "Los graficos se han guardado en $proyecto_path/results/figures/figure1.pdf"
} else {
    Write-Output "Error: No se pudo generar el archivo de graficos."
    exit 1
}

# Mensaje de finalizacion
Write-Output "Proceso completado con exito!"