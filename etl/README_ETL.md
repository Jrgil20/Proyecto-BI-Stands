# ETL - ExpoEventos (ETL folder)

## Propósito
Plantillas y scripts de soporte para implementar los procesos ETL descritos en la guía del proyecto.

## Archivos incluidos
- `kettle.properties` - variables y credenciales (rellenar). 🔑
- `job_load_dimensions.kjb` - job skeleton para cargar dimensiones. ⚙️
- `job_load_facts.kjb` - job skeleton para cargar hechos. ⚙️
- `ETL-D*.ktr` - skeletons de transformaciones para dimensiones. 🧩
- `ETL-F*.ktr` - skeletons de transformaciones para hechos. 🧩
- `tests/sql_validation_checks.sql` - queries de validación post-carga. ✅
- `scripts/align_sequences.sql` - script para alinear secuencias DB con valores actuales. 🔧

## Cómo arrancar (dev)
1. Editar `kettle.properties` con las credenciales de DB. (Nota: `DB_NAME` por defecto es `alquilerStands`.)
2. Validar que `AlquilerStands-DB.sql` ya fue ejecutado en la BD (tablas y secuencias creadas).
3. Abrir Spoon y completar los `.ktr` exportándolos desde aquí o reemplazando contenido con transformaciones reales.
4. Ejecutar `job_load_dimensions.kjb` y revisar `tests/sql_validation_checks.sql`.

## Notas importantes
- Decidir la estrategia de generación de SKs: usar `Seq*` o gestionar desde ETL (recomendado: secuencias DB). 
- Política de lookups fallidos: configure un flujo de errores (rejects) y un operador para revisión manual o registro.

