# data_cleaning.py
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os

# Ruta base del proyecto
base_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
# Cargar datos
data = pd.read_csv(os.path.join(base_path, "data", "processed", "clear_data.csv"), encoding="utf-8-sig")

# Generar gráfico
fig, ax = plt.subplots()
ax.hist(data['Citas'], bins=20, color='blue', alpha=0.7)
ax.set_title('Distribución de Citas')
ax.set_xlabel('Citas')
ax.set_ylabel('Frecuencia')

# Guardar gráfico
ruta_guardado = os.path.join(base_path, "results", "figures", "figure2.pdf")
os.makedirs(os.path.dirname(ruta_guardado), exist_ok=True)
fig.savefig(ruta_guardado)