-- ============================================
-- PROYECTO SEMANAL: SELF JOIN en el dominio
-- Semana 10 — CROSS JOIN y SELF JOIN
-- Dominio: Tienda de Juguetes
-- Jerarquía: categorías de productos (padre → subcategoría → producto)
-- ============================================

PRAGMA foreign_keys = ON;

-- ============================================
-- ESQUEMA
-- La tabla categories modela la jerarquía de categorías
-- de la tienda: Departamento → Categoría → Subcategoría
-- ============================================

DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
    id          INTEGER PRIMARY KEY,
    name        TEXT    NOT NULL UNIQUE,
    description TEXT,
    parent_id   INTEGER REFERENCES categories(id)  -- auto-referencial
);

-- ============================================
-- DATOS: 3 niveles jerárquicos
-- Nivel 1 (raíz): Departamentos (parent_id = NULL)
-- Nivel 2: Categorías principales
-- Nivel 3: Subcategorías específicas
-- ============================================

INSERT INTO categories (id, name, description, parent_id) VALUES
    -- Nivel 1: Departamentos (raíz)
    (1,  'Juguetes Primera Infancia', 'Para bebés y niños pequeños',    NULL),
    (2,  'Juguetes Educativos',       'Estimulación cognitiva',         NULL),
    (3,  'Juguetes de Acción',        'Movimiento y aventura',          NULL),
    (4,  'Juegos de Mesa',            'Estrategia y familia',           NULL),

    -- Nivel 2: Categorías (hijos de nivel 1)
    (5,  'Bebés 0-2',                 'Sonajeros, mordedores, móviles', 1),
    (6,  'Preescolar 3-5',            'Bloques, puzzles básicos',       1),
    (7,  'Ciencias y Experimentos',   'Microscopios, kits',             2),
    (8,  'Construcción',              'Bloques, LEGO, magnéticos',      2),
    (9,  'Vehículos RC',              'Autos, drones, barcos',          3),
    (10, 'Figuras y Muñecos',         'Superhéroes, ninjas, muñecas',   3),
    (11, 'Juegos Clásicos',           'Ajedrez, dominó, parchís',       4),
    (12, 'Juegos de Cartas',          'UNO, memory, naipes',            4),

    -- Nivel 3: Subcategorías (hijos de nivel 2)
    (13, 'Sonajeros',                 'Sonajeros de plástico y tela',   5),
    (14, 'Mordedores',                'Mordedores de silicona',         5),
    (15, 'Móviles de Cuna',           'Móviles musicales y de luz',     5),
    (16, 'Puzzles Madera',            'Puzzles de madera 3-5 años',     6),
    (17, 'Bloques Apilables',         'Bloques de colores y formas',    6),
    (18, 'Microscopios',              'Microscopios infantiles',        7),
    (19, 'Telescopios',               'Telescopios junior',             7),
    (20, 'Autos RC',                  'Autos de control remoto',        9),
    (21, 'Drones',                    'Drones para niños',              9),
    (22, 'Superhéroes',               'Figuras de superhéroes',        10),
    (23, 'Muñecas',                   'Muñecas clásicas y articuladas',10);


-- ============================================
-- CONSULTA 1: SELF JOIN básico (INNER JOIN)
-- Muestra cada subcategoría junto a su categoría padre
-- Excluye los nodos raíz (sin padre)
-- ============================================
SELECT
    child.name   AS subcategoria,
    parent.name  AS categoria_padre
FROM categories child
INNER JOIN categories parent ON child.parent_id = parent.id
ORDER BY parent.name, child.name;


-- ============================================
-- CONSULTA 2: Incluir la raíz con LEFT JOIN + COALESCE
-- Todos los nodos, etiquetando los departamentos raíz
-- ============================================
SELECT
    child.id                                    AS id,
    child.name                                  AS categoria,
    COALESCE(parent.name, '[ Departamento Raíz ]') AS categoria_padre,
    child.description                           AS descripcion
FROM categories child
LEFT JOIN categories parent ON child.parent_id = parent.id
ORDER BY COALESCE(parent.name, child.name), child.name;


-- ============================================
-- CONSULTA 3: Contar subcategorías por categoría padre
-- Solo categorías que tienen al menos una subcategoría
-- ============================================
SELECT
    parent.name         AS categoria_padre,
    COUNT(child.id)     AS total_subcategorias
FROM categories parent
LEFT JOIN categories child ON child.parent_id = parent.id
GROUP BY parent.id, parent.name
HAVING COUNT(child.id) > 0
ORDER BY total_subcategorias DESC;


-- ============================================
-- CONSULTA 4: Dos niveles jerárquicos
-- Subcategoría → Categoría → Departamento
-- ============================================
SELECT
    child.name                                      AS subcategoria,
    parent.name                                     AS categoria,
    COALESCE(grandparent.name, '[ Raíz ]')          AS departamento
FROM categories child
LEFT JOIN categories parent      ON child.parent_id  = parent.id
LEFT JOIN categories grandparent ON parent.parent_id = grandparent.id
ORDER BY departamento, categoria, subcategoria;
