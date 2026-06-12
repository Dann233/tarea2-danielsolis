import { z } from 'zod';

export const searchSchema = z.object({
  text: z
    .string()
    .trim()
    .nonempty('La busqueda no puede estar vacia')
    .min(3, 'Debe tener al menos 3 caracteres')
    .max(50, 'No puede tener mas de 50 caracteres')
    .transform(value => value.toLowerCase()),
});
