# proyecto/scripts/simulated_data.py
import pandas as pd
import random
import numpy as np
import os

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
ruta_guardado = os.path.join("..", "data", "raw", "simulated_data.csv")
os.makedirs(os.path.dirname(ruta_guardado), exist_ok=True)
df.to_csv(ruta_guardado, index=False)