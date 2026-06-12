export function notFound(res, message) {
  res.status(404).json({ error: message });
}
