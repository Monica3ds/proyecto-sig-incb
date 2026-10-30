-- =====================================================================
-- INSTITUTO NACIONAL DE CIUDAD BARRIOS (INCB) - CÓDIGO 12793
-- Módulo BTVDS 3.8 | Tarea 8: Script DDL y poblado de datos (DML)
-- Base de datos: sig_gerencial_incb | Gestor: MySQL / MariaDB
-- Contenido: 6 tablas InnoDB y 20 registros por tabla (120 en total)
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. CREACIÓN DE LA BASE DE DATOS
-- ---------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS sig_gerencial_incb
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_spanish_ci;

USE sig_gerencial_incb;

-- Se eliminan las tablas en orden inverso a su dependencia para poder
-- ejecutar el script varias veces sin errores.
DROP TABLE IF EXISTS detalle_ventas;
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS empleados;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;

-- ---------------------------------------------------------------------
-- 2. CREACIÓN DE TABLAS (DDL) - de las independientes a las dependientes
-- ---------------------------------------------------------------------

-- Tabla 1: categorias (independiente)
CREATE TABLE categorias (
    id_categoria     INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre_categoria VARCHAR(60)  NOT NULL,
    descripcion      VARCHAR(120) NOT NULL,
    PRIMARY KEY (id_categoria),
    UNIQUE KEY uq_categoria_nombre (nombre_categoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Tabla 2: clientes (independiente)
CREATE TABLE clientes (
    id_cliente      INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre_cliente  VARCHAR(80)  NOT NULL,
    telefono        VARCHAR(9)   NOT NULL,
    correo          VARCHAR(80)  NOT NULL,
    direccion       VARCHAR(120) NOT NULL,
    fecha_registro  DATE         NOT NULL,
    PRIMARY KEY (id_cliente),
    UNIQUE KEY uq_cliente_correo (correo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Tabla 3: empleados (independiente)
CREATE TABLE empleados (
    id_empleado        INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    nombre_empleado    VARCHAR(80)   NOT NULL,
    cargo              VARCHAR(50)   NOT NULL,
    salario            DECIMAL(10,2) NOT NULL,
    fecha_contratacion DATE          NOT NULL,
    PRIMARY KEY (id_empleado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Tabla 4: productos (depende de categorias)
CREATE TABLE productos (
    id_producto     INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    nombre_producto VARCHAR(80)   NOT NULL,
    id_categoria    INT UNSIGNED  NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    stock           INT           NOT NULL DEFAULT 0,
    stock_minimo    INT           NOT NULL DEFAULT 5,
    fecha_ingreso   DATE          NOT NULL,
    PRIMARY KEY (id_producto),
    CONSTRAINT fk_productos_categoria
        FOREIGN KEY (id_categoria) REFERENCES categorias (id_categoria)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Tabla 5: ventas (depende de clientes y empleados)
CREATE TABLE ventas (
    id_venta     INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_cliente   INT UNSIGNED  NOT NULL,
    id_empleado  INT UNSIGNED  NOT NULL,
    fecha_venta  DATE          NOT NULL,
    total_venta  DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_venta),
    CONSTRAINT fk_ventas_cliente
        FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_ventas_empleado
        FOREIGN KEY (id_empleado) REFERENCES empleados (id_empleado)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Tabla 6: detalle_ventas (depende de ventas y productos)
CREATE TABLE detalle_ventas (
    id_detalle       INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_venta         INT UNSIGNED  NOT NULL,
    id_producto      INT UNSIGNED  NOT NULL,
    cantidad         INT           NOT NULL,
    precio_unitario  DECIMAL(10,2) NOT NULL,
    subtotal         DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_detalle),
    CONSTRAINT fk_detalle_venta
        FOREIGN KEY (id_venta) REFERENCES ventas (id_venta)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (id_producto) REFERENCES productos (id_producto)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- ---------------------------------------------------------------------
-- 3. POBLADO DE DATOS (DML) - 20 registros por tabla
-- ---------------------------------------------------------------------

-- categorias (20)
INSERT INTO categorias (nombre_categoria, descripcion) VALUES
('Bebidas', 'Gaseosas, jugos, agua y bebidas energéticas'),
('Granos Básicos', 'Arroz, frijoles, maíz y harinas'),
('Lácteos', 'Leche, queso, crema y yogurt'),
('Panadería', 'Pan dulce, pan francés y repostería'),
('Carnes y Embutidos', 'Pollo, res, cerdo y embutidos'),
('Frutas y Verduras', 'Productos frescos de temporada'),
('Snacks', 'Botanas y frituras empacadas'),
('Dulces y Golosinas', 'Caramelos, chocolates y golosinas'),
('Limpieza del Hogar', 'Detergentes, jabones y desinfectantes'),
('Higiene Personal', 'Jabón, pasta dental y papel higiénico'),
('Enlatados', 'Conservas y alimentos enlatados'),
('Condimentos y Salsas', 'Especias, salsas y sazonadores'),
('Aceites y Grasas', 'Aceites vegetales y mantequilla'),
('Cereales y Desayuno', 'Cereales, avena y galletas'),
('Papelería', 'Cuadernos, lápices y artículos de oficina'),
('Mascotas', 'Alimento y accesorios para mascotas'),
('Congelados', 'Productos congelados y helados'),
('Bebé', 'Pañales, fórmulas y cuidado infantil'),
('Cuidado del Cabello', 'Shampoo, acondicionador y cremas'),
('Utensilios del Hogar', 'Platos, vasos y utensilios de cocina');

-- clientes (20)
INSERT INTO clientes (nombre_cliente, telefono, correo, direccion, fecha_registro) VALUES
('María Fernanda López', '7012-3456', 'maria.lopez@correo.com', 'Barrio El Centro, Ciudad Barrios', '2026-01-12'),
('José Armando Rivera', '7134-5521', 'jose.rivera@correo.com', 'Colonia San Antonio, Ciudad Barrios', '2026-01-18'),
('Ana Patricia Mejía', '7245-8890', 'ana.mejia@correo.com', 'Barrio La Cruz, Ciudad Barrios', '2026-01-25'),
('Carlos Eduardo Portillo', '7356-1204', 'carlos.portillo@correo.com', 'Cantón El Carrizal, Ciudad Barrios', '2026-02-02'),
('Sandra Elizabeth Hernández', '7467-9033', 'sandra.hernandez@correo.com', 'Barrio San Francisco, Ciudad Barrios', '2026-02-09'),
('Luis Alberto Argueta', '7578-4410', 'luis.argueta@correo.com', 'Colonia Las Flores, Ciudad Barrios', '2026-02-16'),
('Karla Beatriz Martínez', '7689-7752', 'karla.martinez@correo.com', 'Barrio El Calvario, Ciudad Barrios', '2026-02-23'),
('Roberto Antonio Chávez', '7790-2268', 'roberto.chavez@correo.com', 'Cantón Joateca, Ciudad Barrios', '2026-03-04'),
('Gloria Marisol Ramírez', '7801-6639', 'gloria.ramirez@correo.com', 'Barrio Concepción, Ciudad Barrios', '2026-03-11'),
('Miguel Ángel Guzmán', '7912-3085', 'miguel.guzman@correo.com', 'Colonia Santa Lucía, Ciudad Barrios', '2026-03-18'),
('Verónica Lisseth Alvarado', '6023-5174', 'veronica.alvarado@correo.com', 'Barrio El Rosario, Ciudad Barrios', '2026-03-25'),
('Francisco Javier Cruz', '6134-8821', 'francisco.cruz@correo.com', 'Cantón El Zapote, Ciudad Barrios', '2026-04-01'),
('Rosa Elena Quintanilla', '6245-3397', 'rosa.quintanilla@correo.com', 'Colonia Brisas del Norte, Ciudad Barrios', '2026-04-08'),
('Héctor Daniel Villatoro', '6356-7746', 'hector.villatoro@correo.com', 'Barrio Guadalupe, Ciudad Barrios', '2026-04-15'),
('Claudia Yaneth Ortiz', '6467-1580', 'claudia.ortiz@correo.com', 'Barrio El Centro, Ciudad Barrios', '2026-04-22'),
('Jorge Alexander Peña', '6578-9203', 'jorge.pena@correo.com', 'Cantón La Joya, Ciudad Barrios', '2026-05-06'),
('Dalila Concepción Flores', '6689-4415', 'dalila.flores@correo.com', 'Colonia San José, Ciudad Barrios', '2026-05-13'),
('Wilfredo Ernesto Amaya', '6790-5527', 'wilfredo.amaya@correo.com', 'Barrio San Sebastián, Ciudad Barrios', '2026-05-20'),
('Yesenia Carolina Benítez', '6801-2639', 'yesenia.benitez@correo.com', 'Colonia Los Pinos, Ciudad Barrios', '2026-06-03'),
('Oscar Mauricio Salmerón', '6912-8741', 'oscar.salmeron@correo.com', 'Cantón El Palón, Ciudad Barrios', '2026-06-10');

-- empleados (20)
INSERT INTO empleados (nombre_empleado, cargo, salario, fecha_contratacion) VALUES
('Edwin Geovani Sosa', 'Gerente General', 650.00, '2024-02-05'),
('Diego Abel Ascencio Castillo', 'Administrador de Inventario', 520.00, '2024-03-11'),
('César Daniel Castillo Jovel', 'Jefe de Ventas', 540.00, '2024-03-18'),
('Mónica Liliana Membreño Rivas', 'Cajera Principal', 420.00, '2024-05-06'),
('Reina Isabel Cañas', 'Cajera', 380.00, '2024-06-10'),
('Marvin Josué Henríquez', 'Cajero', 380.00, '2024-07-15'),
('Estela Margarita Pineda', 'Vendedora de Mostrador', 365.00, '2024-08-19'),
('Nelson Rolando Lazo', 'Vendedor de Mostrador', 365.00, '2024-09-02'),
('Lidia Noemí Fuentes', 'Encargada de Bodega', 450.00, '2024-10-07'),
('Ricardo Ismael Mena', 'Auxiliar de Bodega', 340.00, '2024-11-11'),
('Silvia Maribel Aguilar', 'Auxiliar de Bodega', 340.00, '2025-01-13'),
('Walter Omar Escobar', 'Repartidor', 355.00, '2025-02-17'),
('Cecilia Raquel Campos', 'Contadora', 600.00, '2025-03-10'),
('Josué David Rosales', 'Auxiliar Contable', 410.00, '2025-04-14'),
('Alba Luz Tobar', 'Vendedora de Mostrador', 365.00, '2025-05-19'),
('Samuel Antonio Girón', 'Seguridad', 330.00, '2025-06-23'),
('Fátima Yamileth Orellana', 'Cajera', 380.00, '2025-08-04'),
('Byron Alexis Serrano', 'Repartidor', 355.00, '2025-09-15'),
('Karen Julissa Mendoza', 'Atención al Cliente', 395.00, '2026-01-12'),
('Mauricio Esteban Rauda', 'Auxiliar de Ventas', 350.00, '2026-03-02');

-- productos (20)
INSERT INTO productos (nombre_producto, id_categoria, precio_unitario, stock, stock_minimo, fecha_ingreso) VALUES
('Gaseosa Cola 2L', 1, 1.75, 60, 10, '2026-08-03'),
('Frijol Rojo de Seda 1 lb', 2, 1.10, 120, 20, '2026-08-03'),
('Leche Entera 1 L', 3, 1.15, 80, 15, '2026-08-05'),
('Pan Francés (paquete 6 u)', 4, 1.50, 40, 8, '2026-08-10'),
('Pechuga de Pollo 1 lb', 5, 2.80, 35, 6, '2026-08-10'),
('Tomate Fresco 1 lb', 6, 0.75, 70, 10, '2026-08-12'),
('Papas Fritas 150 g', 7, 1.25, 90, 12, '2026-08-12'),
('Chocolate en Barra 40 g', 8, 0.60, 150, 25, '2026-08-14'),
('Detergente en Polvo 1 kg', 9, 3.20, 45, 8, '2026-08-14'),
('Jabón de Baño (3 u)', 10, 2.25, 65, 10, '2026-08-17'),
('Atún en Lata 140 g', 11, 1.40, 100, 15, '2026-08-17'),
('Salsa de Tomate 400 g', 12, 1.30, 55, 10, '2026-08-19'),
('Aceite Vegetal 900 ml', 13, 3.50, 50, 8, '2026-08-19'),
('Cereal de Maíz 300 g', 14, 2.60, 40, 8, '2026-08-21'),
('Cuaderno Universitario 100 h', 15, 1.85, 75, 12, '2026-08-21'),
('Alimento para Perro 2 kg', 16, 6.90, 25, 5, '2026-08-24'),
('Helado de Vainilla 1 L', 17, 3.75, 30, 6, '2026-08-24'),
('Pañales Talla M (paquete 30)', 18, 8.50, 28, 5, '2026-08-26'),
('Shampoo 400 ml', 19, 3.95, 42, 8, '2026-08-26'),
('Vaso Plástico (paquete 25 u)', 20, 1.20, 85, 12, '2026-08-28');

-- ventas (20): total_venta = suma de los subtotales de su detalle
INSERT INTO ventas (id_cliente, id_empleado, fecha_venta, total_venta) VALUES
(1, 4, '2026-09-01', 5.25),
(2, 5, '2026-09-01', 5.50),
(3, 6, '2026-09-02', 4.60),
(4, 4, '2026-09-02', 5.60),
(5, 7, '2026-09-03', 7.50),
(6, 5, '2026-09-03', 3.20),
(7, 8, '2026-09-04', 11.20),
(8, 4, '2026-09-05', 7.00),
(9, 6, '2026-09-05', 7.00),
(10, 15, '2026-09-06', 7.80),
(11, 5, '2026-09-07', 8.50),
(12, 7, '2026-09-08', 11.00),
(13, 4, '2026-09-08', 6.75),
(14, 17, '2026-09-09', 4.50),
(15, 8, '2026-09-10', 9.25),
(16, 6, '2026-09-10', 6.90),
(17, 15, '2026-09-11', 3.50),
(18, 5, '2026-09-12', 6.90),
(19, 17, '2026-09-13', 7.90),
(20, 4, '2026-09-14', 5.20);

-- detalle_ventas (20): subtotal = cantidad x precio_unitario
INSERT INTO detalle_ventas (id_venta, id_producto, cantidad, precio_unitario, subtotal) VALUES
(1, 1, 3, 1.75, 5.25),
(2, 2, 5, 1.10, 5.50),
(3, 3, 4, 1.15, 4.60),
(4, 5, 2, 2.80, 5.60),
(5, 7, 6, 1.25, 7.50),
(6, 9, 1, 3.20, 3.20),
(7, 11, 8, 1.40, 11.20),
(8, 13, 2, 3.50, 7.00),
(9, 1, 4, 1.75, 7.00),
(10, 14, 3, 2.60, 7.80),
(11, 18, 1, 8.50, 8.50),
(12, 2, 10, 1.10, 11.00),
(13, 10, 3, 2.25, 6.75),
(14, 6, 6, 0.75, 4.50),
(15, 15, 5, 1.85, 9.25),
(16, 3, 6, 1.15, 6.90),
(17, 1, 2, 1.75, 3.50),
(18, 16, 1, 6.90, 6.90),
(19, 19, 2, 3.95, 7.90),
(20, 12, 4, 1.30, 5.20);

-- ---------------------------------------------------------------------
-- 4. VERIFICACIÓN: conteo de registros por tabla (cada una debe dar 20)
-- ---------------------------------------------------------------------
SELECT 'categorias' AS tabla, COUNT(*) AS registros FROM categorias
UNION ALL SELECT 'clientes', COUNT(*) FROM clientes
UNION ALL SELECT 'empleados', COUNT(*) FROM empleados
UNION ALL SELECT 'productos', COUNT(*) FROM productos
UNION ALL SELECT 'ventas', COUNT(*) FROM ventas
UNION ALL SELECT 'detalle_ventas', COUNT(*) FROM detalle_ventas;

-- Verificación de coherencia matemática (debe devolver 0 filas):
SELECT d.id_detalle
FROM detalle_ventas d
WHERE d.subtotal <> d.cantidad * d.precio_unitario;

-- Verificación: el total de cada venta coincide con la suma de su detalle (0 filas):
SELECT v.id_venta
FROM ventas v
JOIN (SELECT id_venta, SUM(subtotal) AS suma FROM detalle_ventas GROUP BY id_venta) s
  ON s.id_venta = v.id_venta
WHERE v.total_venta <> s.suma;
