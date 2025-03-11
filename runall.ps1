# Script: runall.ps1
# Descripcion: Automatiza la creacion de la estructura del proyecto,
#              la generacion de scripts Python, la generacion de datos simulados,
#              la limpieza de datos y la generacion de groficos.

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

# Crear el archivo simulated_data.py
Write-Output "Generando simulated_data.py..."
$simulated_data_content = @"
# simulated_data.py
import pandas as pd
import random
import numpy as np
import os

# Ruta base del proyecto
base_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
# Semillas para asegurar replicabilidad
random.seed(123)
np.random.seed(123)

# Simulación de universidades y revistas
universidades = ["Universidad Nacional Autónoma de México", "Universidad de Buenos Aires",
                 "Universidade de São Paulo", "Pontificia Universidad Católica de Chile",
                 "Universidad de los Andes"]
revistas = ["Nature", "Science", "PLoS ONE", "Documentos CEDE", "Journal of Open Science"]

# Simulación de datos
num_registros = 100
datos = []

for i in range(num_registros):
    id_articulo = i + 1
    # Agregar 5% de valores nulos
    titulo = f"Estudio sobre la ciencia abierta {i}" if random.random() > 0.05 else np.nan
    afiliacion = random.choice(universidades)
    # Errores ortográficos
    pais = random.choice(["México", "Argentina", "Brazil", "Chile", "Colombia", "Peru", "Brasil"
                          , "Argentna"])
    # Datos inconsistentes
    anio_publicacion = random.choice([2020, 2021, "2022", "20XX", 2023])
    revista = random.choice(revistas)
    # Valores negativos (fuera de rango)
    factor_impacto = round(random.uniform(-2, 15), 2)
    # Valores inconsistentes
    citas = random.choice([random.randint(0, 500), "cien", np.nan])
    
    datos.append([id_articulo, titulo, afiliacion, pais, anio_publicacion, revista,
                  factor_impacto, citas])

# Crear DataFrame
df = pd.DataFrame(datos, columns=["ID", "Título", "Afiliación", "País", "Año de publicación",
                                  "Revista", "Factor de impacto", "Citas"])

# Guardar datos
ruta_guardado = os.path.join(base_path, "data", "raw", "simulated_data.csv")
os.makedirs(os.path.dirname(ruta_guardado), exist_ok=True)
df.to_csv(ruta_guardado, index=False)
"@
Set-Content -Path "$proyecto_path/scripts/simulated_data.py" -Value $simulated_data_content

# Crear el archivo data_cleaning.py
Write-Output "Generando data_cleaning.py..."
$data_cleaning_content = @"
# data_cleaning.py
import pandas as pd
import numpy as np
import os

# Ruta base del proyecto
base_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
# Cargar datos
datos = pd.read_csv(os.path.join(base_path, "data", "raw", "simulated_data.csv"), encoding="utf-8-sig")

# Eliminar posibles duplicados
datos = datos.drop_duplicates()

# Corregir errores ortográficos
datos["País"] = datos["País"].replace({"Argentna": "Argentina", "Brazil": "Brasil"})

# Limpiar la variable años
def limpiar_anio(valor):
    try:
        return int(valor)
    except:
        return np.nan

datos["Año de publicación"] = datos["Año de publicación"].apply(limpiar_anio)

# Limpiar citas
def limpiar_citas(valor):
    if isinstance(valor, str):
        return np.nan if not valor.isdigit() else int(valor)
    return valor

datos["Citas"] = datos["Citas"].apply(limpiar_citas)

# Reemplazar valores fuera de rango
datos["Factor de impacto"] = datos["Factor de impacto"].apply(lambda x: x if x >= 0 else np.nan)

# Eliminar missing values
datos = datos.dropna(subset=["Título", "Año de publicación", "Citas", "Factor de impacto"])

# Guardar datos limpios
ruta_guardado = os.path.join(base_path, "data", "processed", "clear_data.csv")
os.makedirs(os.path.dirname(ruta_guardado), exist_ok=True)
datos.to_csv(ruta_guardado, index=False, encoding="utf-8-sig")
"@
Set-Content -Path "$proyecto_path/scripts/data_cleaning.py" -Value $data_cleaning_content

# Crear el archivo graphs.py
Write-Output "Generando graphs.py..."
$graphs_content = @"
# graphs.py
import matplotlib.pyplot as plt
import pandas as pd
import os


# Ruta base del proyecto
base_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
# Cargar datos limpios
data = pd.read_csv(os.path.join(base_path, "data", "processed", "clear_data.csv"), encoding="utf-8-sig")

# Generar gráfico
fig, ax = plt.subplots()
ax.scatter(data['Citas'], data['Factor de impacto'])
ax.set_title('Relación Factor de impacto y citas')
ax.set_xlabel('Citas')
ax.set_ylabel('Factor de impacto')

# Guardar gráfico
ruta_guardado = os.path.join(base_path, "results", "figures", "figure1.pdf")
os.makedirs(os.path.dirname(ruta_guardado), exist_ok=True)
fig.savefig(ruta_guardado)
"@
Set-Content -Path "$proyecto_path/scripts/graphs.py" -Value $graphs_content

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
Write-Output "Generando gráficos..."
python "$proyecto_path/scripts/graphs.py"

# Verificar que los graficos se hayan guardado correctamente
if (Test-Path "$proyecto_path/results/figures/figure1.pdf") {
    Write-Output "Los graficos se han guardado en $proyecto_path/results/figures/figure1.pdf"
} else {
    Write-Output "Error: No se pudo generar el archivo de graficos."
    exit 1
}

# Mensaje de finalizacion
Write-Output "Proceso completado con éxito!"