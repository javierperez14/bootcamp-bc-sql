# Semana 12 — CTEs y CASE WHEN

**Dominio:** Tienda de Juguetes | **Motor:** SQLite

---

## Qué se practica

CTE simple con `WITH` · CTEs encadenados en cascada · `CASE WHEN` para clasificación · combinación de CTE + `CASE WHEN` en reportes analíticos

---

## Esquema utilizado

```
age_ranges ← products → suppliers
                ↑
             sales
```

---

## Consultas implementadas

| # | Consulta | Técnica | Qué responde |
|---|----------|---------|--------------|
| 1 | Productos clasificados por banda de precio con su actividad de ventas | CTE simple + `CASE WHEN` | Clasifica cada producto en Premium / Estándar / Económico |
| 2 | Categorías con ventas por encima del promedio | Dos CTEs encadenados | Detecta las categorías más activas filtrando sobre métricas agregadas |
| 3 | Conteo de productos por banda de precio dentro de cada categoría | CTE + `COUNT(CASE WHEN ...)` | Distribución de rangos de precio por categoría |

---

## Patrón CTE vs tabla derivada

```sql
-- Tabla derivada — menos legible
SELECT name, total
FROM (
    SELECT name, COUNT(*) AS total FROM products GROUP BY category
) AS resumen;

-- CTE equivalente — más claro
WITH resumen AS (
    SELECT category, COUNT(*) AS total
    FROM products
    GROUP BY category
)
SELECT category, total FROM resumen;
```

---

## CTEs encadenados

```sql
WITH primer_cte AS (
    SELECT ...        -- paso 1
),
segundo_cte AS (
    SELECT ...        -- paso 2, referencia primer_cte
    FROM primer_cte
)
SELECT ... FROM segundo_cte;
```

---

## Cómo ejecutar

```bash
sqlite3 tienda.db < proyecto.sql
```
