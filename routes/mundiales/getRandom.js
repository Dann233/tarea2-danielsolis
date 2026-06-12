import * as mundiales from '../../data/mundiales.js';

export function getRandom(req, res) {
  res.json(mundiales.getRandom());
}
