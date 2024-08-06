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
![Diagrama entidad relación](/images/der.jpg)

## 3. Listado de tablas

### insumo:
*Descripción: esta tabla corresponde a cada insumo que se utiliza en el mantenimiento de tejeduría y los datos necesarios para describirlo completamente*
|     Nombre del campo     | Abreviatura | Tipo de datos |  Tipo de clave  |
|--------------------------|-------------|---------------|-----------------|
| Identificador del insumo |  id_insumo  |     Entero    |  Clave primaria |
|  Descripción del insumo  |   descrip   |     String    |                 |
|    Cantidad del insumo   |    stock    |     Entero    |                 |

### maquina:
*Descripción: esta tabla corresponde a las maquinas que consumen insumos y producen tela. Tambien incluye los datos suficientes para describirla (faltan muchos otros pero no vienen al caso a no ser que se quiera complejizar enormemente la base de datos).*
| Nombre del campo            | Abreviatura   | Tipo de datos | Tipo de clave   |
|-----------------------------|---------------|---------------|-----------------|
| Identificador de la máquina | id_maquina    |     Entero    |  Clave primaria |
| Número de fabricación       | num_fabric    |     String    |                 |
| Año de fabricación          | anio_fabric   |     Entero    |                 |
| Modelo de la máquina        | modelo        |     String    |                 |
| Diámetro                    | diametro      |     Entero    |                 |
| Potencia                    | potencia      |     Entero    |                 |
| Alimentadores               | alimentadores |     Entero    |                 |

### proveedor:
*Descripción: Esta tabla corresponde a los proveedores de insumos y se añade las firmas que representan, aunque las propias firmas pueden ser proveedores.*
|       Nombre del campo      | Abreviatura   | Tipo de datos |  Tipo de clave  |
|-----------------------------|---------------|---------------|-----------------|
| Identificador de la máquina | id_maquina    |     Entero    |  Clave primaria |
| Número de fabricación       | num_fabric    |     String    |                 |
| Año de fabricación          | anio_fabric   |     Entero    |                 |
| Modelo de la máquina        | modelo        |     Entero    |                 |
| Tipo de tejidos             | tipo_tejidos  |     Entero    |                 |
| Diámetro                    | diametro      |     Entero    |                 |
| Potencia                    | potencia      |     Entero    |                 |
| Alimentadores               | alimentadores |     Entero    |                 |

### contacto:
*Descripción: Esta tabla representa a un contacto, que sería una persona que pertenece a una empresa que es proveedor y tiene la capacidad de guiarnos en el proceso de compra o consulta sobre insumos. Se añade los datos necesarios para justamente contactarnos con ella correctamente.*
| Nombre del campo             | Abreviatura   | Tipo de datos |  Tipo de clave  |
|------------------------------|---------------|---------------|-----------------|
| Identificador del contacto   | id_contacto   |     Entero    |  Clave primaria |
| Identificación del proveedor | num_fabric    |     Entero    |  Clave foránea  |
| Nombre del contacto          | nombre        |     String    |                 |
| Apellido del contacto        | apellido      |     String    |                 |
| Mail del contacto            | mail          |     String    |                 |
| Código de área               | cod_area      |     Entero    |                 |
| Teléfono del contacto        | telefono      |     String    |                 |

### requisicion:
*Descripción: Esta tabla corresponde a una requisición o solicitud de compra que se envía a un determinado proveedor para que luego nos devuelva una cotización u oferta. Luego esa oferta será confirmada al proveedor para luego comprar o también se podrá cancelar. En conclusiín, la requisición tendrá una serie definida de estados*
| Nombre del campo                | Abreviatura    | Tipo de datos |  Tipo de clave  |
|---------------------------------|----------------|---------------|-----------------|
| Identificador de la requisicion | id_requisicion |     Entero    | Clave primaria  |
| Fecha de la requisicion         | fecha          |     Entero    |                 |
| Identificador del proveedor     | id_proveedor   |     Entero    | Clave foránea   |
| Numero de oferta                | num_oferta     |     Entero    |                 |
| Identificador del estado        | id_estado      |     Entero    | Clave foránea   |
