-- Helper script to align DB sequences with current max values in DW tables
-- Usage: Run after initial bulk/delly loads or when bringing data in that sets SKs manually.
-- For each table and sequence: set sequence to max(SK)+1

DO $$
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN SELECT table_name, column_name, sequence_name FROM (
    VALUES
      ('dim.dim_tiempo', 'sk_tiempo', 'SeqTiempo'),
      ('dim.dim_sede', 'sk_sede', 'SeqSede'),
      ('dim.dim_evento', 'sk_evento', 'SeqEvento'),
      ('dim.dim_tipo_stand', 'sk_tipo_stand', 'SeqTipoStand'),
      ('dim.dim_categoria', 'sk_categoria', 'SeqCategoria'),
      ('dim.dim_cliente', 'sk_cliente', 'SeqCliente'),
      ('dim.dim_visitante', 'sk_visitante', 'SeqVisitante'),
      ('dim.dim_hora', 'sk_hora', 'SeqHora'),
      ('dim.dim_calificacion', 'sk_calificacion', 'SeqCalificacion')
  ) AS t(table_name, column_name, sequence_name)
  LOOP
    EXECUTE format('SELECT setval(pg_get_serial_sequence(%L, %L), COALESCE(MAX(%I),0)+1, false) FROM %s', rec.table_name, rec.column_name, rec.column_name, rec.table_name);
  END LOOP;
END $$;
