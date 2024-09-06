-- Usar la base de datos del gestor de compras industriales
USE ind_shopping;

-- Crear Vista 1: Inventario de Insumos
CREATE VIEW inventario_insumos AS
SELECT
	id_insumo,
    descripcion,
    stock,
    stock_min
FROM
	insumo;

-- Crear Vista 2 - Consumos por Máquina
CREATE VIEW consumos_por_maquina AS
SELECT 
    m.id_maquina,
    m.modelo,
    c.id_insumo,
    i.descripcion AS insumo_descripcion,
    c.cantidad
FROM 
    consumo c
JOIN 
    maquina m ON c.id_maquina = m.id_maquina
JOIN 
    insumo i ON c.id_insumo = i.id_insumo;

-- Crear Vista 3 - Requisiciones pendientes
CREATE VIEW requisiciones_pendientes AS
SELECT 
    r.id_requisicion,
    r.fecha,
    p.nombre AS proveedor_nombre,
    er.nombre AS estado,
    r.solicitante,
    r.comentario
FROM 
    requisicion r
JOIN 
    estado_req er ON r.id_estado = er.id_estado
JOIN 
    proveedor p ON r.id_proveedor = p.id_proveedor
WHERE 
    er.nombre != 'Completada';

-- Crear Vista 4 - Proveedores e Insumos Suministrados
CREATE VIEW proveedores_insumos AS
SELECT 
    p.id_proveedor,
    p.nombre AS proveedor_nombre,
    i.id_insumo,
    i.descripcion AS insumo_descripcion,
    c.codigo_insu_prov
FROM 
    proveedor p
JOIN 
    catalogo c ON p.id_proveedor = c.id_proveedor
JOIN 
    insumo i ON c.id_insumo = i.id_insumo;

-- Crear Vista 5 - Contactos por proveedor
CREATE VIEW contactos_proveedores AS
SELECT 
    p.nombre AS proveedor_nombre,
    c.nombre AS contacto_nombre,
    c.apellido,
    c.mail,
    c.telefono,
    c.puesto_lab
FROM 
    contacto c
JOIN 
    proveedor p ON c.id_proveedor = p.id_proveedor;

-- Crear Función 1: Buscar insumo en tabla según descripción
DELIMITER //

CREATE FUNCTION buscar_insumo_en_tabla(
    tabla VARCHAR(50),
    descripcion_parcial VARCHAR(100)
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE id_resultado INT;
    
    IF tabla = 'insumo' THEN
        SELECT id_insumo INTO id_resultado
        FROM insumo
        WHERE descripcion LIKE CONCAT('%', descripcion_parcial, '%')
        LIMIT 1;
        
    ELSEIF tabla = 'consumo' THEN
        SELECT c.id_insumo INTO id_resultado
        FROM consumo c
        JOIN insumo i ON c.id_insumo = i.id_insumo
        WHERE i.descripcion LIKE CONCAT('%', descripcion_parcial, '%')
        LIMIT 1;

    ELSEIF tabla = 'requisicion_lista' THEN
        SELECT rl.id_insumo INTO id_resultado
        FROM requisicion_lista rl
        JOIN insumo i ON rl.id_insumo = i.id_insumo
        WHERE i.descripcion LIKE CONCAT('%', descripcion_parcial, '%')
        LIMIT 1;
        
    ELSE
        SET id_resultado = NULL;
    END IF;

    RETURN id_resultado;
END //

DELIMITER ;

-- Crear Función 2: Buscar insumo en tabla según identificador
DELIMITER $$

CREATE FUNCTION buscar_insumo_por_id(in_id_insumo INT)
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE resultado VARCHAR(255);

    -- Buscar en la tabla insumo
    SELECT CONCAT('Insumo: ', descripcion) INTO resultado
    FROM insumo
    WHERE id_insumo = in_id_insumo;
    
    IF resultado IS NOT NULL THEN
        RETURN resultado;
    END IF;

    -- Buscar en la tabla consumo
    SELECT CONCAT('Insumo en consumo, cantidad: ', cantidad) INTO resultado
    FROM consumo
    WHERE id_insumo = in_id_insumo;
    
    IF resultado IS NOT NULL THEN
        RETURN resultado;
    END IF;

    -- Buscar en la tabla requisicion_lista
    SELECT CONCAT('Insumo en requisicion, cantidad: ', cantidad) INTO resultado
    FROM requisicion_lista
    WHERE id_insumo = in_id_insumo;
    
    IF resultado IS NOT NULL THEN
        RETURN resultado;
    END IF;

    -- Si no se encontró en ninguna tabla
    RETURN 'Insumo no encontrado';

END$$

DELIMITER ;

-- Crear Store Procedure de buscador general de estado de insumo
DELIMITER //

CREATE PROCEDURE buscar_insumo_en_todas_las_tablas(
    IN descripcion_parcial VARCHAR(100)
)
BEGIN
    -- Buscar en la tabla de insumo
    SELECT 'insumo' AS tabla, id_insumo, descripcion 
    FROM insumo 
    WHERE descripcion LIKE CONCAT('%', descripcion_parcial, '%');
    
    -- Buscar en la tabla de consumo
    SELECT 'consumo' AS tabla, c.id_insumo, i.descripcion 
    FROM consumo c
    JOIN insumo i ON c.id_insumo = i.id_insumo
    WHERE i.descripcion LIKE CONCAT('%', descripcion_parcial, '%');
    
    -- Buscar en la tabla de requisicion_lista
    SELECT 'requisicion_lista' AS tabla, rl.id_insumo, i.descripcion 
    FROM requisicion_lista rl
    JOIN insumo i ON rl.id_insumo = i.id_insumo
    WHERE i.descripcion LIKE CONCAT('%', descripcion_parcial, '%');
END //

DELIMITER ;


-- Crear store procedure de creación de requisición de compra
DELIMITER //

CREATE PROCEDURE crear_requisicion(
    in_id_proveedor INT,
    in_num_oferta VARCHAR(50),
    in_solicitante VARCHAR(100),
    in_comentario TEXT
)
BEGIN
    INSERT INTO requisicion (fecha, id_proveedor, num_oferta, id_estado, solicitante, comentario)
    VALUES (CURDATE(), in_id_proveedor, in_num_oferta, 1, in_solicitante, in_comentario);
END //

DELIMITER ;
