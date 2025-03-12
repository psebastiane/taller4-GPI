# barras.py
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os

# Ruta base del proyecto
base_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Cargar datos limpios
data = pd.read_csv(os.path.join(base_path, "data", "processed", "clear_data.csv"), encoding="utf-8-sig")

# Agrupar datos por pais y anho y sumar las citas
citas_por_pais_anio = data.groupby(['País', 'Año de publicación'])['Citas'].sum().unstack()

# Crear el grafico de barras
fig, ax = plt.subplots(figsize=(12, 8))
citas_por_pais_anio.plot(kind='bar', stacked=True, ax=ax)
ax.set_title('Cantidad de Citas por País y Año')
ax.set_xlabel('País')
ax.set_ylabel('Cantidad de Citas')
ax.legend(title='Año de publicación', bbox_to_anchor=(1.05, 1), loc='upper left')
ax.set_xticklabels(citas_por_pais_anio.index, rotation=45, ha='right')
plt.tight_layout()

# Guardar grafico
ruta_guardado = os.path.join(base_path, "results", "figures", "citas_por_pais_anho.pdf")
os.makedirs(os.path.dirname(ruta_guardado), exist_ok=True)
fig.savefig(ruta_guardado, bbox_inches='tight')

plt.show()