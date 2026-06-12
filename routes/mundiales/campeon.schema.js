import { z } from 'zod';

export const campeonSchema = z.object({
  pais: z
    .string()
    .trim()
    .nonempty('El pais no puede estar vacio')
    .min(3, 'El pais debe tener al menos 3 caracteres')
    .max(50, 'El pais no puede tener mas de 50 caracteres'),
});
