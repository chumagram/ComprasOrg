import re

def cambiar_formato_fechas(archivo_entrada, archivo_salida):
    # Expresión regular para encontrar fechas en formatos D/M/AAAA, DD/MM/AAAA, D/MMM/AAAA
    patron_fecha = r'(\d{1,2})/(\d{1,2})/(\d{4})'
    
    # Abrir el archivo de entrada y el archivo de salida
    with open(archivo_entrada, 'r') as file:
        contenido = file.read()
        
    # Función para cambiar el formato de la fecha
    def reemplazar_fecha(match):
        dia, mes, anio = match.groups()
        return f"{anio}-{mes.zfill(2)}-{dia.zfill(2)}"  # Añadir ceros a la izquierda si es necesario
    
    # Reemplazar las fechas en el contenido
    nuevo_contenido = re.sub(patron_fecha, reemplazar_fecha, contenido)
    
    # Guardar el nuevo contenido en el archivo de salida
    with open(archivo_salida, 'w') as file:
        file.write(nuevo_contenido)

# Uso de la función
archivo_entrada = 'requisicion.sql'  # Cambia esto al nombre de tu archivo de entrada
archivo_salida = 'archivo_salida.sql'     # Cambia esto al nombre del archivo donde guardarás el resultado

cambiar_formato_fechas(archivo_entrada, archivo_salida)
