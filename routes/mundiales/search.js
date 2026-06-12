import * as mundiales from '../../data/mundiales.js';
import { searchSchema } from './search.schema.js';

export function search(req, res) {
  const result = searchSchema.safeParse(req.params);
  if (!result.success) {
    const message = result.error.issues[0]?.message ?? 'Busqueda invalida';
    return res.status(400).json({ error: message });
  }
  const rows = mundiales.search(result.data.text);
  res.json(rows.map(r => r.slug));
}
