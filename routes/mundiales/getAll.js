import * as mundiales from '../../data/mundiales.js';

export function getAll(req, res) {
  const data = req.query.include === 'full'
    ? mundiales.getAllFull()
    : mundiales.getAll();
  res.json(data);
}
