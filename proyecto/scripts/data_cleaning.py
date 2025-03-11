# data_cleaning.py
import pandas as pd
import numpy as np

# Cargar datos
datos = pd.read_csv("../data/raw/simulated_data.csv", encoding="utf-8-sig")

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
ruta_guardado = os.path.join("..", "data", "processed", "clear_data.csv")
os.makedirs(os.path.dirname(ruta_guardado), exist_ok=True)
datos.to_csv(ruta_guardado, index=False, encoding="utf-8-sig")
