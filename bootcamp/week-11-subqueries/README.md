# Semana 11 — Subqueries

**Dominio:** Tienda de Juguetes | **Motor:** SQLite

---

## Qué se practica

Subquery escalar en `WHERE` · subquery escalar en `SELECT` · `NOT EXISTS` · tabla derivada en `FROM`

---

## Esquema utilizado

```
age_ranges ← products → suppliers
                ↑
             sales
```

**Dato clave:** 15 productos no tienen ninguna venta, lo que hace que `NOT EXISTS` devuelva resultados reales y no triviales.

---

## Consultas implementadas

| # | Consulta | Tipo de subquery | Qué responde |
|---|----------|-----------------|--------------|
| 1 | Productos más caros que el promedio de su categoría | Escalar correlacionada en `WHERE` | Detecta los productos premium dentro de cada categoría |
| 2 | Precio de cada producto vs. promedio global | Escalar en `SELECT` | Facilita comparación visual fila a fila |
| 3 | Productos que nunca se han vendido | `NOT EXISTS` correlacionado | Alternativa segura a `NOT IN` cuando puede haber NULLs |
| 4 | Categorías con ingresos por encima del promedio | Tabla derivada en `FROM` | Agrupa ventas por categoría y filtra sobre ese resultado |

---

## Patrón NOT EXISTS vs NOT IN

```sql
-- NOT EXISTS: seguro con NULLs, siempre preferible
WHERE NOT EXISTS (
    SELECT 1 FROM sales s WHERE s.product_id = p.id
)

-- NOT IN: peligroso si la subquery puede devolver NULL
WHERE p.id NOT IN (SELECT product_id FROM sales)  -- ⚠️ evitar
```

---

## Cómo ejecutar

```bash
sqlite3 tienda.db < proyecto.sql
```
