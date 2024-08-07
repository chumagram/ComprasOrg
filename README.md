# Proyecto Final
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
![Diagrama entidad relación](/DER.jpg)

## 3. Listado de tablas

### insumo:
*Descripción: esta tabla corresponde a cada insumo que se utiliza en el mantenimiento de tejeduría y los datos necesarios para describirlo completamente*
| Nombre del campo         | Abreviatura | Tipo de datos    | Tipo de clave   |
|--------------------------|-------------|------------------|-----------------|
| Identificador del insumo | id_insumo   | UNSIGNED INTEGER | Clave primaria  |
| Descripción del insumo   | descrip     | CHAR             |                 |
| Cantidad del insumo      | stock       | UNSIGNED TINYINT |                 |

### maquina:
*Descripción: esta tabla corresponde a las maquinas que consumen insumos y producen tela. Tambien incluye los datos suficientes para describirla (faltan muchos otros pero no vienen al caso a no ser que se quiera complejizar enormemente la base de datos).*
| Nombre del campo            | Abreviatura   | Tipo de datos    | Tipo de clave   |
|-----------------------------|---------------|------------------|-----------------|
| Identificador de la máquina | id_maquina    | UNSIGNED TINYINT | Clave primaria  |
| Número de fabricación       | num_fabric    | UNSIGNED INTEGER |                 |
| Año de fabricación          | anio_fabric   | YEAR             |                 |
| Modelo de la máquina        | modelo        | CHAR             |                 |
| Diámetro                    | diametro      | UNSIGNED TINYINT |                 |
| Potencia                    | potencia      | UNSIGNED TINYINT |                 |
| Alimentadores               | alimentadores | UNSIGNED TINYINT |                 |

### proveedor:
*Descripción: Esta tabla corresponde a los proveedores de insumos y se añade las firmas que representan, aunque las propias firmas pueden ser proveedores.*
|       Nombre del campo      | Abreviatura   | Tipo de datos    |  Tipo de clave  |
|-----------------------------|---------------|------------------|-----------------|
| Identificador del proveedor | id_proveedor  | UNSIGNED TINYINT |  Clave primaria |
| Nombre del proveedor        | nombre        | CHAR             |                 |
| Pais donde reside           | pais          | CHAR             |                 |
| Provincia donde reside      | provincia     | CHAR             |                 |
| Ciudad donde reside         | ciudad        | CHAR             |                 |
| Calle de locación           | calle         | CHAR             |                 |
| Altura de la calle          | num_calle     | UNSIGNED TINYINT |                 |
| Firmas que representa       | firmas_repre  | JSON             |                 |

### contacto:
*Descripción: Esta tabla representa a un contacto, que sería una persona que pertenece a una empresa que es proveedor y tiene la capacidad de guiarnos en el proceso de compra o consulta sobre insumos. Se añade los datos necesarios para justamente contactarnos con ella correctamente.*
| Nombre del campo             | Abreviatura   | Tipo de datos    | Tipo de clave  |
|------------------------------|---------------|------------------|----------------|
| Identificador del contacto   | id_contacto   | UNSIGNED TINYINT | Clave primaria |
| Identificación del proveedor | num_fabric    | UNSIGNED TINYINT | Clave foránea  |
| Nombre del contacto          | nombre        | CHAR             |                |
| Apellido del contacto        | apellido      | CHAR             |                |
| Mail del contacto            | mail          | CHAR             |                |
| Código de área               | cod_area      | UNSIGNED TINYINT |                |
| Teléfono del contacto        | telefono      | UNSIGNED INTEGER |                |

### requisicion:
*Descripción: Esta tabla corresponde a una requisición o solicitud de compra que se envía a un determinado proveedor para que luego nos devuelva una cotización u oferta. Luego esa oferta será confirmada al proveedor para luego comprar o también se podrá cancelar. En conclusión, la requisición tendrá una serie definida de estados*
| Nombre del campo                | Abreviatura    | Tipo de datos    | Tipo de clave   |
|---------------------------------|----------------|------------------|-----------------|
| Identificador de la requisicion | id_requisicion | UNSIGNED TINYINT | Clave primaria  |
| Fecha de la requisicion         | fecha          | DATE             |                 |
| Identificador del proveedor     | id_proveedor   | UNSIGNED TINYINT | Clave foránea   |
| Numero de oferta                | num_oferta     | UNSIGNED INTEGER |                 |
| Identificador del estado        | id_estado      | UNSIGNED TINYINT | Clave foránea   |

### insumo_proveedor:
*Descripción: Esta tabla teiene la funcionalidad de interconectar o relacionar la tabla de insumos con la tabla de proveedores ya que en este caso se da una relacion de muchos a muchos, dicho de otra manera, muchos proveedores proveen muchos insumos. Un proveedor en su cartera de opciones puede contar con una gran cantidad de insumos. Visto del otro lado, un insumo es proveido por muchos proveedores.*

| Nombre del campo                           | Abreviatura    | Tipo de datos    |  Tipo de clave  |
|--------------------------------------------|----------------|------------------|-----------------|
| Identificador de relacion proveedor-insumo | id_prove_insum | UNSIGNED TINYINT | Clave primaria  |
| Identificador del proveedor                | id_proveedor   | UNSIGNED TINYINT | Clave foránea   |
| Identificador del insumo                   | id_insumo      | UNSIGNED TINYINT | Clave foránea   |

### estado_req:
*Descripción: Esta tabla tiene la funcion de contener los posbiles estados que pueda terner una requisicion. maquina_insumo*

| Nombre del campo                       | Abreviatura   | Tipo de datos    |  Tipo de clave  |
|----------------------------------------|---------------|------------------|-----------------|
| Identificador de estado de requisicion | id_estado_req | UNSIGNED TINYINT | Clave primaria  |
| Nombre del estado                      | nombre        | CHAR             |                 |
| Descripcion del estado                 | descripcion   | CHAR             |                 |

### maquina_insumo:
*Descripción: Esta tabla tiene la funcion de ser nexo y lograr la relacion entre las tablas maquina y la tabla insumo ya que entre ellas se da una relacion de muchos a muchos. La explicacion de esto sería de que una maquina puede utilzar muchos y diversos tipos de insumo, como así tambien un insumo puede ser ocupado en muchas maquinas ya que en la organizacion se cuenta con 116 máquinas circulares tejedoras, muy similares una con las otras.*

| Nombre del campo                  | Abreviatura    | Tipo de datos    |  Tipo de clave  |
|-----------------------------------|----------------|------------------|-----------------|
| Id. de la relacion maquina-insumo | id_rel_ins_maq | UNSIGNED TINYINT | Clave primaria  |
| Identificador de insumo           | id_insumo      | UNSIGNED TINYINT | Clave foránea   |
| Identificador de la máquina       | id_maquina     | UNSIGNED TINYINT | Clave foránea   |

### requisicion_lista_insumos:
*Descripción: Esta tabla tiene la funcion de contener la lista de insumos pero asignándole una cierta cantidad y requisición específica. Esto es debido a que en una requisicion o solicitud de compra, además de los datos de la requisición en sí, también se tiene una tabla adentro de la misma que contiene la lista de insumos a pedir.*

| Nombre del campo                | Abreviatura    | Tipo de datos    |  Tipo de clave  |
|---------------------------------|----------------|------------------|-----------------|
| Identificador de la requisicion | id_requisicion | UNSIGNED TINYINT | Clave foránea   |
| Identificador del insumo        | id_insumo      | UNSIGNED TINYINT | Clave foránea   |
| Cantidad del insumo a solicitar | cantidad       | UNSIGNED TINYINT |                 |

## 4. Archivo SQL
*En el siguiente link puedes encontrar la query que crea la base de datos con sus respectivas tablas y configraciones:*
[CLICKEA AQUI](/init_ind_shopping.sql)
