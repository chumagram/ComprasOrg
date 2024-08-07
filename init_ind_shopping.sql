-- Crear el schema
CREATE SCHEMA `ind_shopping` ;

-- Crear tabla "insumo"
CREATE TABLE `ind_shopping`.`insumo` (
  `id_insumo` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `descripcion` CHAR(100) NOT NULL,
  `stock` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_insumo`),
  UNIQUE INDEX `id_insumo_UNIQUE` (`id_insumo` ASC) VISIBLE);

-- Crear tabla "maquina"
CREATE TABLE `ind_shopping`.`maquina` (
  `id_maquina` INT NOT NULL,
  `num_fabric` INT(6) NOT NULL,
  `anio_fabric` YEAR(4) NOT NULL,
  `modelo` CHAR(10) NOT NULL,
  `diametro` INT(2) NOT NULL,
  `potencia` INT(3) NULL,
  `alimentadores` INT(3) NULL,
  PRIMARY KEY (`id_maquina`),
  UNIQUE INDEX `id_maquina_UNIQUE` (`id_maquina` ASC) VISIBLE);

-- Crear tabla "proveedor"
CREATE TABLE `ind_shopping`.`proveedor` (
  `id_proveedor` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` CHAR(100) NOT NULL,
  `pais` CHAR(100) NULL,
  `provincia` CHAR(100) NULL,
  `ciudad` CHAR(100) NULL,
  `calle` CHAR(100) NULL,
  `num_calle` INT(5) UNSIGNED NULL,
  `firmas_repre` JSON NOT NULL,
  PRIMARY KEY (`id_proveedor`),
  UNIQUE INDEX `id_proveedor_UNIQUE` (`id_proveedor` ASC) VISIBLE);

-- Crear tabla "contacto"
CREATE TABLE `ind_shopping`.`contacto` (
  `id_contacto` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_proveedor` INT UNSIGNED NOT NULL,
  `nombre` CHAR(50) NOT NULL,
  `apellido` CHAR(50) NOT NULL,
  `mail` CHAR(100) NOT NULL,
  `cod_area` INT(4) NULL,
  `telefono` INT(10) NULL,
  PRIMARY KEY (`id_contacto`),
  UNIQUE INDEX `id_contacto_UNIQUE` (`id_contacto` ASC) VISIBLE);

-- Crear tabla "requisición"
CREATE TABLE `ind_shopping`.`requisicion` (
  `id_requisicion` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `fecha` DATE NULL,
  `id_proveedor` INT NULL,
  `num_oferta` INT NULL,
  `id_estado` INT NULL,
  PRIMARY KEY (`id_requisicion`),
  UNIQUE INDEX `id_requisicion_UNIQUE` (`id_requisicion` ASC) VISIBLE);

-- Crear tabla "insumo_proveedor"
CREATE TABLE `ind_shopping`.`insumo_proveedor` (
  `id_prove_insum` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_proveedor` INT NOT NULL,
  `id_insumo` INT NOT NULL,
  PRIMARY KEY (`id_prove_insum`),
  UNIQUE INDEX `id_prove_insum_UNIQUE` (`id_prove_insum` ASC) VISIBLE);

-- Crear tabla "estado_req"
CREATE TABLE `ind_shopping`.`estado_req` (
  `id_estado_req` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` CHAR(10) NOT NULL,
  `descripcion` CHAR(100) NOT NULL,
  PRIMARY KEY (`id_estado_req`),
  UNIQUE INDEX `id_estado_req_UNIQUE` (`id_estado_req` ASC) VISIBLE);

-- Crear tabla "maquina_insumo"
CREATE TABLE `ind_shopping`.`maquina_insumo` (
  `id_rel_ins_maq` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_insumo` INT NOT NULL,
  `id_maquina` INT NOT NULL,
  PRIMARY KEY (`id_rel_ins_maq`),
  UNIQUE INDEX `id_rel_ins_maq_UNIQUE` (`id_rel_ins_maq` ASC) VISIBLE);

-- Crear tabla "requisicion_lista_insumos"
CREATE TABLE `ind_shopping`.`requisicion_lista_insumos` (
  `id_requisicion` INT UNSIGNED NOT NULL,
  `id_insumo` INT UNSIGNED NOT NULL,
  `cantidad` INT(10) UNSIGNED NOT NULL);