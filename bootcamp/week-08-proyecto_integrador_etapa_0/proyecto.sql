-- ============================================
-- PROYECTO INTEGRADOR: Etapa 0 — Capstone
-- Semana 08 — DDL + DML + SELECT completo
-- Dominio: Tienda de Juguetes
-- ============================================

PRAGMA foreign_keys = ON;

-- ============================================
-- PARTE 1: ESQUEMA (DDL)
-- ============================================

DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS age_ranges;

-- Tabla de rangos de edad (referencia)
CREATE TABLE age_ranges (
    id      INTEGER PRIMARY KEY,
    name    TEXT    NOT NULL UNIQUE,
    min_age INTEGER NOT NULL CHECK (min_age >= 0),
    max_age INTEGER CHECK (max_age IS NULL OR max_age > min_age)
);

-- Tabla de proveedores
CREATE TABLE suppliers (
    id        INTEGER PRIMARY KEY,
    name      TEXT    NOT NULL UNIQUE,
    country   TEXT    NOT NULL DEFAULT 'México',
    contact   TEXT,                              -- opcional
    is_active INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1))
);

-- Tabla principal de productos
CREATE TABLE products (
    id           INTEGER PRIMARY KEY,
    sku          TEXT    NOT NULL UNIQUE,
    name         TEXT    NOT NULL,
    category     TEXT    NOT NULL,
    price        REAL    NOT NULL CHECK (price > 0),
    stock        INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    description  TEXT,                           -- opcional (puede ser NULL)
    is_active    INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1)),
    age_range_id INTEGER NOT NULL
        REFERENCES age_ranges(id) ON DELETE RESTRICT,
    supplier_id  INTEGER
        REFERENCES suppliers(id) ON DELETE SET NULL
);

-- Tabla de ventas
CREATE TABLE sales (
    id          INTEGER PRIMARY KEY,
    sale_date   TEXT    NOT NULL DEFAULT (DATE('now')),
    quantity    INTEGER NOT NULL CHECK (quantity > 0),
    unit_price  REAL    NOT NULL CHECK (unit_price > 0),
    product_id  INTEGER NOT NULL
        REFERENCES products(id) ON DELETE RESTRICT
);


-- ============================================
-- PARTE 2: DATOS (DML)
-- ============================================

INSERT INTO age_ranges (id, name, min_age, max_age) VALUES
    (1, '0-2 años',  0,  2),
    (2, '3-5 años',  3,  5),
    (3, '6-8 años',  6,  8),
    (4, '9-12 años', 9, 12),
    (5, '13+ años', 13, NULL);

INSERT INTO suppliers (id, name, country, contact, is_active) VALUES
    (1, 'JuguetesMax S.A.',  'México',   'Carlos Ruiz',  1),
    (2, 'ToyWorld Import',   'China',    'Ana Gómez',    1),
    (3, 'Didácticos Norte',  'México',   NULL,           1),
    (4, 'Plásticos del Sur', 'México',   'Luis Mora',    0),
    (5, 'EduToys Europa',    'España',   NULL,           1);

-- 35 productos con distribución desigual por categoría
INSERT INTO products (sku, name, category, price, stock, description, age_range_id, supplier_id) VALUES
    ('SKU-001', 'Sonajero Colorido',       'Bebés',       8.99,  45, 'Plástico BPA-free',          1, 1),
    ('SKU-002', 'Mordedor Silicona',       'Bebés',       6.50,  60, NULL,                         1, 1),
    ('SKU-003', 'Móvil Musical',           'Bebés',      24.99,  20, 'Melodías clásicas',          1, 1),
    ('SKU-004', 'Pelota Suave',            'Bebés',       5.99,  80, NULL,                         1, 2),
    ('SKU-005', 'Alfombra de Juego',       'Bebés',      39.99,  15, 'Impermeable, lavable',       1, 2),
    ('SKU-006', 'Bloques de Madera',       'Educativos', 19.99,  35, 'Set 20 piezas',              2, 3),
    ('SKU-007', 'Rompecabezas 24 pzs',    'Educativos', 12.99,  50, NULL,                         2, 3),
    ('SKU-008', 'Ábaco Infantil',          'Educativos', 14.99,  40, 'Madera natural',             2, 3),
    ('SKU-009', 'Letras Magnéticas',       'Educativos', 16.99,  30, NULL,                         3, 5),
    ('SKU-010', 'Microscopio Infantil',    'Educativos', 34.99,  18, '40x-100x aumento',           3, 5),
    ('SKU-011', 'Kit Ciencias',            'Educativos', 29.99,  22, '30 experimentos',            4, 5),
    ('SKU-012', 'Telescopio Junior',       'Educativos', 49.99,  10, NULL,                         4, 5),
    ('SKU-013', 'Auto Control Remoto',     'Vehículos',  45.99,  25, 'Alcance 30m',                3, 2),
    ('SKU-014', 'Tren Eléctrico',          'Vehículos',  89.99,  12, 'Vías incluidas',             3, 2),
    ('SKU-015', 'Moto a Batería',          'Vehículos', 149.99,   8, 'Hasta 5 km/h',               4, 2),
    ('SKU-016', 'Camión Volquete',         'Vehículos',  22.99,  40, NULL,                         2, 1),
    ('SKU-017', 'Helicóptero RC',          'Vehículos',  69.99,  15, 'Giroscopio integrado',       4, 2),
    ('SKU-018', 'Barco de Madera',         'Vehículos',  18.99,  28, NULL,                         2, 3),
    ('SKU-019', 'Muñeca Clásica',          'Muñecas',    15.99,  55, '3 cambios de ropa',          2, 4),
    ('SKU-020', 'Casa de Muñecas',         'Muñecas',    79.99,  10, '3 pisos, 6 habitaciones',    3, 4),
    ('SKU-021', 'Muñeca Articulada',       'Muñecas',    24.99,  35, NULL,                         3, 4),
    ('SKU-022', 'Set Accesorios Muñeca',   'Muñecas',     9.99,  70, NULL,                         2, 1),
    ('SKU-023', 'Muñeca Bebé',             'Muñecas',    19.99,  45, 'Llora y ríe',                1, 1),
    ('SKU-024', 'Espada Espuma',           'Acción',     11.99,  60, NULL,                         3, NULL),
    ('SKU-025', 'Figura Superhéroe',       'Acción',     14.99,  80, '15 puntos articulación',     3, NULL),
    ('SKU-026', 'Set Ninjas',              'Acción',     29.99,  30, '4 figuras incluidas',        4, 2),
    ('SKU-027', 'Pistola de Agua',         'Acción',      7.99,  90, NULL,                         3, 1),
    ('SKU-028', 'Escudo y Lanza',          'Acción',     18.99,  40, NULL,                         3, 1),
    ('SKU-029', 'Juego de Mesa Familia',   'Mesa',       34.99,  25, '2-6 jugadores',              4, 5),
    ('SKU-030', 'Ajedrez Infantil',        'Mesa',       22.99,  20, 'Piezas grandes',             4, 5),
    ('SKU-031', 'Dominó Madera',           'Mesa',       12.99,  35, NULL,                         3, 3),
    ('SKU-032', 'Cartas UNO',              'Mesa',        8.99,  65, NULL,                         3, 1),
    ('SKU-033', 'Parchís Gigante',         'Mesa',       19.99,  30, 'Tablero 60x60 cm',           4, 3),
    ('SKU-034', 'Pelota Fútbol',           'Deportes',   16.99,  50, 'Talla 3',                    3, 1),
    ('SKU-035', 'Bicicleta 16"',           'Deportes',  129.99,   8, 'Con ruedines',               3, 2);

-- Ventas distribuidas en varios meses
INSERT INTO sales (sale_date, quantity, unit_price, product_id) VALUES
    ('2024-01-05', 3,   8.99,  1),
    ('2024-01-10', 5,   6.50,  2),
    ('2024-01-15', 2,  24.99,  3),
    ('2024-01-20', 4,  19.99,  6),
    ('2024-02-03', 6,  12.99,  7),
    ('2024-02-08', 3,  45.99, 13),
    ('2024-02-14', 2,  89.99, 14),
    ('2024-02-20', 5,  15.99, 19),
    ('2024-03-01', 4,  14.99, 25),
    ('2024-03-10', 7,   7.99, 27),
    ('2024-03-15', 3,  34.99, 29),
    ('2024-03-22', 2,  22.99, 30),
    ('2024-04-05', 8,   8.99, 32),
    ('2024-04-12', 5,  16.99, 34),
    ('2024-04-18', 1, 129.99, 35);


-- ============================================
-- PARTE 3: REPORTES (SELECT)
-- ============================================

-- REPORTE 1: Totales globales del catálogo
SELECT
    COUNT(*)                      AS total_productos,
    ROUND(SUM(price), 2)          AS valor_catalogo,
    ROUND(AVG(price), 2)          AS precio_promedio,
    SUM(stock)                    AS unidades_en_stock,
    ROUND(SUM(price * stock), 2)  AS valor_inventario
FROM products
WHERE is_active = 1;


-- REPORTE 2: Totales por categoría (GROUP BY)
SELECT
    category                      AS categoria,
    COUNT(*)                      AS total_productos,
    ROUND(AVG(price), 2)          AS precio_promedio,
    SUM(stock)                    AS stock_total,
    ROUND(SUM(price * stock), 2)  AS valor_inventario
FROM products
WHERE is_active = 1
GROUP BY category
ORDER BY total_productos DESC;


-- REPORTE 3: Categorías con más de 4 productos (HAVING)
SELECT
    category    AS categoria,
    COUNT(*)    AS total_productos,
    SUM(stock)  AS unidades_disponibles
FROM products
GROUP BY category
HAVING COUNT(*) > 4
ORDER BY total_productos DESC;


-- REPORTE 4: Productos sin descripción y proveedores sin contacto (NULL + COALESCE)
SELECT
    p.sku,
    p.name                                          AS producto,
    COALESCE(p.description, 'Sin descripción')      AS descripcion,
    COALESCE(s.name, 'Sin proveedor asignado')      AS proveedor
FROM products p
LEFT JOIN suppliers s ON p.supplier_id = s.id
WHERE p.description IS NULL
ORDER BY p.category, p.name;


-- REPORTE 5: Productos de precio medio (BETWEEN) activos
SELECT
    sku,
    name,
    category,
    price,
    stock
FROM products
WHERE price BETWEEN 15.00 AND 50.00
  AND is_active = 1
ORDER BY price DESC
LIMIT 10;
