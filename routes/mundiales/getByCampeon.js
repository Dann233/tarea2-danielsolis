import * as mundiales from '../../data/mundiales.js';
import { campeonSchema } from './campeon.schema.js';

export function getByCampeon(req, res) {
  const result = campeonSchema.safeParse(req.params);
  if (!result.success) {
    const message = result.error.issues[0]?.message ?? 'Pais invalido';
    return res.status(400).json({ error: message });
  }
  const rows = mundiales.getByCampeon(result.data.pais);
  res.json(rows.map(r => r.slug));
}
