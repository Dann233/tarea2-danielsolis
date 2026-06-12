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
