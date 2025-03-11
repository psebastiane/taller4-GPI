# correlacion.py
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os

# Ruta base del proyecto
base_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Cargar datos limpios
data = pd.read_csv(os.path.join(base_path, "data", "processed", "clear_data.csv"), encoding="utf-8-sig")

# Seleccionar dos variables numéricas para el análisis de correlación
variable1 = "Citas"
variable2 = "Factor de impacto"

# Calcular la correlación
correlacion = data[variable1].corr(data[variable2])
print(f"Correlación entre {variable1} y {variable2}: {correlacion:.2f}")

# Generar gráfico de dispersión
fig, ax = plt.subplots()
ax.scatter(data[variable1], data[variable2], alpha=0.5)
ax.set_title(f'Correlación entre {variable1} y {variable2}')
ax.set_xlabel(variable1)
ax.set_ylabel(variable2)

# Guardar gráfico
ruta_guardado = os.path.join(base_path, "results", "figures", "correlacion.pdf")
os.makedirs(os.path.dirname(ruta_guardado), exist_ok=True)
fig.savefig(ruta_guardado)

# Mostrar el gráfico
plt.show()