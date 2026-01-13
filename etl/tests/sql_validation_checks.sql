-- SQL validation checks (examples)
-- 1) Conteo de filas por dimension
SELECT 'dim_tiempo' as tabla, COUNT(*) FROM dim.dim_tiempo;
SELECT 'dim_sede' as tabla, COUNT(*) FROM dim.dim_sede;

-- 2) Verificar FKs no nulas en hechos (ejemplo FactAlquiler)
SELECT COUNT(*) as registros_con_fk_nula FROM fact.fact_alquiler WHERE id_evento IS NULL OR id_tiempo IS NULL OR id_cliente IS NULL;

-- 3) Duplicados en dimensión Cliente
SELECT codigo_cliente, COUNT(*) FROM dim.dim_cliente GROUP BY codigo_cliente HAVING COUNT(*)>1;

-- 4) Verificar que cada entrada de ENTRADA tiene IdHora asociado (ejemplo)
SELECT COUNT(*) FROM fact.fact_visita WHERE id_hora IS NULL;
