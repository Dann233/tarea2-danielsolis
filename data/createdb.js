import { DatabaseSync } from 'node:sqlite';
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

const __dirname = dirname(fileURLToPath(import.meta.url));

const sql = readFileSync(join(__dirname, 'CREATE.SQL'), 'utf-8');
const mundiales = JSON.parse(readFileSync(join(__dirname, 'mundiales.json'), 'utf-8'));

const db = new DatabaseSync(join(__dirname, 'mundiales.db'));

db.exec(sql);
db.exec('DELETE FROM mundiales');

const insert = db.prepare(
  `INSERT INTO mundiales (nombre, anio, sede, campeon, subcampeon, goleador, equipos, imagen, slug, resumen, descripcion)
   VALUES (:nombre, :anio, :sede, :campeon, :subcampeon, :goleador, :equipos, :imagen, :slug, :resumen, :descripcion)`
);

for (const mundial of mundiales) {
  insert.run(mundial);
}

console.log(`${mundiales.length} ediciones insertadas en data/mundiales.db`);
