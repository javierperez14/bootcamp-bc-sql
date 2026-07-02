-- ============================================
-- PROYECTO SEMANAL: JOINs aplicados al dominio
-- Semana 09 — INNER JOIN y LEFT JOIN
-- Dominio: Tienda de Juguetes
-- ============================================

PRAGMA foreign_keys = ON;

-- ============================================
-- ESQUEMA
-- ============================================

DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS age_ranges;

CREATE TABLE age_ranges (
    id      INTEGER PRIMARY KEY,
    name    TEXT    NOT NULL UNIQUE,
    min_age INTEGER NOT NULL CHECK (min_age >= 0)
);

CREATE TABLE suppliers (
    id        INTEGER PRIMARY KEY,
    name      TEXT    NOT NULL UNIQUE,
    country   TEXT    NOT NULL DEFAULT 'México',
    is_active INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE products (
    id           INTEGER PRIMARY KEY,
    sku          TEXT    NOT NULL UNIQUE,
    name         TEXT    NOT NULL,
    category     TEXT    NOT NULL,
    price        REAL    NOT NULL CHECK (price > 0),
    stock        INTEGER NOT NULL DEFAULT 0,
    age_range_id INTEGER NOT NULL REFERENCES age_ranges(id),
    supplier_id  INTEGER REFERENCES suppliers(id)   -- puede ser NULL (huérfano)
);

CREATE TABLE sales (
    id         INTEGER PRIMARY KEY,
    sale_date  TEXT    NOT NULL DEFAULT (DATE('now')),
    quantity   INTEGER NOT NULL CHECK (quantity > 0),
    unit_price REAL    NOT NULL CHECK (unit_price > 0),
    product_id INTEGER NOT NULL REFERENCES products(id)
);

-- ============================================
-- DATOS
-- ============================================

INSERT INTO age_ranges (id, name, min_age) VALUES
    (1, '0-2 años',  0),
    (2, '3-5 años',  3),
    (3, '6-8 años',  6),
    (4, '9-12 años', 9),
    (5, '13+ años', 13);

INSERT INTO suppliers (id, name, country, is_active) VALUES
    (1, 'JuguetesMax S.A.',  'México', 1),
    (2, 'ToyWorld Import',   'China',  1),
    (3, 'Didácticos Norte',  'México', 1),
    (4, 'Plásticos del Sur', 'México', 0),
    (5, 'EduToys Europa',    'España', 1);

-- 35 productos; algunos sin supplier_id (huérfanos para LEFT JOIN)
INSERT INTO products (sku, name, category, price, stock, age_range_id, supplier_id) VALUES
    ('SKU-001', 'Sonajero Colorido',      'Bebés',       8.99,  45, 1, 1),
    ('SKU-002', 'Mordedor Silicona',      'Bebés',       6.50,  60, 1, 1),
    ('SKU-003', 'Móvil Musical',          'Bebés',      24.99,  20, 1, 1),
    ('SKU-004', 'Pelota Suave',           'Bebés',       5.99,  80, 1, 2),
    ('SKU-005', 'Alfombra de Juego',      'Bebés',      39.99,  15, 1, 2),
    ('SKU-006', 'Bloques de Madera',      'Educativos', 19.99,  35, 2, 3),
    ('SKU-007', 'Rompecabezas 24 pzs',   'Educativos', 12.99,  50, 2, 3),
    ('SKU-008', 'Ábaco Infantil',         'Educativos', 14.99,  40, 2, 3),
    ('SKU-009', 'Letras Magnéticas',      'Educativos', 16.99,  30, 3, 5),
    ('SKU-010', 'Microscopio Infantil',   'Educativos', 34.99,  18, 3, 5),
    ('SKU-011', 'Kit Ciencias',           'Educativos', 29.99,  22, 4, 5),
    ('SKU-012', 'Telescopio Junior',      'Educativos', 49.99,  10, 4, 5),
    ('SKU-013', 'Auto Control Remoto',    'Vehículos',  45.99,  25, 3, 2),
    ('SKU-014', 'Tren Eléctrico',         'Vehículos',  89.99,  12, 3, 2),
    ('SKU-015', 'Moto a Batería',         'Vehículos', 149.99,   8, 4, 2),
    ('SKU-016', 'Camión Volquete',        'Vehículos',  22.99,  40, 2, 1),
    ('SKU-017', 'Helicóptero RC',         'Vehículos',  69.99,  15, 4, 2),
    ('SKU-018', 'Barco de Madera',        'Vehículos',  18.99,  28, 2, 3),
    ('SKU-019', 'Muñeca Clásica',         'Muñecas',    15.99,  55, 2, 4),
    ('SKU-020', 'Casa de Muñecas',        'Muñecas',    79.99,  10, 3, 4),
    ('SKU-021', 'Muñeca Articulada',      'Muñecas',    24.99,  35, 3, 4),
    ('SKU-022', 'Set Accesorios Muñeca',  'Muñecas',     9.99,  70, 2, 1),
    ('SKU-023', 'Muñeca Bebé',            'Muñecas',    19.99,  45, 1, 1),
    ('SKU-024', 'Espada Espuma',          'Acción',     11.99,  60, 3, NULL),  -- sin proveedor
    ('SKU-025', 'Figura Superhéroe',      'Acción',     14.99,  80, 3, NULL),  -- sin proveedor
    ('SKU-026', 'Set Ninjas',             'Acción',     29.99,  30, 4, 2),
    ('SKU-027', 'Pistola de Agua',        'Acción',      7.99,  90, 3, 1),
    ('SKU-028', 'Escudo y Lanza',         'Acción',     18.99,  40, 3, 1),
    ('SKU-029', 'Juego de Mesa Familia',  'Mesa',       34.99,  25, 4, 5),
    ('SKU-030', 'Ajedrez Infantil',       'Mesa',       22.99,  20, 4, 5),
    ('SKU-031', 'Dominó Madera',          'Mesa',       12.99,  35, 3, 3),
    ('SKU-032', 'Cartas UNO',             'Mesa',        8.99,  65, 3, 1),
    ('SKU-033', 'Parchís Gigante',        'Mesa',       19.99,  30, 4, 3),
    ('SKU-034', 'Pelota Fútbol',          'Deportes',   16.99,  50, 3, 1),
    ('SKU-035', 'Bicicleta 16"',          'Deportes',  129.99,   8, 3, 2);

-- Ventas: no todos los productos tienen ventas (para LEFT JOIN)
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
    ('2024-04-18', 1, 129.99, 35),
    ('2024-04-20', 2,  45.99, 13),
    ('2024-04-25', 3,  14.99, 25),
    ('2024-05-01', 4,   8.99,  1),
    ('2024-05-05', 2,  19.99,  6),
    ('2024-05-10', 6,  12.99,  7);


-- ============================================
-- CONSULTA 1: INNER JOIN principal
-- Une products con sales — solo productos que tienen ventas
-- ============================================
SELECT
    p.sku                                   AS codigo,
    p.name                                  AS producto,
    p.category                              AS categoria,
    s.sale_date                             AS fecha_venta,
    s.quantity                              AS cantidad,
    ROUND(s.quantity * s.unit_price, 2)     AS total_venta
FROM products p
INNER JOIN sales s ON s.product_id = p.id
ORDER BY s.sale_date DESC;


-- ============================================
-- CONSULTA 2: JOIN con tres tablas
-- products + sales + suppliers — enriquece el reporte con proveedor
-- ============================================
SELECT
    p.sku                               AS codigo,
    p.name                              AS producto,
    sup.name                            AS proveedor,
    s.sale_date                         AS fecha_venta,
    s.quantity                          AS cantidad,
    ROUND(s.quantity * s.unit_price, 2) AS total_venta
FROM products p
INNER JOIN sales     s   ON s.product_id   = p.id
INNER JOIN suppliers sup ON p.supplier_id  = sup.id
ORDER BY sup.name, s.sale_date;


-- ============================================
-- CONSULTA 3: LEFT JOIN — todos los productos aunque no tengan ventas
-- ============================================
SELECT
    p.sku                               AS codigo,
    p.name                              AS producto,
    p.category                          AS categoria,
    s.sale_date                         AS fecha_venta,
    s.quantity                          AS cantidad_vendida
FROM products p
LEFT JOIN sales s ON s.product_id = p.id
ORDER BY p.category, p.name;


-- ============================================
-- CONSULTA 4: Detectar productos sin ninguna venta (huérfanos)
-- ============================================
SELECT
    p.sku       AS codigo,
    p.name      AS producto_sin_ventas,
    p.category  AS categoria,
    p.stock     AS stock_actual
FROM products p
LEFT JOIN sales s ON s.product_id = p.id
WHERE s.id IS NULL
ORDER BY p.category, p.name;


-- ============================================
-- CONSULTA 5: Reporte agregado — ventas totales por producto
-- Incluye productos con 0 ventas gracias al LEFT JOIN
-- ============================================
SELECT
    p.sku                                       AS codigo,
    p.name                                      AS producto,
    p.category                                  AS categoria,
    COUNT(s.id)                                 AS num_transacciones,
    COALESCE(SUM(s.quantity), 0)                AS unidades_vendidas,
    ROUND(COALESCE(SUM(s.quantity * s.unit_price), 0), 2) AS ingresos_totales
FROM products p
LEFT JOIN sales s ON s.product_id = p.id
GROUP BY p.id, p.sku, p.name, p.category
ORDER BY ingresos_totales DESC;
