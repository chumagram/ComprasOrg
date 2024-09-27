import pandas as pd
import sys

def csv_to_sql_insert(csv_file, table_name):
    # Leer el archivo CSV con pandas
    data = pd.read_csv(csv_file, encoding='latin1', delimiter=';')
    
    # Lista para almacenar las queries SQL
    sql_queries = []

    # Añadir el encabezado de la consulta SQL
    sql_queries.append(f"INSERT INTO {table_name} (id_firma, nombre, pais, moneda) VALUES ")

    # Iterar sobre cada fila del CSV para crear las consultas INSERT
    for index, row in data.iterrows():

        # Crear la query SQL para esta fila
        sql = f"({row['id_firma']}, '{row['nombre']}', '{row['pais']}', '{row['moneda']}'),"
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