![Portada](/portada.jpg)

# Proyecto Final - Gestor de compras industriales
## 1. Descripción de la temática

### Introducción
Hola, soy Gonzalo Gramajo y me desempeño como Ingeniero de Mantenimiento en el sectór de tejeduría en la planta industrial del Grupo Ritex en La Rioja, Argentina. Una de mis tareas es gestionar la compra de repuestos e insumos que se necesiten en el sector, esto incluye:
- Realizar un análisis de consumos de repuestos y proveedores que brinden los repuestos. También buscar posibles mejoras a las máquinas Tejedoras y herramientas para el personal de mantenimiento.
- Mandar a cotizar a los distintos proveedores los repuestos necesarios para obtener una oferta. Para esto les envío una solicitud de compra.
- Si la oferta es correcta, solicitar la compra de la misma a las oficinas en Bs. As.
- Una vez confirmen la compra, se debe esperar que llegue en un par de meses aproximadamente (si es internacional) o un par de semanas (si es nacional).
- Cuando llegan los insumos, se cargan en el sistema MP9 (pañol) para luego ser consumidos por el taller de mantenimiento según se necesiten.

### Objetivos
Realizar una Base de Datos utilizando MySQL, que permita realizar consultas sobre el estado de compra de los insumos que se usan en Tejeduría y almacenar de manera ordenada los datos al rededor de esta operación, es decir, en que se consumen los insumos y quienes proveen los insumos.

### Situación problemática
MP9 es un sistema de gestión de insumos y mantenimiento MRP que es bastante antiguo (funciona lento) y no tiene la opcion de hacer un seguimiento de compras. Permite realizar un seguimiento del estado de cada repuesto, pero no permite predecir la falta de los mismos. Esto provoca que nos olvidemos de mandar a cotizar algunas cosas y al momento de hacerlo, nos demoremos mucho tiempo en analizar repuesto por repuesto (son más de 10.000).
Como se explicó primero, el hecho de que no se pueda hacer un seguimiento del estado de la compra, provoca que las ofertas estén sujetas a que se pierdan, se imprimen en papel o se demora en acceder a ellas (estan vagamente organizadas en una carpeta de Windows o almacenadas en una carpeta física).

### Modelo de negocio
Principalmente, el modelo de negocio se basa en la gestión de compras, desde el lado del consumidor, algo que no se tubo muy en cuenta en el sistema MP9.
Luego, la base de datos también tendría la capacidad de:
- Almacenar datos sobre el inventario de insumos y repuestos con su respectivo stock.
- Registrar los consumos de los distintos insumos y adjuntarlos a una máquina específica.
- Seguimiento de proveedores e insumos que suministran.

## 2. Diagrama entidad relación
![Diagrama entidad relación](/DER_v6.jpg)

## 3. Listado de tablas

### insumo:
*Descripción: esta tabla corresponde a cada insumo que se utiliza en el mantenimiento de tejeduría y los datos necesarios para describirlo completamente.*
| Nombre del campo                        | Abreviatura         | Tipo de datos      | Tipo de clave  | Valor máximo   |
|-----------------------------------------|---------------------|--------------------|----------------|----------------|
| Identificador del insumo                | id_insumo           | SMALLINT UNSIGNED  | Clave primaria | 65535          |
| Descripción del insumo                  | descripcion         | VARCHAR            |                | 100 caracteres |
| Cantidad del insumo                     | stock               | MEDIUMINT UNSIGNED |                | 16777215       |
| Cantidad máxima del insumo              | stock_max           | MEDIUMINT UNSIGNED |                | 16777215       |
| Cantidad mínima del insumo              | stock_min           | SMALLINT UNSIGNED  |                | 65535          |
| Identificador de la categoría de insumo | id_categoria_insumo | SMALLINT UNSIGNED  | Clave foránea  | 65535          |

### categoria_insumo:
*Descripción: esta tabla tiene la función de poder clasificar los insumos para poder agruparlos y que sea más facil realizar búsquedas o tambien ayudar a segmentear en un análisis.*
| Nombre del campo                        | Abreviatura         | Tipo de datos      | Tipo de clave  | Valor máximo   |
|-----------------------------------------|---------------------|--------------------|----------------|----------------|
| Identificador de la categoría de insumo | id_categoria_insumo | SMALLINT UNSIGNED  | Clave primaria | 65535          |
| Nombre de la categoría de insumo        | nombre              | VARCHAR            |                | 30 caracteres  |
| Descripcion de la categoría de insumo   | descripcion         | VARCHAR            |                | 150 caracteres |

### maquina:
*Descripción: esta tabla corresponde a las maquinas que consumen insumos y producen tela. Tambien incluye los datos suficientes para describirla (faltan muchos otros pero no vienen al caso a no ser que se quiera complejizar enormemente la base de datos).*
| Nombre del campo            | Abreviatura      | Tipo de datos       | Tipo de clave  | Valor máximo  |
|-----------------------------|------------------|---------------------|----------------|---------------|
| Identificador de la máquina | id_maquina       | CHAR                | Clave primaria | 5 caracteres  |
| Número de máquina interno   | num_interno      | SMALLINT UNSIGNED   |                | 65535         |
| Número de fabricación       | num_fabricacion  | MEDIUMINT           |                | 16777215      |
| Año de fabricación          | anio_fabricacion | YEAR                |                |               |
| Fabricante                  | fabricante       | VARCHAR             |                | 8 caracteres  |
| Modelo de la máquina        | modelo           | VARCHAR             |                | 50 caracteres |
| Diámetro                    | diametro         | UNSIGNED TINYINT    |                | 255           |
| Potencia                    | potencia         | UNSIGNED FLOAT(3,2) |                | 999,99        |
| Unidad de medida            | unidad_med       | CHAR                |                | 2 caracteres  |
| Alimentadores               | alimentadores    | UNSIGNED TINYINT    |                | 255           |

### proveedor:
*Descripción: Esta tabla corresponde a los proveedores de insumos y se añade las firmas que representan, aunque las propias firmas pueden ser proveedores.*
|       Nombre del campo      | Abreviatura  | Tipo de datos     | Tipo de clave  | Valor máximo  |
|-----------------------------|--------------|-------------------|----------------|---------------|
| Identificador del proveedor | id_proveedor | SMALLINT UNSIGNED | Clave primaria | 65535         |
| Nombre del proveedor        | nombre       | VARCHAR           |                | 50 caracteres |
| Pais donde reside           | pais         | VARCHAR           |                | 20 caracteres |
| Provincia donde reside      | provincia    | VARCHAR           |                | 30 caracteres |
| Ciudad donde reside         | ciudad       | VARCHAR           |                | 40 caracteres |
| Calle de locación           | calle        | VARCHAR           |                | 50 caracteres |
| Altura de la calle          | num_calle    | SMALLINT UNSIGNED |                | 65535         |

### firma:
*Descripción: Esta tabla contiene los datos referidos a las firmas, es decir a los fabricantes y/o otras organizaciones que medainte los proveedores, ponen a disposición los insumos que se pueden adquirir. Igualmente, los proveedores pueden ser la firma en sí mismo, pero esto no estará contemplado o representará alguna condicion o relación en la base de datos.*
| Nombre del campo           | Abreviatura  | Tipo de datos     | Tipo de clave  | Valor máximo  |
|----------------------------|--------------|-------------------|----------------|---------------|
| Identificador de la firma  | id_proveedor | SMALLINT UNSIGNED | Clave primaria | 65535         |
| Nombre de la firma         | nombre       | VARCHAR           |                | 50 caracteres |
| Pais donde reside la firma | pais         | VARCHAR           |                | 20 caracteres |
| Moneda que usa la firma    | provincia    | VARCHAR           |                | 5 caracteres  |

### representacion:
*Descripción: Esta tabla tiene el fin de lograr relacionar las firmas con los proveedores y esto se hace literalmente con las representaciones, es decir, los proveedores son representantes de una serie de firmas y ellos a su vez son intermediarios entre la fábrica/organización (consumidor final) y la firma.*
| Nombre del campo                   | Abreviatura       | Tipo de datos     | Tipo de clave  | Valor máximo |
|------------------------------------|-------------------|-------------------|----------------|--------------|
| Identificador de la representación | id_representacion | SMALLINT UNSIGNED | Clave primaria | 65535        |
| Identificacor de la firma          | id_firma          | SMALLINT UNSIGNED | Clave foránea  | 65535        |
| Identificador del proveedor        | id_proveedor      | SMALLINT UNSIGNED | Clave foránea  | 65535        |

### contacto:
*Descripción: Esta tabla representa a un contacto, que sería una persona que pertenece a una empresa que es proveedor y tiene la capacidad de guiarnos en el proceso de compra o consulta sobre insumos. Se añade los datos necesarios para justamente contactarnos con ella correctamente.*
| Nombre del campo             | Abreviatura  | Tipo de datos     | Tipo de clave  | Valor máximo   |
|------------------------------|--------------|-------------------|----------------|----------------|
| Identificador del contacto   | id_contacto  | SMALLINT UNSIGNED | Clave primaria | 65535          |
| Identificación del proveedor | id_proveedor | SMALLINT UNSIGNED | Clave foránea  | 65535          |
| Nombre del contacto          | nombre       | VARCHAR           |                | 50 caracteres  |
| Apellido del contacto        | apellido     | VARCHAR           |                | 50 caracteres  |
| Mail del contacto            | mail         | VARCHAR           |                | 100 caracteres |
| Teléfono del contacto        | telefono     | CHAR              |                | 16 caracteres  |
| Puesto laboral que opcupa    | puesto_lab   | VARCHAR           |                | 50 caracteres  |

### requisicion:
*Descripción: Esta tabla corresponde a una requisición o solicitud de compra que se envía a un determinado proveedor para que luego nos devuelva una cotización u oferta. Luego esa oferta será confirmada al proveedor para luego comprar o también se podrá cancelar. En conclusión, la requisición tendrá una serie definida de estados*
| Nombre del campo                | Abreviatura    | Tipo de datos     | Tipo de clave   | Valor máximo    |
|---------------------------------|----------------|-------------------|-----------------|-----------------|
| Identificador de la requisicion | id_requisicion | SMALLINT UNSIGNED | Clave primaria  | 65535           |
| Identificador del estado        | id_estado      | TINYINT UNSIGNED  | Clave foránea   | 255             |
| Identificador del proveedor     | id_proveedor   | SMALLINT UNSIGNED | Clave foránea   | 65535           |
| Fecha de la requisicion         | fecha          | DATE              |                 |                 |
| Numero de oferta                | num_oferta     | VARCHAR           |                 | 20 caracteres   |
| Link a la oferta                | link_oferta    | VARCHAR           |                 |                 |

### catalogo:
*Descripción: Esta tabla teiene la funcionalidad de interconectar o relacionar la tabla de insumos con la tabla de proveedores ya que en este caso se da una relacion de muchos a muchos, dicho de otra manera, muchos proveedores proveen muchos insumos. Un proveedor en su cartera de opciones puede contar con una gran cantidad de insumos. Visto del otro lado, un insumo es proveido por muchos proveedores.*

| Nombre del campo                  | Abreviatura      | Tipo de datos     | Tipo de clave  | Valor máximo  |
|-----------------------------------|------------------|-------------------|----------------|---------------|
| Identificador de catalogo         | id_prove_insum   | SMALLINT UNSIGNED | Clave primaria | 65535         |
| Identificador del proveedor       | id_proveedor     | SMALLINT UNSIGNED | Clave foránea  | 65535         |
| Identificador del insumo          | id_insumo        | SMALLINT UNSIGNED | Clave foránea  | 65535         |

### estado_req:
*Descripción: Esta tabla tiene la funcion de contener los posbiles estados que pueda terner una requisicion. maquina_insumo*

| Nombre del campo                       | Abreviatura   | Tipo de datos    | Tipo de clave  | Valor máximo   |
|----------------------------------------|---------------|------------------|----------------|----------------|
| Identificador de estado de requisicion | id_estado_req | TINYINT UNSIGNED | Clave primaria | 255            |
| Nombre del estado                      | nombre        | VARCHAR          |                | 30 caracteres  |
| Descripcion del estado                 | descripcion   | VARCHAR          |                | 150 caracteres |

### consumo:
*Descripción: Esta tabla tiene la funcion de ser nexo y lograr la relacion entre las tablas maquina y la tabla insumo ya que entre ellas se da una relacion de muchos a muchos. La explicacion de esto sería de que una maquina puede utilzar muchos y diversos tipos de insumo, como así tambien un insumo puede ser ocupado en muchas maquinas ya que en la organizacion se cuenta con 116 máquinas circulares tejedoras, muy similares una con las otras.*

| Nombre del campo            | Abreviatura    | Tipo de datos      | Tipo de clave  | Valor máximo |
|-----------------------------|----------------|--------------------|----------------|--------------|
| Identificador del consumo   | id_consumo     | MEDIUMINT UNSIGNED | Clave primaria | 16777215     |
| Identificador de insumo     | id_insumo      | SMALLINT UNSIGNED  | Clave foránea  | 65535        |
| Identificador de la máquina | id_maquina     | CHAR               | Clave foránea  | 5 caracteres |
| Cantidad                    | cantidad       | SMALLINT UNSIGNED  |                | 65535        |

### requisicion_lista:
*Descripción: Esta tabla tiene la funcion de contener la lista de insumos pero asignándole una cierta cantidad y requisición específica. Esto es debido a que en una requisicion o solicitud de compra, además de los datos de la requisición en sí, también se tiene una tabla adentro de la misma que contiene la lista de insumos a pedir.*

| Nombre del campo                      | Abreviatura    | Tipo de datos      |  Tipo de clave  | Valor máximo |
|---------------------------------------|----------------|--------------------|-----------------|--------------|
| Identificador de la lista de req.     | id_lista_req   | SMALLINT UNSIGNED  | Clave primaria  | 65535        |
| Identificador de la requisicion       | id_requisicion | SMALLINT UNSIGNED  | Clave foránea   | 65535        |
| Identificador del insumo              | id_insumo      | SMALLINT UNSIGNED  | Clave foránea   | 65535        |
| Cantidad del insumo a solicitar       | cantidad       | MEDIUMINT UNSIGNED |                 | 16777215     |

## 4. Archivo SQL para inicializar la base de datos
*En el siguiente link puedes encontrar la query que crea la base de datos con sus respectivas tablas y configraciones:*  
[CLICKEA AQUI](/ind_shopping_init.sql)
*También te dejo otro link para poblar la base de datos con ejemplos que inventé. Pero puedes usar tus propios datos tranquilamente:*
[CLICKEA AQUI](/ind_shopping_population.sql)

# OBJETOS: Vistas, funciones, stored procedures y triggers de utilidad
En este apartado se agrearán vistas, funciones, stored procedures y triggers para que la base de datos tenga mas dinamismo y funcionalidad.

## 5. Vistas

### Vista 1 - Insumos con deficit de stock ordenados segun urgencia
**Descripción:** esta vista muestra el inventario actual de insumos, incluyendo la cantidad en stock y el stock mínimo.  
**Objetivo:** mostrar de forma descendente la urgencia de adquirir los distintos tipos de insumos. Los porcentajes mas cercanos al 100, son los más urgentes de adquirir y se posicionaran inicialmente por defecto, en la parte superior de la tabla de la view. Cabe aclarar que todos los items que se muestran en la lista, están por debajo del stock minimo, así que se debería realizar una compra de todos ellos. En consecuencia y gracias a esta vista, podemos dar una prioridad según los porcentajes.
**Tablas/datos:**
| Nombre del campo                                       | Abreviatura           | Tabla origen |
|--------------------------------------------------------|-----------------------|--------------|
| Identificador del insumo                               | id_insumo             | insumo       |
| Descripción del insumo                                 | descripcion           | insumo       |
| Stock del insumo                                       | stock                 | insumo       |
| Stock mínimo del insumo                                | stock_min             | insumo       |
| Stock mínimo del insumo                                | stock_max             | insumo       |
| Difetencia porcentual entre el stock y el stock minimo | diferencia_porcentual | esta view    |

### Vista 2 - Consumos por Máquina
**Descripción:** Muestra la cantidad de cada insumo utilizado por cada máquina.  
**Objetivo:** Esta vista permite saber exactamente que insumos consume una determinada máquina y que cantidad se fue consumiendo para poder preveer un consumo futuro y no cometer un error al consumir un insumo y luego darse cuenta que no es el adecuado.  
**Tablas/datos:**  
| Nombre del campo            | Abreviatura  | Tabla origen |
|-----------------------------|--------------|--------------|
| Identificador de la máquina | id_maquina   | maquina      |
| Modelo de la máquina        | modelo       | maquina      |
| Identificador del insumo    | id_insumo    | consumo      |
| Descripción del insumo      | descripcion  | insumo       |
| Cantidad consumida          | cantidad     | consumo      |

### Vista 3 - Requisiciones pendientes
**Descripción:** muestra las requisiciones que están pendientes, junto con el estado y los detalles del proveedor.  
**Objetivo:** mostrar los pendientes para rápidamente saber los insumos que nos deben los distintos proveedores y en base a esto poder hacer el correspodiente regalo o previsiónes.  
**Tablas/datos:**  
| Nombre del campo                | Abreviatura      | Tabla origen |
|---------------------------------|------------------|--------------|
| Identificador de la requisición | id_requisicion   | requisicion  |
| Fecha de la requisición         | modelo           | requisicion  |
| Nombre del proveedor            | proveedor_nombre | proveedor    |
| Nombre del estado               | estado           | estado       |
| Solicitante                     | solicitante      | requisicion  |
| Comentario                      | comentario       | requisicion  |

### Vista 4 - Proveedores e Insumos Suministrados
**Descripción:** relación entre proveedores y los insumos que suministran.
**Objetivo:** hacer "AMIGABLE" a la tabla "catalogo". Muestra los insumos que provee un determinado proveedor para un rápido análisis de los posibles insumos a adquirir que pertenezcan a un mismo proveedor. Sería lograr algo así como la recomendación de añadir productos del mismo proveedor que recomienda Mercado Libre cuando se hace una compra. Esto trae beneficios monetarios, como descuentos, posibilidad de negociación y menos gastos de envío.
**Tablas/datos:**
| Nombre del campo            | Abreviatura         | Tabla origen |
|-----------------------------|---------------------|--------------|
| Identificador del proveedor | id_proveedor        | proveedor    |
| Nombre del proveedor        | proveedor_nombre    | proveedor    |
| Identificador del insumo    | id_insumo           | insumo       |
| Descripcion del insumo      | insumo_descripcion  | insumo       |
| Código insumo-proveedor     | codigo_insu_prov    | catalogo     |

### Vista 5 - Contactos por proveedor
**Descripción:** contactos asociados con cada proveedor, incluyendo detalles de contacto.  
**Objetivo:** obtener todos los contactos que tiene un proveedor para saber facilemnte a quien contactar segun la persona que pertenece a esa organización y su cargo.  
**Tablas/datos:**  
| Nombre del campo            | Abreviatura      | Tabla origen |
|-----------------------------|------------------|--------------|
| Nombre del proveedor        | proveedor_nombre | proveedor    |
| Nombre del contacto         | contacto_nombre  | contacto     |
| Apellido del contacto       | apellido         | contacto     |
| Mail del contacto           | mail             | contacto     |
| Teléfono del contacto       | telefono         | contacto     |
| Puesto laboral del contacto | puesto_lab       | contacto     |

## 6. Funciones

### Función 1 - Verificar stock disponible de un insumo
**Descripción:** Esta función verifica el stock disponible de un insumo.  
**Objetivo:** verificar si hay suficiente stock para un insumo específico y una cantidad solicitada, y devuelve un valor booleano (1 o 0). Es útil antes de realizar consumos, requisiciones o procesos que requieran verificar la disponibilidad de stock.  
**Datos de entrada:** id del insumo (id_insum_param), cantidad a solicitar (cantidad)
**Datos de salida:** 0 o 1 (booleano) 

### Función 2 - Buscar insumo en tabla según identificador
**Descripción:** esta funcion busca un un insumo pero se debe pasar el identificador o ID. Esto es más rápido en cuanto a procesamiento y/o si el usuario tiene el ID a mano, ya sea porque esta viendo una requisición o consumo realizado.  
**Objetivo:** agilizar la búsqueda de un insumo si ya se posee su identificador.  
**Tablas/datos:**  
- Se aplica a las tablas que contengan insumos, pero solo a una de ellas a la vez. Puden ser las tablas:
  1. insumo
  2. consumo
  3. requisicion_lista
- Datos de entrada: id_insumo (identificador del insumo)

## 7. Stored procedures

### Procedure 1 - Buscar en estado general de un insumo
**Descripción:** Este procedimiento almacenado o stored procedure, realiza la búsqueda en todas las posibles tablas en donde se puede encontrar el insumo, es decir, en las tablas insumo, consumo y requisicion_lista; y devuelve los resultados coincidentes.  
**Objetivo:** Ver facilmente el estado de un insumo en la base de datos.  
**Tablas/datos:**  
- Se aplica a las tablas: "insumo", "consumo" y "requisicion_lista" en simultaneo.
- Datos de entrada: descripción o parte de la descripción de un insumo.

### Procedure 2 - Crear requisicion de compra
**Descripción:** Este stored procedure tiene la capacidad de crear una nueva requisición de compra en la base de datos.  
**Objetivo:** Crear una requisisción de compra y asignarle proveedor y estado. Esto automatiza el proceso de crear una requisición.  
**Tablas/datos:**  
- Se aplica a la tabla "requisicion"
- Datos de entrada:
  1. ID del proveedor
  2. Numero de oferta
  3. Solicitante
  4. Comentario

## 8. Triggers

### Trigger 1 - Actualizar el stock luego de realizar un consumo
**Descripción:** este trigger actualiza el stock de la talba insumo, automaticamente al producirse una nueva linea en la tabla consumo.
**Objetivo:** Mantener el stock actualizado. Lograr automatizar la actualización de stock.

### Trigger 2 - Actualizar el stock luego de que ingresa una compra
**Descripción:** este trigger actualiza el stock luego de que una requisición de compra pasa al estado de "llegó completo". Para saber que insumos debe actualizar en la talbla "insumo", se basa en la tabla "lista_requisicion" y su respectivo numero de requisicion.
**Objetivo:** Automatizar el stock de insumo automáticamente se registre un ingreso de los mismos a la planta industrial. Previo a esto siempre se hace un control manual de que es lo que llega. Luego (actualmente) se realiza la carga en el sistema MP9 item po item. Esto es podría automatizar si ya se tiene en el sistema la requisicion de compra y los items que se solicitan en dicha requisición.

## 9. Archivos SQL para la creación de los objetos
*Descarga el siguiente archivo y ejecútalo para crear las vistas, funciones y stored procedures que te serán útiles en el día a día usando la db deñ Gestór de compras industriales*
[CLICKEA AQUÍ Y EJECUTA LA QUERY PARA CREAR LOS OBJETOS EN LA DB](/ind_shopping_objects.sql)

## 10. Informes generados en Looker-Studio


# Listado de herramientas utilizadas
1. **MySql Workbench**: Gestor principal de la base de datos en cuestión.
2. **Visual Studio Code**: edicion de MarkDown y programación en python.
3. **Python**: para la conversión de archivos CSV a un INSERT en SQL, se utilizó un script de python diseñado especificamente para este fin. El mismo se lo puede encontrar en el siguiente link. [CLICKEA AQUÍ](/Population_files/csv_to_sql.py). También se lo utilizó para realizar otras modificaciones, como por ejemplo, la correción de fechas de DDD/MM/AAAA a AAAA-MM-DD, ya que este ultimo formato es el compatible con MySQL. También adjunto el link a este Script [CLICKEA AQUÍ](/Population_files/cambiar_fecha.py).
4. **Git**: esta herramienta fue muy útil para poder ir realizando el seguimiento y las presentaciones de los trabajos en las clases. Sobre todo fue util para poder presentar centralizadamente todo el trabajo.
5. **Miro**: esta herramienta fue especialmente útil para el diseño de la base de datos mediante el Diagrama Entidad-relación. Es una herramienta gratuita, pero tiene una opcion de pago que da otras opciones como mejorar la calidad de la imagen que se exporta.
6. **ChatGPT**: esta herramienta controversial pero muy útil, fue de gran ayuda para hacer de copiloto en la programación de la base de dato y los archivos de python que mencioné anteriormente. Tambipen lo usé para aclarar ideas y conceptos con respecto a la base de datos. Por ejemplo, que nuevas funciones serían útiles si necesito saber si un insumo está disponible para ser consumido, entre otros.
7. **Looker-Studio**: esta herramienta de BI fue utilizada para realizar los informes. Nunca lo había utilizado.

# Futuras líneas

## Realizar la gestión de los tiempos

En base a la experiencia creando esta base de taos, surge la necesidad de poder ir calculando los **tiempos de abastecieminto, tiempo de fabricación de insumos**. Esta mejora sería muy veneficiosa ya que va a permitir preveer. Por ejemplo, si sabemos que si se le compra a un determinado proveedor, la compra tarda X cantidad de días. Entonces, en base a estos se puede adelantar la compra o tomar otras deciciones como acudir a otro proveedor que tenga menor frecuencia de abastecimiento, entre otras decisiones que se puedan llegar a tomar. 

Tambien realizar el **analis de la frecuencia de consumo de un determinado insumo en una determinada maquina**. Esto es especialmente util porque de esta manera podemos hasta poder preveer cuando va a fallar un insumo com por ejemplo un rodamiento. Por ejemplo, si se consume en esa maquina un rodamiento cada 8 meses, es posible hasta realizar un plan de mantenimiento predictivo en donde el rodamiento se cambia a los 7 meses y luego evitar los inconvenientes de que la maquina falle por culpa del rodamiento en cuestión.

Luego de estas y otras mejoras que seguramente surjan en el camino, lo que sigue es realizar un **entorno de usuario**. Para esta tarea, tengo planeado usar herramientas del stack MERN (ya que hice el curso en Corder House de estp) o Electron si va a ser una app para exritorio. Esto lograría un proyecto amigable y completo, digno de ser admirado por un posible evaluador para un puesto laboral o como no, lograr **vender la idea**.