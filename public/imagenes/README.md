# Imagenes de Mundiales

Coloca aqui las imagenes `.avif` correspondientes a cada edicion de la Copa Mundial.
El nombre de cada archivo debe coincidir exactamente con el campo `imagen` del registro en `data/mundiales.json`.

## Archivos esperados

- `qatar-2022.avif`
- `rusia-2018.avif`
- `brasil-2014.avif`
- `sudafrica-2010.avif`
- `alemania-2006.avif`
- `francia-1998.avif`
- `estados-unidos-1994.avif`
- `mexico-1986.avif`

## Acceso

Las imagenes se sirven de forma estatica mediante `express.static` y son accesibles en:

```
GET /imagenes/<nombre-archivo>
```

Por ejemplo: `GET /imagenes/qatar-2022.avif`
