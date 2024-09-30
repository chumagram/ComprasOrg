'''
Este script para python tiene la siguiente función:
INGRESAR: como parámetro por consola, el nombre del archivo csv
cuyo nombre debe ser igual al de la tabla y la primera columna de este archivo
debe contener el nombre de los campos de la columna.
DEVUELVE: archivo que contiene un INSERT de la tabla en cuestión con extensión .sql
'''

import csv
import sys
import os

def csv_to_sql(file_path):
    # Leer el nombre del archivo sin la extensión
    table_name = os.path.splitext(os.path.basename(file_path))[0]

    # Inicializar variables
    headers = []
    rows = []

    # Leer el archivo CSV para obtener encabezados y datos
    try:
        with open(file_path, mode='r', encoding='utf-8') as file:
            reader = csv.reader(file)
            headers = next(reader)  # Leer la primera línea con los encabezados
            rows = list(reader)  # Leer el resto de las filas
    except UnicodeDecodeError:
        # Si hay un error de codificación, intenta con 'latin1'
        with open(file_path, mode='r', encoding='latin1') as file:
            reader = csv.reader(file)
            headers = next(reader)  # Leer la primera línea con los encabezados
            rows = list(reader)  # Leer el resto de las filas

    # Acomodar la lista para que este separada en array y no en un string largo
    rows_formatted = []
    for row in rows:
        aux = row[0]
        rows_formatted.append(aux.split(";"))

    # Generar la lista de columnas y preparar la estructura del INSERT
    column_names = ', '.join(headers)

    # Generar todos los valores de las filas
    values_list = []
    for row in rows_formatted:
        formatted_values = []
        for value in row:
            # Verificar si el valor es numérico (entero o decimal)
            try:
                # Primero intenta convertir el valor a un entero
                num_value = int(value)
                formatted_values.append(str(num_value))
            except ValueError:
                try:
                    # Si falla el entero, intenta convertirlo a flotante
                    num_value = float(value)
                    formatted_values.append(str(num_value))
                except ValueError:
                    # Si no es ni entero ni flotante, se considera texto y se escapa
                    formatted_values.append(f"'{value.replace('\'', '\'\'')}'")

        # Crear la representación para la fila completa con valores separados adecuadamente
        values_list.append(f"({', '.join(formatted_values)})")
    
    # Unir todos los valores en un solo comando INSERT
    all_values = ',\n'.join(values_list)
    insert_statement = f"INSERT INTO {table_name} ({column_names}) VALUES\n{all_values};"

    # Generar el archivo de salida para guardar el INSERT
    output_file_path = f"{table_name}.sql"
    with open(output_file_path, mode='w', encoding='utf-8') as output_file:
        output_file.write(insert_statement)
    
    print(f"Archivo de INSERTs generado: {output_file_path}")

# Punto de entrada principal del script
if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Uso: python csv_to_sql.py <ruta_al_archivo_csv>")
    else:
        csv_file_path = sys.argv[1]
        csv_to_sql(csv_file_path)
