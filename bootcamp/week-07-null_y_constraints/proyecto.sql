-- ============================================
-- PROYECTO SEMANAL: NULL y Constraints
-- Semana 07 — NOT NULL, UNIQUE, CHECK, FK, COALESCE
-- Dominio: Tienda de Juguetes
-- ============================================

-- Activar claves foráneas (obligatorio)
PRAGMA foreign_keys = ON;

-- ============================================
-- PARTE 1: ESQUEMA CON CONSTRAINTS
-- ============================================

DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS age_ranges;

-- Tabla de rangos de edad (referencia)
CREATE TABLE age_ranges (
    id          INTEGER PRIMARY KEY,
    name        TEXT    NOT NULL UNIQUE,
    min_age     INTEGER NOT NULL CHECK (min_age >= 0),
    max_age     INTEGER CHECK (max_age IS NULL OR max_age > min_age)
);

-- Tabla de proveedores
CREATE TABLE suppliers (
    id          INTEGER PRIMARY KEY,
    name        TEXT    NOT NULL UNIQUE,
    contact     TEXT,                          -- puede ser NULL (dato opcional)
    phone       TEXT,                          -- puede ser NULL
    is_active   INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1))
);

-- Tabla principal de productos con todos los constraints
CREATE TABLE products (
    id           INTEGER PRIMARY KEY,
    sku          TEXT    NOT NULL UNIQUE,       -- código único de producto
    name         TEXT    NOT NULL,
    category     TEXT    NOT NULL,
    price        REAL    NOT NULL CHECK (price > 0),
    stock        INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    description  TEXT,                         -- puede ser NULL
    age_range_id INTEGER NOT NULL
        REFERENCES age_ranges(id) ON DELETE RESTRICT,
    supplier_id  INTEGER
        REFERENCES suppliers(id) ON DELETE SET NULL  -- proveedor opcional
);


-- ============================================
-- PARTE 2: DATOS DE PRUEBA
-- ============================================

INSERT INTO age_ranges (id, name, min_age, max_age) VALUES
    (1, '0-2 años',  0,  2),
    (2, '3-5 años',  3,  5),
    (3, '6-8 años',  6,  8),
    (4, '9-12 años', 9, 12),
    (5, '13+ años', 13, NULL);

INSERT INTO suppliers (id, name, contact, phone, is_active) VALUES
    (1, 'JuguetesMax S.A.',   'Carlos Ruiz',    '555-1001', 1),
    (2, 'ToyWorld Import',    'Ana Gómez',       '555-1002', 1),
    (3, 'Didácticos Norte',   NULL,              NULL,       1),  -- sin contacto
    (4, 'Plásticos del Sur',  'Luis Mora',       '555-1004', 0),  -- inactivo
    (5, 'EduToys Europa',     NULL,              '555-1005', 1);  -- sin contacto

-- 10 productos: algunos con description NULL, algunos sin supplier
INSERT INTO products (sku, name, category, price, stock, description, age_range_id, supplier_id) VALUES
    ('SKU-001', 'Sonajero Colorido',      'Bebés',       8.99,  45, 'Sonajero de plástico BPA-free',  1, 1),
    ('SKU-002', 'Mordedor Silicona',      'Bebés',       6.50,  60, NULL,                             1, 1),
    ('SKU-003', 'Bloques de Madera',      'Educativos', 19.99,  35, 'Set de 20 bloques de colores',   2, 3),
    ('SKU-004', 'Rompecabezas 24 pzs',   'Educativos', 12.99,  50, NULL,                             2, 3),
    ('SKU-005', 'Auto Control Remoto',   'Vehículos',  45.99,  25, 'Alcance 30 metros, batería 2h',  3, 2),
    ('SKU-006', 'Tren Eléctrico',        'Vehículos',  89.99,  12, NULL,                             3, 2),
    ('SKU-007', 'Muñeca Clásica',        'Muñecas',    15.99,  55, 'Incluye 3 cambios de ropa',      2, 4),
    ('SKU-008', 'Figura Superhéroe',     'Acción',     14.99,  80, NULL,                             3, NULL),  -- sin proveedor
    ('SKU-009', 'Juego de Mesa Familia', 'Mesa',       34.99,  25, 'Para 2-6 jugadores',             4, 5),
    ('SKU-010', 'Microscopio Infantil',  'Educativos', 34.99,  18, NULL,                             3, NULL);  -- sin proveedor


-- ============================================
-- PARTE 3: CONSULTAS CON NULL
-- ============================================

-- Consulta 1: Productos sin descripción (description IS NULL)
SELECT
    sku,
    name,
    category
FROM products
WHERE description IS NULL
ORDER BY category, name;


-- Consulta 2: Todos los productos usando COALESCE para reemplazar NULL
SELECT
    sku,
    name,
    COALESCE(description, 'Sin descripción disponible') AS descripcion,
    price
FROM products
ORDER BY name;


-- Consulta 3: Proveedores sin contacto asignado
SELECT
    id,
    name,
    COALESCE(contact, 'Sin contacto') AS contacto,
    COALESCE(phone,   'Sin teléfono') AS telefono
FROM suppliers
ORDER BY name;


-- Consulta 4: Productos sin proveedor asignado
SELECT
    p.sku,
    p.name,
    p.category
FROM products p
WHERE p.supplier_id IS NULL
ORDER BY p.name;
