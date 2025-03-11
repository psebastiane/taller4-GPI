# proyecto/scripts/graphs.py
import matplotlib.pyplot as plt
import pandas as pd
import os

# Cargar datos limpios
ruta_datos = os.path.join("..", "data", "processed", "clear_data.csv")
data = pd.read_csv(ruta_datos, encoding="utf-8-sig")

# Generar gráfico
fig, ax = plt.subplots()
ax.scatter(data['Citas'], data['Factor de impacto'])
ax.set_title('Relación Factor de impacto y citas')
ax.set_xlabel('Citas')
ax.set_ylabel('Factor de impacto')

# Guardar gráfico
ruta_guardado = os.path.join("..", "results", "figures", "figure1.pdf")
os.makedirs(os.path.dirname(ruta_guardado), exist_ok=True)
fig.savefig(ruta_guardado)