# Semana 06 — Funciones de Agregación

**Dominio:** Tienda de Juguetes | **Motor:** SQLite

---

## Qué se practica

`COUNT` · `SUM` · `AVG` · `MIN` · `MAX` · `GROUP BY` · `HAVING` · `ORDER BY`

---

## Esquema utilizado

```
age_ranges (id, name)
products   (id, name, category, price, stock, age_range_id → age_ranges)
```

**Datos:** 35 productos distribuidos en 7 categorías con distribución desigual para que `HAVING` filtre grupos reales.

---

## Reportes implementados

| # | Reporte | Cláusulas |
|---|---------|-----------|
| 1 | Totales globales del catálogo | `COUNT`, `SUM`, `AVG` |
| 2 | Precio mínimo y máximo | `MIN`, `MAX` |
| 3 | Subtotales por categoría | `GROUP BY`, `ORDER BY` |
| 4 | Categorías con más de 5 productos | `GROUP BY`, `HAVING` |

---

## Resultado esperado (Reporte 3)

| categoria | total_productos | precio_promedio | stock_total |
|-----------|----------------|-----------------|-------------|
| Acción | 5 | 16.77 | 300 |
| Educativos | 7 | 25.70 | 205 |
| Mesa | 5 | 19.99 | 175 |
| Muñecas | 5 | 29.19 | 215 |
| Bebés | 5 | 17.29 | 220 |
| Vehículos | 6 | 66.29 | 128 |
| Deportes | 2 | 73.49 | 58 |

---

## Cómo ejecutar

```bash
sqlite3 tienda.db < proyecto.sql
```
