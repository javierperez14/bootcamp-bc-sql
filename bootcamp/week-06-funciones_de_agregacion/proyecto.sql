-- ============================================
-- PROYECTO SEMANAL: Funciones de Agregación
-- Semana 06 — COUNT, SUM, AVG, GROUP BY, HAVING
-- Dominio: Tienda de Juguetes
-- ============================================

-- Esquema base
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS age_ranges;

CREATE TABLE age_ranges (
    id   INTEGER PRIMARY KEY,
    name TEXT    NOT NULL UNIQUE
);

CREATE TABLE products (
    id           INTEGER PRIMARY KEY,
    name         TEXT    NOT NULL,
    category     TEXT    NOT NULL,
    price        REAL    NOT NULL CHECK (price > 0),
    stock        INTEGER NOT NULL DEFAULT 0,
    age_range_id INTEGER REFERENCES age_ranges(id)
);

-- Datos de referencia
INSERT INTO age_ranges (id, name) VALUES
    (1, '0-2 años'),
    (2, '3-5 años'),
    (3, '6-8 años'),
    (4, '9-12 años'),
    (5, '13+ años');

-- 35 productos con distribución desigual por categoría
INSERT INTO products (name, category, price, stock, age_range_id) VALUES
    ('Sonajero Colorido',        'Bebés',        8.99,  45, 1),
    ('Mordedor Silicona',        'Bebés',        6.50,  60, 1),
    ('Móvil Musical',            'Bebés',       24.99,  20, 1),
    ('Pelota Suave',             'Bebés',        5.99,  80, 1),
    ('Alfombra de Juego',        'Bebés',       39.99,  15, 1),
    ('Bloques de Madera',        'Educativos',  19.99,  35, 2),
    ('Rompecabezas 24 piezas',   'Educativos',  12.99,  50, 2),
    ('Abaco Infantil',           'Educativos',  14.99,  40, 2),
    ('Letras Magnéticas',        'Educativos',  16.99,  30, 3),
    ('Microscopio Infantil',     'Educativos',  34.99,  18, 3),
    ('Kit Ciencias',             'Educativos',  29.99,  22, 4),
    ('Telescopio Junior',        'Educativos',  49.99,  10, 4),
    ('Auto Control Remoto',      'Vehículos',   45.99,  25, 3),
    ('Tren Eléctrico',           'Vehículos',   89.99,  12, 3),
    ('Moto a Batería',           'Vehículos',  149.99,   8, 4),
    ('Camión Volquete',          'Vehículos',   22.99,  40, 2),
    ('Helicóptero RC',           'Vehículos',   69.99,  15, 4),
    ('Barco de Madera',          'Vehículos',   18.99,  28, 2),
    ('Muñeca Clásica',           'Muñecas',     15.99,  55, 2),
    ('Casa de Muñecas',          'Muñecas',     79.99,  10, 3),
    ('Muñeca Articulada',        'Muñecas',     24.99,  35, 3),
    ('Set Accesorios Muñeca',    'Muñecas',      9.99,  70, 2),
    ('Muñeca Bebé',              'Muñecas',     19.99,  45, 1),
    ('Espada Espuma',            'Acción',      11.99,  60, 3),
    ('Figura Superhéroe',        'Acción',      14.99,  80, 3),
    ('Set Ninjas',               'Acción',      29.99,  30, 4),
    ('Pistola Agua',             'Acción',       7.99,  90, 3),
    ('Escudo y Lanza',           'Acción',      18.99,  40, 3),
    ('Juego de Mesa Familia',    'Mesa',        34.99,  25, 4),
    ('Ajedrez Infantil',         'Mesa',        22.99,  20, 4),
    ('Dominó Madera',            'Mesa',        12.99,  35, 3),
    ('Cartas UNO',               'Mesa',         8.99,  65, 3),
    ('Parchís Gigante',          'Mesa',        19.99,  30, 4),
    ('Pelota Fútbol',            'Deportes',    16.99,  50, 3),
    ('Bicicleta 16"',            'Deportes',   129.99,   8, 3);


-- ============================================
-- REPORTE 1: Totales globales
-- ============================================
-- Cuenta todos los productos y calcula suma/promedio de precio y stock
SELECT
    COUNT(*)            AS total_productos,
    ROUND(SUM(price), 2)  AS valor_total_inventario,
    ROUND(AVG(price), 2)  AS precio_promedio,
    SUM(stock)          AS unidades_totales,
    ROUND(AVG(stock), 1)  AS stock_promedio
FROM products;


-- ============================================
-- REPORTE 2: Extremos de precio
-- ============================================
-- Producto más barato y más caro del catálogo
SELECT
    MIN(price) AS precio_minimo,
    MAX(price) AS precio_maximo
FROM products;


-- ============================================
-- REPORTE 3: Subtotales por categoría (GROUP BY)
-- ============================================
-- Cantidad de productos, precio promedio y stock total por categoría
SELECT
    category                    AS categoria,
    COUNT(*)                    AS total_productos,
    ROUND(AVG(price), 2)          AS precio_promedio,
    SUM(stock)                  AS stock_total,
    ROUND(SUM(price * stock), 2)  AS valor_inventario
FROM products
GROUP BY category
ORDER BY total_productos DESC;


-- ============================================
-- REPORTE 4: Filtro de grupos (HAVING)
-- ============================================
-- Solo categorías con más de 5 productos en catálogo
SELECT
    category    AS categoria,
    COUNT(*)    AS total_productos,
    SUM(stock)  AS unidades_disponibles
FROM products
GROUP BY category
HAVING COUNT(*) > 5
ORDER BY total_productos DESC;
