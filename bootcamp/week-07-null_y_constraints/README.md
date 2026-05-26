# Semana 07 — NULL y Constraints

**Dominio:** Tienda de Juguetes | **Motor:** SQLite

---

## Qué se practica

`NOT NULL` · `UNIQUE` · `CHECK` · `DEFAULT` · `FOREIGN KEY` · `IS NULL` · `COALESCE` · `ON DELETE RESTRICT / SET NULL`

---

## Esquema utilizado

```
age_ranges (id, name, min_age CHECK ≥ 0, max_age CHECK > min_age o NULL)
suppliers  (id, name UNIQUE, contact?, phone?, is_active DEFAULT 1 CHECK IN (0,1))
products   (id, sku UNIQUE, name, category, price CHECK > 0,
            stock DEFAULT 0 CHECK ≥ 0, description?,
            age_range_id NOT NULL → age_ranges,
            supplier_id  → suppliers ON DELETE SET NULL)
```

Las columnas marcadas con `?` son opcionales y pueden contener `NULL`.

---

## Constraints destacados

| Tabla | Columna | Constraint | Motivo de negocio |
|-------|---------|------------|-------------------|
| `products` | `sku` | `UNIQUE` | Código de producto irrepetible |
| `products` | `price` | `CHECK (price > 0)` | No se admiten precios negativos |
| `products` | `stock` | `CHECK (stock >= 0)` | Stock no puede ser negativo |
| `suppliers` | `is_active` | `CHECK IN (0,1)` | Solo activo o inactivo |
| `age_ranges` | `max_age` | `CHECK > min_age OR NULL` | Rango coherente; `13+` no tiene máximo |

---

## Consultas implementadas

| # | Consulta | Técnica |
|---|----------|---------|
| 1 | Productos sin descripción | `WHERE description IS NULL` |
| 2 | Todos los productos con descripción legible | `COALESCE(description, 'Sin descripción')` |
| 3 | Proveedores sin contacto ni teléfono | `COALESCE` en dos columnas |
| 4 | Productos sin proveedor asignado | `WHERE supplier_id IS NULL` |

---

## Cómo ejecutar

```bash
sqlite3 tienda.db < proyecto.sql
```
