NOTA:EJECUTE .\pruebas.ps1 para ver las evidencias del entregable




# API Copa Mundial FIFA

API REST con Node.js, Express 5, SQLite (`node:sqlite`) y Zod que expone
informacion sobre las ediciones de la Copa Mundial de la FIFA.

## Requisitos

- Node.js 22 o superior
- npm (o pnpm)

## Instalacion

```bash
npm install
```

## Poblar la base de datos

Este paso es **obligatorio** antes de iniciar el servidor por primera vez.
El script lee `data/mundiales.json` y `data/CREATE.SQL`, crea el archivo
`data/mundiales.db` e inserta todas las ediciones:

```bash
npm run createdb
```

Deberia verse algo como:

```
8 ediciones insertadas en data/mundiales.db
```

## Ejecutar el servidor

**Produccion** (node):
```bash
npm start
```

**Desarrollo** (recarga automatica con `--watch`):
```bash
npm run dev
```

El servidor queda disponible en `http://localhost:4321` por defecto.
Para cambiar el host o el puerto crea un archivo `.env` basado en `.env.example`.

## Rutas disponibles

| Ruta | Descripcion |
|------|-------------|
| `GET /` | Descripcion de la API y listado de rutas |
| `GET /mundiales` | Lista resumida de todos los mundiales (slug, nombre, anio, sede, campeon) |
| `GET /mundiales?include=full` | Lista completa con todos los campos |
| `GET /mundial/:slug` | Detalle completo de un mundial por su slug (ej. `qatar-2022`) |
| `GET /campeon/:pais` | Slugs de los mundiales ganados por un pais |
| `GET /random` | Un mundial aleatorio (todos los campos) |
| `GET /search/:text` | Slugs de los mundiales que coincidan con el texto buscado |
| `GET /imagenes/*` | Imagenes estaticas `.avif` de cada edicion |

## Codigos de estado

| Codigo | Cuando ocurre |
|--------|---------------|
| `200` | La solicitud se proceso correctamente |
| `400` | Parametro invalido (pais o texto de busqueda no cumple las reglas de validacion de Zod) |
| `404` | El mundial solicitado no existe, o la ruta no corresponde a ninguna definida |

## Ejemplos de uso con xh

```bash
# Todos los mundiales (vista resumida)
xh GET :4321/mundiales

# Todos los mundiales (vista completa)
xh GET :4321/mundiales include==full

# Un mundial especifico
xh GET :4321/mundial/qatar-2022

# Mundial inexistente -> 404
xh GET :4321/mundial/inexistente

# Mundiales ganados por Argentina
xh GET :4321/campeon/Argentina

# Mundial aleatorio
xh GET :4321/random

# Busqueda por texto
xh GET :4321/search/final

# Busqueda demasiado corta -> 400
xh GET :4321/search/ab
```
