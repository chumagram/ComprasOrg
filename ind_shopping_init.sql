-- Crear el schema
CREATE SCHEMA ind_shopping;

-- Crear tabla "categoria_insumo"
CREATE TABLE ind_shopping.categoria_insumo (
  id_categoria_insumo SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(30) NOT NULL,
  descripcion VARCHAR(150) NOT NULL,
  PRIMARY KEY (id_categoria_insumo)
);

-- Crear tabla "insumo"
CREATE TABLE ind_shopping.insumo (
  id_insumo SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  descripcion VARCHAR(100) NOT NULL,
  stock MEDIUMINT UNSIGNED NOT NULL DEFAULT 0,
  stock_max MEDIUMINT UNSIGNED,
  stock_min SMALLINT UNSIGNED,
  id_categoria_insumo SMALLINT UNSIGNED,
  PRIMARY KEY (id_insumo),
  CONSTRAINT fk_insumo_categoria
		FOREIGN KEY (id_categoria_insumo)
        REFERENCES ind_shopping.categoria_insumo (id_categoria_insumo)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Crear tabla "maquina"
CREATE TABLE ind_shopping.maquina (
  id_maquina CHAR(5) NOT NULL,
  num_interno SMALLINT UNSIGNED,
  num_fabricacion MEDIUMINT UNSIGNED NOT NULL,
  anio_fabricacion YEAR NOT NULL,
  fabricante VARCHAR(8) NOT NULL,
  modelo VARCHAR(50) NOT NULL,
  diametro TINYINT UNSIGNED NOT NULL,
  potencia TINYINT UNSIGNED NULL,
  unidad_med CHAR(2) NOT NULL,
  alimentadores TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (id_maquina)
);

-- Crear tabla "proveedor"
CREATE TABLE ind_shopping.proveedor (
  id_proveedor SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  pais VARCHAR(20) NULL,
  provincia VARCHAR(30) NULL,
  ciudad VARCHAR(40) NULL,
  calle VARCHAR(50) NULL,
  num_calle SMALLINT UNSIGNED NULL,
  PRIMARY KEY (id_proveedor)
);

-- Crear tabla "firma"
CREATE TABLE ind_shopping.firma (
  id_firma SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  pais VARCHAR(20) NULL,
  moneda VARCHAR(5) NULL,
  PRIMARY KEY (id_firma)
);

-- Crear tabla "representacion"
CREATE TABLE ind_shopping.representacion (
  id_representacion SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_firma SMALLINT UNSIGNED NOT NULL,
  id_proveedor SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (id_representacion),
  CONSTRAINT fk_proveedor_representacion
		FOREIGN KEY (id_proveedor)
        REFERENCES ind_shopping.proveedor (id_proveedor)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
  CONSTRAINT fk_firma_representacion
		FOREIGN KEY (id_firma)
        REFERENCES ind_shopping.firma (id_firma)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Crear tabla "contacto"
CREATE TABLE ind_shopping.contacto (
	id_contacto SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_proveedor SMALLINT UNSIGNED NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    mail VARCHAR(100) NOT NULL,
    telefono CHAR(16) NULL,
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
  id_estado_req TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(30) NOT NULL,
  descripcion VARCHAR(150) NOT NULL,
  PRIMARY KEY (id_estado_req)
);

-- Crear tabla "requisición"
CREATE TABLE ind_shopping.requisicion (
	id_requisicion SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_estado_req TINYINT UNSIGNED NOT NULL,
    id_proveedor SMALLINT UNSIGNED NULL,
    fecha DATE NOT NULL,
    num_oferta VARCHAR(20) NULL,
    link_oferta VARCHAR(1000),
	PRIMARY KEY (id_requisicion),
    CONSTRAINT fk_requisicion_proveedor
		FOREIGN KEY (id_proveedor)
		REFERENCES ind_shopping.proveedor (id_proveedor)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	CONSTRAINT fk_requisicion_estado
		FOREIGN KEY (id_estado_req)
		REFERENCES ind_shopping.estado_req (id_estado_req)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

-- Crear tabla "requisicion_lista"
CREATE TABLE ind_shopping.requisicion_lista (
	id_lista_req SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_requisicion SMALLINT UNSIGNED NOT NULL,
    id_insumo SMALLINT UNSIGNED NOT NULL,
    cantidad MEDIUMINT UNSIGNED NOT NULL,
    PRIMARY KEY (id_lista_req),
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
	id_consumo MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_insumo SMALLINT UNSIGNED NOT NULL,
    id_maquina CHAR(5) NULL,
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
	id_provee_insum SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_proveedor SMALLINT UNSIGNED NOT NULL,
    id_insumo SMALLINT UNSIGNED NOT NULL,
    codigo_insu_prov VARCHAR(20) NULL,
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