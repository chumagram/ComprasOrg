import pandas as pd
import csv

def obtener_primera_fila_csv(file_path):
    
    with open(file_path, mode='r', encoding='utf-8') as file:
        reader = csv.reader(file)
        primera_fila = next(reader)  # Leer la primera fila del CSV
        return primera_fila

def csv_to_sql_insert(csv_file, table_name):
    # Leer el archivo CSV con pandas
    data = pd.read_csv(csv_file, encoding='latin1', delimiter=';')
    
    # Lista para almacenar las queries SQL
    sql_queries = []

    # Añadir el encabezado de la consulta SQL
    sql_queries.append(f"INSERT INTO {table_name} (id_consumo, id_insumo, id_maquina, cantidad, fecha) VALUES ")

    # Iterar sobre cada fila del CSV para crear las consultas INSERT
    for index, row in data.iterrows():

        # Crear la query SQL para esta fila
        sql = f"({row['id_consumo']}, {row['id_insumo']}, '{row['id_maquina']}', {row['cantidad']}, '{row['fecha']}'),"
        sql_queries.append(sql)

    # Quitar la coma final y agregar punto y coma al final de la consulta
    sql_queries[-1] = sql_queries[-1].rstrip(',') + ';'

    return sql_queries

if __name__ == "__main__":

    # Obtener las queries SQL
    queries = csv_to_sql_insert("consumo.csv", "consumo")

    # Imprimir las queries
    for query in queries:
        # Abrimos el archivo en modo de anexado
        with open("mi_archivo.txt", "a") as archivo:
            # Escribimos la variable en el archivo
            archivo.write(query)
            archivo.write("\n")

print("Contenido guardado en 'mi_archivo.txt'.")