import pandas as pd
import sys
import json  # Importamos json para trabajar con la columna firmas_repre

def convert_to_comma_separated_string(json_str):
    """
    Convierte una cadena JSON en una cadena de valores separados por comas.
    Extrae los valores del diccionario y los convierte en un solo string separado por comas.
    """
    try:
        # Cargar la cadena JSON como un diccionario
        json_data = json.loads(json_str)
        # Extraer los valores y concatenarlos en un string separado por comas
        comma_separated_str = ', '.join([f"{value}" for value in json_data.values()])
        return comma_separated_str
    except json.JSONDecodeError:
        # Si falla la conversión, devolver el valor original escapado
        return "'{}'".format(json_str.replace("'", "''"))

def csv_to_sql_insert(csv_file, table_name):
    # Leer el archivo CSV con pandas
    data = pd.read_csv(csv_file, encoding='latin1', delimiter=';')
    
    # Lista para almacenar las queries SQL
    sql_queries = []

    # Añadir el encabezado de la consulta SQL
    sql_queries.append(f"INSERT INTO {table_name} (id_proveedor, nombre, pais, provincia, ciudad, calle, num_calle, firmas_repre) VALUES ")

    # Iterar sobre cada fila del CSV para crear las consultas INSERT
    for index, row in data.iterrows():
        # Convertir firmas_repre al formato de cadena separada por comas
        firmas_repre_comma_str = convert_to_comma_separated_string(row['firmas_repre'])
        
        # Crear la query SQL para esta fila
        sql = f"({row['id_proveedor']}, '{row['nombre']}', '{row['pais']}', '{row['provincia']}', '{row['ciudad']}', " \
              f"'{row['calle']}', {row['num_calle']}, '{firmas_repre_comma_str}'),"
        sql_queries.append(sql)

    # Quitar la coma final y agregar punto y coma al final de la consulta
    sql_queries[-1] = sql_queries[-1].rstrip(',') + ';'

    return sql_queries

if __name__ == "__main__":
    # Parámetros pasados desde la consola: archivo CSV y nombre de tabla
    if len(sys.argv) != 3:
        print("Uso: python script.py <archivo_csv> <nombre_tabla>")
        sys.exit(1)

    csv_file = sys.argv[1]
    table_name = sys.argv[2]

    # Obtener las queries SQL
    queries = csv_to_sql_insert(csv_file, table_name)

    # Imprimir las queries
    for query in queries:
        print(query)