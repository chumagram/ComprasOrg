-- Usar la base de datos del gestor de compras industriales
USE ind_shopping;

-- Crear Vista 1: Insumos con deficit de stock ordenados segun urgencia
CREATE VIEW inventario_stock_bajo AS
SELECT 
    id_insumo, 
    descripcion, 
    stock, 
    stock_min, 
    stock_max,
    ((stock_min - stock) / stock_min * 100) AS diferencia_porcentual
FROM insumo
WHERE stock < stock_min
ORDER BY diferencia_porcentual DESC;

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
    r.link_oferta
FROM 
    requisicion r
JOIN 
    estado_req er ON r.id_estado_req = er.id_estado_req
JOIN 
    proveedor p ON r.id_proveedor = p.id_proveedor
WHERE 
    er.nombre != 'Llegó completo';

-- Crear Vista 4 - Proveedores e Insumos Suministrados
CREATE VIEW proveedores_insumos AS
SELECT 
    p.id_proveedor,
    p.nombre AS proveedor_nombre,
    i.id_insumo,
    i.descripcion AS insumo_descripcion
FROM 
    proveedor p
JOIN 
    catalogo c ON p.id_proveedor = c.id_proveedor
JOIN 
    insumo i ON c.id_insumo = i.id_insumo;

-- Crear Vista 5 - Contactos por proveedor
CREATE VIEW contactos_por_proveedor AS
SELECT 
    proveedor.nombre AS nombre_proveedor,
    contacto.nombre AS nombre_contacto,
    contacto.apellido,
    contacto.puesto_lab,
    contacto.telefono,
    contacto.mail
FROM contacto
JOIN proveedor ON contacto.id_proveedor = proveedor.id_proveedor
ORDER BY proveedor.nombre ASC;

-- Crear Función 1: Verificar stock disponible de un insumo
DELIMITER //
CREATE FUNCTION verificar_stock_disponible(id_insumo_param INT, cantidad INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE stock_actual INT;

    SELECT stock INTO stock_actual
    FROM insumo
    WHERE id_insumo = id_insumo_param;

    IF stock_actual >= cantidad THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END//
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

-- Crear Store Procedure 1: buscador de insumo en tabla según parte de la descripción
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

-- Crear store procedure 2: creación de requisición de compra
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

-- Crear store procedure 3: Buscar histórico de consumo de un determinado insumo

-- Crear TRIGGER para actualizar el stock luego de un consumo
DELIMITER //
CREATE TRIGGER actualizar_stock_consumo
AFTER INSERT ON consumo
FOR EACH ROW
BEGIN
    UPDATE insumo
    SET stock = stock - NEW.cantidad
    WHERE id_insumo = NEW.id_insumo;
END //
DELIMITER ;

-- Crear TRIGGER para actualizar el stock luego de que se registra una requisición como que llegó completo
DELIMITER //
CREATE TRIGGER actualizar_stock_requisicion_llego
AFTER UPDATE ON requisicion
FOR EACH ROW
BEGIN
    -- Declaración de variables
    DECLARE done INT DEFAULT 0;
    DECLARE req_insumo_id INT;
    DECLARE req_cantidad INT;

    -- Cursor para seleccionar los insumos de la requisición que llegó
    DECLARE cur CURSOR FOR 
    SELECT id_insumo, cantidad 
    FROM requisicion_lista 
    WHERE id_requisicion = NEW.id_requisicion;

    -- Handler para cerrar el cursor al terminar
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Verificar si el estado cambió a 'llegó'
    IF NEW.id_estado = 10 THEN
        OPEN cur;
        
        read_loop: LOOP
            FETCH cur INTO req_insumo_id, req_cantidad;
            IF done THEN
                LEAVE read_loop;
            END IF;

            -- Actualizar el stock del insumo correspondiente
            UPDATE insumo
            SET stock = stock + req_cantidad
            WHERE id_insumo = req_insumo_id;

        END LOOP;

        CLOSE cur;
    END IF;
END//
DELIMITER ;