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
