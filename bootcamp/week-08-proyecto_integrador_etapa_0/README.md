# Semana 08 — Proyecto Integrador Etapa 0

**Dominio:** Tienda de Juguetes | **Motor:** SQLite

---

## Qué se practica

Capstone de la Etapa 0: diseño completo de esquema relacional + datos + reportes analíticos aplicando todo lo visto en semanas 01–07.

`DDL completo` · `DML` · `COUNT / SUM / AVG` · `GROUP BY` · `HAVING` · `IS NULL` · `COALESCE` · `BETWEEN` · `LIKE` · `FK con ON DELETE`

---

## Esquema completo (4 tablas)

```
age_ranges (id, name, min_age, max_age)
           ↑
suppliers  (id, name UNIQUE, country DEFAULT 'México', contact?, is_active)
           ↑
products   (id, sku UNIQUE, name, category, price CHECK > 0,
            stock CHECK ≥ 0, description?, is_active DEFAULT 1,
            age_range_id NOT NULL → age_ranges ON DELETE RESTRICT,
            supplier_id  → suppliers ON DELETE SET NULL)
           ↑
sales      (id, sale_date DEFAULT now, quantity CHECK > 0,
            unit_price CHECK > 0,
            product_id NOT NULL → products ON DELETE RESTRICT)
```

---

## Datos de prueba

| Tabla | Filas |
|-------|-------|
| `age_ranges` | 5 |
| `suppliers` | 5 (1 inactivo, 2 sin contacto) |
| `products` | 35 (4 sin proveedor, varios sin descripción) |
| `sales` | 15 transacciones en 4 meses |

---

## Reportes implementados

| # | Reporte | Cláusulas |
|---|---------|-----------|
| 1 | Totales globales del catálogo activo | `COUNT`, `SUM`, `AVG` |
| 2 | Resumen por categoría | `GROUP BY`, `ORDER BY` |
| 3 | Categorías con más de 4 productos | `GROUP BY`, `HAVING` |
| 4 | Productos sin descripción con proveedor | `LEFT JOIN`, `IS NULL`, `COALESCE` |
| 5 | Productos de precio medio activos | `BETWEEN`, `LIMIT` |

---

## Cómo ejecutar

```bash
sqlite3 tienda.db < proyecto.sql
```
