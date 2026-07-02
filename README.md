# 🧸 Bootcamp SQL — Dominio: Tienda de Juguetes

**Semanas 06 a 12 | SQLite**

---

## Descripción del dominio

Proyectos semanales del bootcamp de SQL resueltos para el dominio **Tienda de Juguetes**.
Cada semana aplica los conceptos teóricos sobre un esquema de base de datos que evoluciona progresivamente.

### Entidades principales

| Entidad | Descripción |
|---------|-------------|
| `products` | Catálogo de juguetes con SKU, categoría, precio y stock |
| `age_ranges` | Rangos de edad recomendados (0-2, 3-5, 6-8, 9-12, 13+) |
| `sales` | Registro de ventas con fecha, cantidad y precio unitario |
| `suppliers` | Proveedores con país, contacto y estado activo/inactivo |

### Categorías de productos

`Bebés` · `Educativos` · `Vehículos` · `Muñecas` · `Acción` · `Mesa` · `Deportes`

---

## Estructura del proyecto

```
bootcamp/
├── README.md                                  ← este archivo
├── week-06-funciones_de_agregacion/
│   ├── README.md
│   └── proyecto.sql
├── week-07-null_y_constraints/
│   ├── README.md
│   └── proyecto.sql
├── week-08-proyecto_integrador_etapa_0/
│   ├── README.md
│   └── proyecto.sql
├── week-09-joins_inner_join_y_left_join/
│   ├── README.md
│   └── proyecto.sql
├── week-10-cross_join_y_self_join/
│   ├── README.md
│   └── proyecto.sql
├── week-11-subqueries/
│   ├── README.md
│   └── proyecto.sql
└── week-12-ctes_y_case_when/
    ├── README.md
    └── proyecto.sql
```

---

## Resumen por semana

### Semana 06 — Funciones de Agregación
**Motor:** SQLite | **Tablas:** `products`, `age_ranges`

Se construye el esquema base con 35 productos distribuidos en 7 categorías y se generan 4 reportes:
- Totales globales del catálogo (`COUNT`, `SUM`, `AVG`)
- Precio mínimo y máximo (`MIN`, `MAX`)
- Subtotales por categoría (`GROUP BY`, `ORDER BY`)
- Categorías con más de 5 productos (`GROUP BY`, `HAVING`)

---

### Semana 07 — NULL y Constraints
**Motor:** SQLite | **Tablas:** `products`, `age_ranges`, `suppliers`

Se amplía el esquema incorporando constraints de integridad y manejo seguro de valores NULL:
- `NOT NULL` en columnas obligatorias (nombre, precio, stock)
- `UNIQUE` en `sku` — código irrepetible por producto
- `CHECK` en `price > 0`, `stock >= 0`, `is_active IN (0,1)`
- `FOREIGN KEY` con `ON DELETE RESTRICT` y `ON DELETE SET NULL`
- Consultas con `IS NULL` para detectar productos sin descripción o sin proveedor
- `COALESCE` para mostrar valores legibles en lugar de NULL

---

### Semana 08 — Proyecto Integrador Etapa 0
**Motor:** SQLite | **Tablas:** `products`, `age_ranges`, `suppliers`, `sales`

Capstone de la Etapa 0: esquema completo de 4 tablas relacionadas con 35 productos y 15 ventas distribuidas en 4 meses. Se implementan 5 reportes que combinan todo lo aprendido en semanas 01–07:
1. Totales globales del catálogo activo
2. Resumen de productos y valor de inventario por categoría
3. Categorías con más de 4 productos (`HAVING`)
4. Productos sin descripción con su proveedor (`LEFT JOIN` + `COALESCE`)
5. Productos de precio medio activos (`BETWEEN`, `LIMIT`)

---

### Semana 09 — INNER JOIN y LEFT JOIN
**Motor:** SQLite | **Tablas:** `products`, `age_ranges`, `suppliers`, `sales`

Se practican los JOINs más usados con 5 consultas relacionales sobre el esquema completo. 15 productos no tienen ventas (huérfanos) para que el LEFT JOIN devuelva resultados reales:
1. Ventas con detalle de producto (`INNER JOIN`)
2. Ventas enriquecidas con proveedor (`INNER JOIN` × 3 tablas)
3. Todos los productos aunque no tengan ventas (`LEFT JOIN`)
4. Productos que nunca se han vendido (`LEFT JOIN` + `WHERE s.id IS NULL`)
5. Ranking de ingresos por producto incluyendo ceros (`LEFT JOIN` + `GROUP BY` + `COUNT`)

---

### Semana 10 — SELF JOIN
**Motor:** SQLite | **Tabla:** `categories` (auto-referencial)

Se modela la jerarquía de categorías de la tienda con una columna `parent_id` que apunta a la misma tabla. 23 nodos en 3 niveles: Departamento → Categoría → Subcategoría.
1. Subcategoría junto a su categoría padre (`INNER JOIN` con aliases `child`/`parent`)
2. Todos los nodos etiquetando los departamentos raíz (`LEFT JOIN` + `COALESCE`)
3. Cuántas subcategorías tiene cada categoría (`GROUP BY` + `HAVING`)
4. Árbol de dos niveles: subcategoría → categoría → departamento (3 aliases)

---

### Semana 11 — Subqueries
**Motor:** SQLite | **Tablas:** `products`, `age_ranges`, `suppliers`, `sales`

Se aplican los 4 tipos principales de subqueries sobre el esquema completo. 15 productos sin ventas garantizan que `NOT EXISTS` filtre resultados reales:
1. Productos más caros que el promedio de su propia categoría (subquery escalar correlacionada en `WHERE`)
2. Precio de cada producto vs. promedio global (subquery escalar en `SELECT`)
3. Productos que nunca se han vendido (`NOT EXISTS` — alternativa segura a `NOT IN`)
4. Categorías con ingresos por encima del promedio (tabla derivada en `FROM`)

---

### Semana 12 — CTEs y CASE WHEN
**Motor:** SQLite | **Tablas:** `products`, `age_ranges`, `suppliers`, `sales`

Se introducen las Common Table Expressions con `WITH` y las expresiones condicionales con `CASE WHEN`. Los CTEs reemplazan subqueries en `FROM` con código más legible; `CASE WHEN` permite clasificar filas y hacer agregaciones condicionales:
1. Productos clasificados por banda de precio con su actividad de ventas (CTE simple + `CASE WHEN`)
2. Categorías con ventas por encima del promedio (dos CTEs encadenados en cascada)
3. Conteo de productos Premium / Estándar / Económico por categoría (CTE + `COUNT(CASE WHEN ...)`)

---

## Progresión del esquema

```
Semana 06 → products + age_ranges (esquema mínimo, 35 productos)
Semana 07 → + suppliers + constraints completos (NOT NULL, UNIQUE, CHECK, FK)
Semana 08 → + sales (esquema completo de 4 tablas, 15 ventas)
Semana 09 → mismo esquema, consultas relacionales con JOIN
Semana 10 → categories con auto-referencia parent_id (jerarquía 3 niveles)
Semana 11 → mismo esquema semana 08, consultas con subqueries
Semana 12 → mismo esquema semana 08, CTEs simples/encadenados + CASE WHEN
```

---

## Cómo ejecutar

```bash
sqlite3 tienda.db < proyecto.sql
```

---

## Convenciones de código

- Keywords SQL en **MAYÚSCULAS** (`SELECT`, `FROM`, `WHERE`, `GROUP BY`...)
- Nombres de tablas y columnas en **snake_case** en español
- Comentarios en **español** explicando cada sección
- Sin `SELECT *` — siempre columnas explícitas
- Aliases descriptivos en JOINs (`p` para `products`, `s` para `sales`, etc.)
