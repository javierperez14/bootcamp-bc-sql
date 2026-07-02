# Semana 09 — INNER JOIN y LEFT JOIN

**Dominio:** Tienda de Juguetes | **Motor:** SQLite

---

## Qué se practica

`INNER JOIN` · `LEFT JOIN` · `JOIN con 3 tablas` · detección de huérfanos · `COUNT` con `LEFT JOIN` · aliases de tabla

---

## Esquema utilizado

```
age_ranges ← products → suppliers
                ↑
             sales
```

**Dato clave para LEFT JOIN:** 15 productos no tienen ninguna venta registrada (huérfanos). 2 productos no tienen proveedor asignado.

---

## Consultas implementadas

| # | Consulta | Técnica | Qué responde |
|---|----------|---------|--------------|
| 1 | Ventas con detalle de producto | `INNER JOIN` products ↔ sales | Solo productos que se han vendido |
| 2 | Ventas con producto y proveedor | `INNER JOIN` × 3 tablas | Enriquece el reporte con el proveedor |
| 3 | Todos los productos con sus ventas | `LEFT JOIN` | Incluye productos sin ventas (NULL) |
| 4 | Productos que nunca se han vendido | `LEFT JOIN` + `WHERE s.id IS NULL` | Detecta huérfanos del catálogo |
| 5 | Unidades vendidas e ingresos por producto | `LEFT JOIN` + `GROUP BY` + `COUNT` | Ranking de ventas incluyendo ceros |

---

## Patrón de detección de huérfanos

```sql
SELECT p.name
FROM products p
LEFT JOIN sales s ON s.product_id = p.id
WHERE s.id IS NULL;   -- NULL = no existe ninguna venta para este producto
```

---

## Cómo ejecutar

```bash
sqlite3 tienda.db < proyecto.sql
```
