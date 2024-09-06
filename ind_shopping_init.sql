-- Crear el schema
CREATE SCHEMA ind_shopping ;

-- Crear tabla "insumo"
CREATE TABLE ind_shopping.insumo (
  id_insumo SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  descripcion VARCHAR(100) NOT NULL,
  stock TINYINT NOT NULL DEFAULT 0,
  stock_min TINYINT,
  PRIMARY KEY (id_insumo)
);

-- Crear tabla "maquina"
CREATE TABLE ind_shopping.maquina (
  id_maquina TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  num_fabricacion VARCHAR(10) NOT NULL,
  anio_fabricacion YEAR NOT NULL,
  modelo VARCHAR(50) NOT NULL,
  diametro TINYINT NOT NULL,
  potencia TINYINT NULL,
  alimentadores TINYINT NULL,
  cant_agujas TINYINT NULL,
  PRIMARY KEY (id_maquina)
);

-- Crear tabla "proveedor"
CREATE TABLE ind_shopping.proveedor (
  id_proveedor TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  pais VARCHAR(50) NULL,
  provincia VARCHAR(50) NULL,
  ciudad VARCHAR(50) NULL,
  calle VARCHAR(100) NULL,
  num_calle TINYINT UNSIGNED NULL,
  PRIMARY KEY (id_proveedor)
);

-- Crear tabla "contacto"
CREATE TABLE ind_shopping.contacto (
	id_contacto TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_proveedor TINYINT UNSIGNED NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    mail VARCHAR(100) NOT NULL,
    telefono VARCHAR(15) NULL,
    puesto_lab VARCHAR(50) NULL,
    PRIMARY KEY (id_contacto),
    CONSTRAINT fk_contacto_proveedor
		FOREIGN KEY (id_proveedor)
        REFERENCES ind_shopping.proveedor (id_proveedor)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Crear tabla "estado_req"
CREATE TABLE ind_shopping.estado_req (
  id_estado TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  descripcion VARCHAR(100) NOT NULL,
  PRIMARY KEY (id_estado)
);

-- Crear tabla "requisición"
CREATE TABLE ind_shopping.requisicion (
	id_requisicion SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    fecha DATE NOT NULL,
    id_proveedor TINYINT UNSIGNED NULL,
    num_oferta VARCHAR(20) NULL,
    id_estado TINYINT UNSIGNED NOT NULL,
    solicitante VARCHAR(100) NOT NULL,
    comentario TEXT(10000) NULL,
	PRIMARY KEY (id_requisicion),
    CONSTRAINT fk_requisicion_proveedor
		FOREIGN KEY (id_proveedor)
		REFERENCES ind_shopping.proveedor (id_proveedor)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	CONSTRAINT fk_requisicion_estado
		FOREIGN KEY (id_estado)
		REFERENCES ind_shopping.estado_req (id_estado)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

-- Crear tabla "requisicion_lista"
CREATE TABLE ind_shopping.requisicion_lista (
	id_requi_enlista SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_requisicion SMALLINT UNSIGNED NOT NULL,
    id_insumo SMALLINT UNSIGNED NOT NULL,
    cantidad SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (id_requi_enlista),
    CONSTRAINT fk_requisicion_lista_requisicion
		FOREIGN KEY (id_requisicion)
		REFERENCES ind_shopping.requisicion (id_requisicion)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_requisicion_lista_insumo
		FOREIGN KEY (id_insumo)
		REFERENCES ind_shopping.insumo (id_insumo)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

-- Crear tabla "consumo"
CREATE TABLE ind_shopping.consumo (
	id_consumo INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_insumo SMALLINT UNSIGNED NOT NULL,
    id_maquina TINYINT UNSIGNED NOT NULL,
    cantidad SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (id_consumo),
    CONSTRAINT fk_consumo_insumo
		FOREIGN KEY (id_insumo)
		REFERENCES ind_shopping.insumo (id_insumo)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_consumo_maquina
		FOREIGN KEY (id_maquina)
		REFERENCES ind_shopping.maquina (id_maquina)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

-- Crear tabla "catalogo"
CREATE TABLE ind_shopping.catalogo (
	id_provee_insum INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_insumo SMALLINT UNSIGNED NOT NULL,
    id_proveedor TINYINT UNSIGNED NOT NULL,
    codigo_insu_prov CHAR(100) NULL,
    PRIMARY KEY (id_provee_insum),
    CONSTRAINT fk_catalogo_insumo
		FOREIGN KEY (id_insumo)
		REFERENCES ind_shopping.insumo (id_insumo)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_catalogo_proveedor
		FOREIGN KEY (id_proveedor)
		REFERENCES ind_shopping.proveedor (id_proveedor)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);