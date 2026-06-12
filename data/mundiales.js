import { DatabaseSync } from 'node:sqlite';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

const __dirname = dirname(fileURLToPath(import.meta.url));
const db = new DatabaseSync(join(__dirname, 'mundiales.db'));

export function getAll() {
  return db.prepare('SELECT slug, nombre, anio, sede, campeon FROM mundiales ORDER BY anio').all();
}

export function getAllFull() {
  return db.prepare('SELECT * FROM mundiales ORDER BY anio').all();
}

export function getBySlug(slug) {
  return db.prepare('SELECT * FROM mundiales WHERE slug = ?').get(slug);
}

export function getRandom() {
  return db.prepare('SELECT * FROM mundiales ORDER BY RANDOM() LIMIT 1').get();
}

export function getByCampeon(pais) {
  return db.prepare('SELECT slug FROM mundiales WHERE campeon = ? COLLATE NOCASE').all(pais);
}

export function search(text) {
  const param = `%${text}%`;
  return db
    .prepare(
      `SELECT slug FROM mundiales
       WHERE nombre      LIKE ?
          OR sede        LIKE ?
          OR campeon     LIKE ?
          OR subcampeon  LIKE ?
          OR goleador    LIKE ?
          OR resumen     LIKE ?
          OR descripcion LIKE ?`
    )
    .all(param, param, param, param, param, param, param);
}
