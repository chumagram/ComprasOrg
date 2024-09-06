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
![Diagrama entidad relación](/DER_v3.jpg)

## 3. Listado de tablas

### insumo:
*Descripción: esta tabla corresponde a cada insumo que se utiliza en el mantenimiento de tejeduría y los datos necesarios para describirlo completamente*
| Nombre del campo           | Abreviatura | Tipo de datos      | Tipo de clave  | Valor máximo   |
|----------------------------|-------------|--------------------|----------------|----------------|
| Identificador del insumo   | id_insumo   | SMALLINT UNSIGNED  | Clave primaria | 65535          |
| Descripción del insumo     | descripcion | VARCHAR            |                | 100 caracteres |
| Cantidad del insumo        | stock       | MEDIUMINT UNSIGNED |                | 16777215       |
| Cantidad minima del insumo | stock_min   | SMALLINT UNSIGNED  |                | 65535          |

### maquina:
*Descripción: esta tabla corresponde a las maquinas que consumen insumos y producen tela. Tambien incluye los datos suficientes para describirla (faltan muchos otros pero no vienen al caso a no ser que se quiera complejizar enormemente la base de datos).*
| Nombre del campo            | Abreviatura   | Tipo de datos     | Tipo de clave  | Valor máximo  |
|-----------------------------|---------------|-------------------|----------------|---------------|
| Identificador de la máquina | id_maquina    | CHAR              | Clave primaria | 5 caracteres  |
| Número de máquina interno   | num_interno   | SMALLINT UNSIGNED |                | 65535         |
| Número de fabricación       | num_fabric    | MEDIUMINT         |                | 16777215      |
| Año de fabricación          | anio_fabric   | YEAR              |                |               |
| Fabricante                  | fabricante    | VARCHAR           |                | 8 caracteres  |
| Modelo de la máquina        | modelo        | VARCHAR           |                | 50 caracteres |
| Diámetro                    | diametro      | UNSIGNED TINYINT  |                | 255           |
| Potencia                    | potencia      | UNSIGNED TINYINT  |                | 255           |
| Unidad de medida            | unidad_med    | CHAR              |                | 2 caracteres  |
| Alimentadores               | alimentadores | UNSIGNED TINYINT  |                | 255           |

### proveedor:
*Descripción: Esta tabla corresponde a los proveedores de insumos y se añade las firmas que representan, aunque las propias firmas pueden ser proveedores.*
|       Nombre del campo      | Abreviatura   | Tipo de datos     |  Tipo de clave  | Valor máximo  |
|-----------------------------|---------------|-------------------|-----------------|---------------|
| Identificador del proveedor | id_proveedor  | SMALLINT UNSIGNED |  Clave primaria | 65535         |
| Nombre del proveedor        | nombre        | VARCHAR           |                 | 50 caracteres |
| Pais donde reside           | pais          | VARCHAR           |                 | 20 caracteres |
| Provincia donde reside      | provincia     | VARCHAR           |                 | 30 caracteres |
| Ciudad donde reside         | ciudad        | VARCHAR           |                 | 40 caracteres |
| Calle de locación           | calle         | VARCHAR           |                 | 50 caracteres |
| Altura de la calle          | num_calle     | SMALLINT UNSIGNED |                 | 65535         |
| Firmas que representa       | firmas_repre  | JSON              |                 |               |

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
| Puesto laboral que opcupa    | puesto_lab   | UNSIGNED INTEGER  |                | 50 caracteres  |

### requisicion:
*Descripción: Esta tabla corresponde a una requisición o solicitud de compra que se envía a un determinado proveedor para que luego nos devuelva una cotización u oferta. Luego esa oferta será confirmada al proveedor para luego comprar o también se podrá cancelar. En conclusión, la requisición tendrá una serie definida de estados*
| Nombre del campo                | Abreviatura    | Tipo de datos     | Tipo de clave   | Valor máximo    |
|---------------------------------|----------------|-------------------|-----------------|-----------------|
| Identificador de la requisicion | id_requisicion | SMALLINT UNSIGNED | Clave primaria  | 65535           |
| Identificador del estado        | id_estado      | TINYINT UNSIGNED  | Clave foránea   | 255             |
| Identificador del proveedor     | id_proveedor   | SMALLINT UNSIGNED | Clave foránea   | 65535           |
| Fecha de la requisicion         | fecha          | DATE              |                 |                 |
| Numero de oferta                | num_oferta     | VARCHAR           |                 |                 |
| Link a la oferta                | link_oferta    | VARCHAR           |                 |                 |

### catalogo:
*Descripción: Esta tabla teiene la funcionalidad de interconectar o relacionar la tabla de insumos con la tabla de proveedores ya que en este caso se da una relacion de muchos a muchos, dicho de otra manera, muchos proveedores proveen muchos insumos. Un proveedor en su cartera de opciones puede contar con una gran cantidad de insumos. Visto del otro lado, un insumo es proveido por muchos proveedores.*

| Nombre del campo                  | Abreviatura      | Tipo de datos     | Tipo de clave  | Valor máximo |
|-----------------------------------|------------------|-------------------|----------------|--------------|
| Identificador de catalogo         | id_prove_insum   | SMALLINT UNSIGNED | Clave primaria | 65535        |
| Identificador del proveedor       | id_proveedor     | SMALLINT UNSIGNED | Clave foránea  | 65535        |
| Identificador del insumo          | id_insumo        | SMALLINT UNSIGNED | Clave foránea  | 65535        |
| Código del insumo según proveedor | codigo_insu_prov | VARCHAR           |                |              |

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
| Identificador de la lista de una req. | id_requisicion | SMALLINT UNSIGNED  | Clave foránea   | 65535        |
| Identificador de la requisicion       | id_requisicion | SMALLINT UNSIGNED  | Clave foránea   | 65535        |
| Identificador del insumo              | id_insumo      | SMALLINT UNSIGNED  | Clave foránea   | 65535        |
| Cantidad del insumo a solicitar       | cantidad       | MEDIUMINT UNSIGNED |                 | 16777215     |

## 4. Archivo SQL
*En el siguiente link puedes encontrar la query que crea la base de datos con sus respectivas tablas y configraciones:*  
[CLICKEA AQUI](/init_ind_shopping.sql)
#### 4.1. Mejoras
La base de datos que acabas de crear, tiene algunas dificultades técnicas que son corregidas según la siguiente query:  
[CLICKEA AQUÍ Y EJECUTA LA QUERY PARA TENER LA VERSIÓN MEJORADA](/init_ind_shopping_v2.sql)

# Segunda entrega - Vistas, triggers y population
En este apartado se agrearán vistas, funciones, stored procedures y un population con datos correspondientes a la base de datos creada en el apartado anterior o entregable 1.

## 5. Vistas

### Vista 1 - Inventario de Insumos
**Descripción:** esta vista muestra el inventario actual de insumos, incluyendo la cantidad en stock y el stock mínimo.  
**Objetivo:** mostrar de forma resumida y a posibles programas de terceros, la lista de todos los insumos que se tienen registrados con el stock actual y el minimo para analizar las posibles compras y o requisiciones de insumos a un almacén que los contenga para ser utilizados o consumidos.  
**Tablas/datos:**
| Nombre del campo          | Abreviatura  | Tabla origen |
|---------------------------|--------------|--------------|
| Identificador del insumo  | id_insumo    | insumo       |
| Descripción del insumo    | descripcion  | insumo       |
| Stock del insumo          | stock        | insumo       |
| Stock mínimo del insumo   | stock_min    | insumo       |

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
**Objetivo:** mostrar simplemente los insumos que provee un determinado proveedor para un rápido análisis de los posibles insumos a adquirir que pertenezcan a un mismo proveedor. Sería lograr algo así como la recomendación de añadir productos del mismo proveedor que recomienda Mercado Libre cuando se hace una compra. Esto trae beneficios monetarios, como descuentos, posibilidad de negociación y menos gastos de envío.
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

### Función 1 - Buscar insumo en tabla según descripción
**Descripción:** esta funcion busca un insumo en una tabla que lo contenga según se especifique. Luego trae los datos de ese insumo en esa tabla.  
**Objetivo:** Buscar rápidamente un insumo y los datos sobre él para poder ser analizado o planificar un consumo o compra.  
**Tablas/datos:**  

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

## 8. Archivos SQL

### 8.1. Script de creación de objetos:
*Descarga el siguiente archivo y ejecútalo para crear las vistas, funciones y stored procedures que te serán útiles en el día a día usando la db deñ Gestór de compras industriales*
[CLICKEA AQUÍ Y EJECUTA LA QUERY PARA CREAR LOS OBJETOS EN LA DB](/ind_shopping_objects_v1.sql)

### 8.2. Script de inserción de datos:
*Descarga el siguiente archivo y ejecútalo para poblar de datos las tablas de la base de datos a modo de ejemplo. Puede insertar los datos que correspondan a su negocio o industria.*
[CLICKEA AQUÍ Y EJECUTA PARA POBLAR DE DATOS LAS TABLAS DE LA DB](/ind_shopping_population.sql)
