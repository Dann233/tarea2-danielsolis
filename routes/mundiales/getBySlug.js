import * as mundiales from '../../data/mundiales.js';
import { notFound } from '../notFound.js';

export function getBySlug(req, res) {
  const mundial = mundiales.getBySlug(req.params.slug);
  if (!mundial) return notFound(res, 'Mundial no encontrado');
  res.json(mundial);
}
