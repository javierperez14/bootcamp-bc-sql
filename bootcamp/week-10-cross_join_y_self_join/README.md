# Semana 10 — SELF JOIN

**Dominio:** Tienda de Juguetes | **Motor:** SQLite

---

## Qué se practica

`SELF JOIN` con `INNER JOIN` · `SELF JOIN` con `LEFT JOIN` · `COALESCE` para nodos raíz · `GROUP BY` + `HAVING` sobre jerarquía · dos niveles jerárquicos con 3 aliases

---

## Esquema utilizado

La tabla `categories` modela la jerarquía de categorías de la tienda con una columna auto-referencial:

```
categories (id, name, description, parent_id → categories.id)
```

### Jerarquía de 3 niveles

```
Nivel 1 (raíz / parent_id = NULL)
  └── Primera Infancia
  └── Educativos
  └── Acción y Aventura
  └── Juegos de Mesa
  └── Deportes y Aire Libre

Nivel 2 (categorías)
  └── Bebés 0-2 años  →  Primera Infancia
  └── Ciencias y Experimentos  →  Educativos
  └── Vehículos RC  →  Acción y Aventura
  └── ...

Nivel 3 (subcategorías)
  └── Sonajeros  →  Bebés 0-2 años
  └── Microscopios Infantiles  →  Ciencias y Experimentos
  └── Autos RC  →  Vehículos RC
  └── ...
```

**Total:** 23 nodos — 5 raíces, 13 categorías, 23 subcategorías (hojas).

---

## Consultas implementadas

| # | Consulta | Aliases | Qué muestra |
|---|----------|---------|-------------|
| 1 | Subcategoría → su padre | `child`, `parent` | Solo nodos con padre (excluye raíz) |
| 2 | Todos los nodos con etiqueta de raíz | `child`, `parent` + `COALESCE` | Incluye departamentos raíz |
| 3 | Cuántas subcategorías tiene cada categoría | `parent`, `child` + `GROUP BY` | Solo padres con al menos 1 hijo |
| 4 | Dos niveles: subcategoría → categoría → departamento | `child`, `parent`, `grandparent` | Árbol de 3 niveles en una fila |

---

## Cómo ejecutar

```bash
sqlite3 tienda.db < proyecto.sql
```
