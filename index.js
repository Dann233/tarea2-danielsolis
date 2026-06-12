import express from 'express';
import { getAll } from './routes/mundiales/getAll.js';
import { getBySlug } from './routes/mundiales/getBySlug.js';
import { getRandom } from './routes/mundiales/getRandom.js';
import { getByCampeon } from './routes/mundiales/getByCampeon.js';
import { search } from './routes/mundiales/search.js';

const app = express();
app.enable('strict routing');

const HOST = process.env.HOST ?? 'localhost';
const PORT = process.env.PORT ?? 4321;

app.get('/', (req, res) => {
  res.json({
    nombre: 'API Copa Mundial FIFA',
    version: '1.0.0',
    descripcion: 'API REST con informacion de las ediciones de la Copa Mundial de la FIFA',
    rutas: {
      '/mundiales': 'Lista resumida de todos los mundiales',
      '/mundiales?include=full': 'Lista completa de todos los mundiales',
      '/mundial/:slug': 'Detalle de un mundial por slug',
      '/campeon/:pais': 'Mundiales ganados por un pais',
      '/random': 'Un mundial aleatorio',
      '/search/:text': 'Busqueda de mundiales por texto',
      '/imagenes/*': 'Imagenes estaticas de cada edicion',
    },
  });
});

app.get('/mundiales', getAll);
app.get('/mundial/:slug', getBySlug);
app.get('/random', getRandom);
app.get('/campeon/:pais', getByCampeon);
app.get('/search/:text', search);

app.use('/imagenes', express.static('public/imagenes'));

app.use((req, res) => {
  res.status(404).json({ error: 'Ruta no encontrada' });
});

app.listen(PORT, HOST, () => {
  console.log(`Servidor corriendo en http://${HOST}:${PORT}`);
});
