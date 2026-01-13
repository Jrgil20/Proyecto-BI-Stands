-- DIMENSIÓN ESPECÍFICA: VISITANTE
-- =====================================================
CREATE SEQUENCE data_warehouse.SeqVisitante START WITH 1 INCREMENT BY 1;

CREATE TABLE data_warehouse.DimVisitante (
    IdVisitante NUMERIC PRIMARY KEY DEFAULT nextval('data_warehouse.SeqVisitante'),
    CodigoVisitante NUMERIC,
    Cedula NUMERIC,
    NombreVisitante VARCHAR(100),
    Sexo VARCHAR(1)
);

-- =====================================================
-- DIMENSIÓN ESPECÍFICA: HORA
-- (Para análisis de horas pico)
-- =====================================================
CREATE SEQUENCE data_warehouse.SeqHora START WITH 1 INCREMENT BY 1;

CREATE TABLE data_warehouse.DimHora (
    IdHora NUMERIC PRIMARY KEY DEFAULT nextval('data_warehouse.SeqHora'),
    Hora24h VARCHAR(5),
    Turno VARCHAR(20)
);

-- =====================================================
-- DIMENSIÓN ESPECÍFICA: CALIFICACIÓN
-- (Separa datos de encuesta de satisfacción)
-- =====================================================
CREATE SEQUENCE data_warehouse.SeqCalificacion START WITH 1 INCREMENT BY 1;

CREATE TABLE data_warehouse.DimCalificacion (
    IdCalificacion NUMERIC PRIMARY KEY DEFAULT nextval('data_warehouse.SeqCalificacion'),
    RecomiendaAmigo VARCHAR(10),
    NumeroEstrellas NUMERIC,
    DescripcionEstrellas VARCHAR(20)
);

-- =====================================================
-- TABLA DE HECHOS 1: ALQUILER
-- Proceso: Gestión de Alquileres (Ingresos)
-- Granularidad: Una fila por cada contrato de alquiler
-- =====================================================
CREATE TABLE data_warehouse.FactAlquiler (
    IdEvento NUMERIC,
    IdTiempo NUMERIC,
    IdCliente NUMERIC,
    IdTipoStand NUMERIC,
    IdCategoria NUMERIC,
    NumeroContrato NUMERIC,
    NumeroStand NUMERIC,
    MontoAlquiler NUMERIC(10,4),
    MetrosCuadradosAlquilados NUMERIC(10,4),
    CantidadContratos NUMERIC DEFAULT 1,

    PRIMARY KEY (IdEvento, IdTiempo, IdCliente, IdTipoStand, IdCategoria, NumeroContrato, NumeroStand),
    FOREIGN KEY (IdEvento) REFERENCES data_warehouse.DimEvento(IdEvento),
    FOREIGN KEY (IdTiempo) REFERENCES data_warehouse.DimTiempo(IdTiempo),
    FOREIGN KEY (IdCliente) REFERENCES data_warehouse.DimCliente(IdCliente),
    FOREIGN KEY (IdTipoStand) REFERENCES data_warehouse.DimTipoStand(IdTipoStand),
    FOREIGN KEY (IdCategoria) REFERENCES data_warehouse.DimCategoria(IdCategoria)
);

-- =====================================================
-- TABLA DE HECHOS 2: VISITA
-- Proceso: Gestión de Visitas y Calidad
-- Granularidad: Una fila por cada entrada de visitante
-- =====================================================
CREATE TABLE data_warehouse.FactVisita (
    IdEvento NUMERIC,
    IdTiempo NUMERIC,
    IdHora NUMERIC,
    IdVisitante NUMERIC,
    IdCalificacion NUMERIC,
    NumeroEntrada NUMERIC,
    CantidadVisitas NUMERIC DEFAULT 1,
    ValorCalificacion NUMERIC,

    PRIMARY KEY (IdEvento, IdTiempo, IdHora, IdVisitante, NumeroEntrada),
    FOREIGN KEY (IdEvento) REFERENCES data_warehouse.DimEvento(IdEvento),
    FOREIGN KEY (IdTiempo) REFERENCES data_warehouse.DimTiempo(IdTiempo),
    FOREIGN KEY (IdHora) REFERENCES data_warehouse.DimHora(IdHora),
    FOREIGN KEY (IdVisitante) REFERENCES data_warehouse.DimVisitante(IdVisitante),
    FOREIGN KEY (IdCalificacion) REFERENCES data_warehouse.DimCalificacion(IdCalificacion)
);

-- =====================================================
-- TABLA DE HECHOS 3: METAS STAND
-- Proceso: Gestión de Metas (Planificación de Stands)
-- Granularidad: Una fila por tipo de stand para cada evento
-- =====================================================
CREATE TABLE data_warehouse.FactMetasStand (
    IdEvento NUMERIC,
    IdTiempo NUMERIC,
    IdTipoStand NUMERIC,
    CantidadEstimada NUMERIC,
    MetrosCuadradosEstimadosTotales NUMERIC(10,4),
    PrecioUnitario NUMERIC(10,4),

    PRIMARY KEY (IdEvento, IdTiempo, IdTipoStand),
    FOREIGN KEY (IdEvento) REFERENCES data_warehouse.DimEvento(IdEvento),
    FOREIGN KEY (IdTiempo) REFERENCES data_warehouse.DimTiempo(IdTiempo),
    FOREIGN KEY (IdTipoStand) REFERENCES data_warehouse.DimTipoStand(IdTipoStand)
);

-- =====================================================
-- TABLA DE HECHOS 4: METAS EVENTO
-- Proceso: Gestión de Metas (Planificación General del Evento)
-- Granularidad: Una fila por evento planificado
-- =====================================================
CREATE TABLE data_warehouse.FactMetasEvento (
    IdEvento NUMERIC,
    IdSede NUMERIC,
    IdTiempo NUMERIC,
    CantidadEstimadaVisitantes NUMERIC,
    MetaIngresos NUMERIC(10,4),

    PRIMARY KEY (IdEvento, IdSede, IdTiempo),
    FOREIGN KEY (IdEvento) REFERENCES data_warehouse.DimEvento(IdEvento),
    FOREIGN KEY (IdSede) REFERENCES data_warehouse.DimSede(IdSede),
    FOREIGN KEY (IdTiempo) REFERENCES data_warehouse.DimTiempo(IdTiempo)
);

-- *******************************************
-- PERMISOS PARA USUARIO ETL/BI
-- *******************************************
-- Otorgar permisos en schema public
GRANT USAGE ON SCHEMA public TO inteligencia_negocios;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO inteligencia_negocios;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO inteligencia_negocios;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL PRIVILEGES ON TABLES TO inteligencia_negocios;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL PRIVILEGES ON SEQUENCES TO inteligencia_negocios;

-- Otorgar permisos en schema data_warehouse
GRANT USAGE ON SCHEMA data_warehouse TO inteligencia_negocios;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA data_warehouse TO inteligencia_negocios;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA data_warehouse TO inteligencia_negocios;

ALTER DEFAULT PRIVILEGES IN SCHEMA data_warehouse
GRANT ALL PRIVILEGES ON TABLES TO inteligencia_negocios;

ALTER DEFAULT PRIVILEGES IN SCHEMA data_warehouse
GRANT ALL PRIVILEGES ON SEQUENCES TO inteligencia_negocios;

-- =====================================================
-- MODELO RELACIONAL Y DIMENSIONAL: SISTEMA DE EVENTOS Y ALQUILERES
-- ExpoEventos 2526 C.A.
-- Esquema Dual: OLTP (public) + OLAP (data_warehouse)
-- =====================================================

-- =====================================================
-- SCHEMA: PUBLIC (SISTEMA TRANSACCIONAL - OLTP)
-- =====================================================

-- *******************************************
-- Tablas sin dependencias foráneas (Nivel 1)
-- *******************************************

-- 1. PAIS_ORIGEN
CREATE TABLE PAIS_ORIGEN (
    cod_pais_origen INT PRIMARY KEY,
    nb_pais_origen VARCHAR(100) NOT NULL
);

-- 2. TIPO_EVENTO_ORIGEN
CREATE TABLE TIPO_EVENTO_ORIGEN (
    cod_tipo_evento_origen INT PRIMARY KEY,
    nb_tipo_evento_origen VARCHAR(50) NOT NULL,
    CONSTRAINT chk_tipo_evento_origen CHECK (nb_tipo_evento_origen IN ('Feria', 'Bazar', 'Exposición', 'Festival', 'Congreso'))
);

-- 3. TIPO_STAND_ORIGEN
CREATE TABLE TIPO_STAND_ORIGEN (
    cod_tipo_stand_origen INT PRIMARY KEY,
    nb_tipo_stand_origen VARCHAR(50) NOT NULL,
    CONSTRAINT chk_tipo_stand_origen CHECK (nb_tipo_stand_origen IN ('Básico', 'Estándar', 'Premium', 'Gastronómico', 'Isla', 'Corporativo', 'Food Truck'))
);

-- 4. CATEGORIA_ORIGEN
CREATE TABLE CATEGORIA_ORIGEN (
    cod_categoria_origen INT PRIMARY KEY,
    nb_categoria_origen VARCHAR(100) NOT NULL
);

-- 5. CLIENTE_ORIGEN
CREATE TABLE CLIENTE_ORIGEN (
    cod_cliente_origen INT PRIMARY KEY,
    nb_cliente_origen VARCHAR(100) NOT NULL,
    cedula_rif VARCHAR(20) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(255),
    email VARCHAR(100) UNIQUE
);

-- 6. VISITANTE_ORIGEN
CREATE TABLE VISITANTE_ORIGEN (
    cod_visitante_origen INT PRIMARY KEY,
    cedula VARCHAR(20) UNIQUE NOT NULL,
    nb_visitante_origen VARCHAR(100) NOT NULL,
    sexo CHAR(1) CHECK (sexo IN ('M', 'F', 'O')),
    email VARCHAR(100) UNIQUE
);

-- 7. CALIFICACION_ORIGEN
CREATE TABLE CALIFICACION_ORIGEN (
    cod_calificacion_origen INT PRIMARY KEY,
    nb_descripcion_calificacion VARCHAR(50) NOT NULL,
    valor_estrellas INT NOT NULL,
    CONSTRAINT chk_calificacion_origen CHECK (nb_descripcion_calificacion IN ('Muy Malo', 'Malo', 'Regular', 'Bueno', 'Excelente'))
);

-- *******************************************
-- Tablas con dependencias foráneas (Nivel 2)
-- *******************************************

-- 8. CIUDAD_ORIGEN (Depende de PAIS_ORIGEN)
CREATE TABLE CIUDAD_ORIGEN (
    cod_ciudad_origen INT PRIMARY KEY,
    nb_ciudad_origen VARCHAR(100) NOT NULL,
    cod_pais_origen INT NOT NULL,
    FOREIGN KEY (cod_pais_origen) REFERENCES PAIS_ORIGEN(cod_pais_origen)
);

-- 9. SUBCATEGORIA_ORIGEN (Depende de CATEGORIA_ORIGEN)
CREATE TABLE SUBCATEGORIA_ORIGEN (
    cod_subcategoria_origen INT PRIMARY KEY,
    nb_subcategoria_origen VARCHAR(100) NOT NULL,
    cod_categoria_origen INT NOT NULL,
    FOREIGN KEY (cod_categoria_origen) REFERENCES CATEGORIA_ORIGEN(cod_categoria_origen)
);

-- *******************************************
-- Tablas con dependencias foráneas (Nivel 3)
-- *******************************************

-- 10. SEDE_ORIGEN (Depende de CIUDAD_ORIGEN)
CREATE TABLE SEDE_ORIGEN (
    cod_sede_origen INT PRIMARY KEY,
    nb_sede_origen VARCHAR(100) NOT NULL,
    cod_ciudad_origen INT NOT NULL,
    FOREIGN KEY (cod_ciudad_origen) REFERENCES CIUDAD_ORIGEN(cod_ciudad_origen)
);

-- *******************************************
-- Tablas con dependencias foráneas (Nivel 4)
-- *******************************************

-- 11. EVENTO_ORIGEN (Depende de SEDE_ORIGEN y TIPO_EVENTO_ORIGEN)
CREATE TABLE EVENTO_ORIGEN (
    cod_evento_origen INT PRIMARY KEY,
    nb_evento_origen VARCHAR(200) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    descripcion TEXT,
    cod_sede_origen INT NOT NULL,
    email VARCHAR(100) UNIQUE,
    cod_tipo_evento_origen INT NOT NULL,
    FOREIGN KEY (cod_sede_origen) REFERENCES SEDE_ORIGEN(cod_sede_origen),
    FOREIGN KEY (cod_tipo_evento_origen) REFERENCES TIPO_EVENTO_ORIGEN(cod_tipo_evento_origen),
    CONSTRAINT chk_fechas_evento_origen CHECK (fecha_fin >= fecha_inicio)
);

-- 12. EVENTO_STAND_ORIGEN (Relación muchos a muchos)
CREATE TABLE EVENTO_STAND_ORIGEN (
    cod_evento_origen INT NOT NULL,
    cod_tipo_stand_origen INT NOT NULL,
    cantidad_estimada INT NOT NULL,
    mts2 NUMERIC(6, 2) NOT NULL,
    precio NUMERIC(10, 2) NOT NULL,
    PRIMARY KEY (cod_evento_origen, cod_tipo_stand_origen),
    FOREIGN KEY (cod_evento_origen) REFERENCES EVENTO_ORIGEN(cod_evento_origen),
    FOREIGN KEY (cod_tipo_stand_origen) REFERENCES TIPO_STAND_ORIGEN(cod_tipo_stand_origen)
);

-- *******************************************
-- Tablas con dependencias foráneas (Nivel 5)
-- *******************************************

-- 13. CONTRATO_ORIGEN (Depende de EVENTO_STAND_ORIGEN, CLIENTE_ORIGEN y SUBCATEGORIA_ORIGEN)
CREATE TABLE CONTRATO_ORIGEN (
    nro_contrato INT PRIMARY KEY,
    nro_stand INT NOT NULL,
    cod_evento_origen INT NOT NULL,
    cod_tipo_stand_origen INT NOT NULL,
    fecha_alquiler DATE NOT NULL,
    cod_cliente_origen INT NOT NULL,
    mts2 NUMERIC(6, 2) NOT NULL,
    monto NUMERIC(10, 2) NOT NULL,
    cod_subcategoria_origen INT NOT NULL,
    FOREIGN KEY (cod_evento_origen, cod_tipo_stand_origen) REFERENCES EVENTO_STAND_ORIGEN(cod_evento_origen, cod_tipo_stand_origen),
    FOREIGN KEY (cod_cliente_origen) REFERENCES CLIENTE_ORIGEN(cod_cliente_origen),
    FOREIGN KEY (cod_subcategoria_origen) REFERENCES SUBCATEGORIA_ORIGEN(cod_subcategoria_origen)
);

-- 14. ENTRADA_ORIGEN (Depende de EVENTO_ORIGEN, VISITANTE_ORIGEN y CALIFICACION_ORIGEN)
CREATE TABLE ENTRADA_ORIGEN (
    nro_entrada INT PRIMARY KEY,
    cod_evento_origen INT NOT NULL,
    fecha_entrada DATE NOT NULL,
    hora_entrada TIME NOT NULL,
    cod_visitante_origen INT NOT NULL,
    recomienda_amigo BOOLEAN,
    cod_calificacion_origen INT NOT NULL,
    FOREIGN KEY (cod_evento_origen) REFERENCES EVENTO_ORIGEN(cod_evento_origen),
    FOREIGN KEY (cod_visitante_origen) REFERENCES VISITANTE_ORIGEN(cod_visitante_origen),
    FOREIGN KEY (cod_calificacion_origen) REFERENCES CALIFICACION_ORIGEN(cod_calificacion_origen)
);

-- *******************************************
-- INSERTS - SISTEMA TRANSACCIONAL (PUBLIC)
-- *******************************************

-- 1. CALIFICACION_ORIGEN
INSERT INTO CALIFICACION_ORIGEN (cod_calificacion_origen, nb_descripcion_calificacion, valor_estrellas) VALUES
(1, 'Muy Malo', 1),
(2, 'Malo', 2),
(3, 'Regular', 3),
(4, 'Bueno', 4),
(5, 'Excelente', 5);

-- 2. TIPO_EVENTO_ORIGEN
INSERT INTO TIPO_EVENTO_ORIGEN (cod_tipo_evento_origen, nb_tipo_evento_origen) VALUES
(1, 'Feria'),
(2, 'Bazar'),
(3, 'Exposición'),
(4, 'Festival'),
(5, 'Congreso');

-- 3. TIPO_STAND_ORIGEN
INSERT INTO TIPO_STAND_ORIGEN (cod_tipo_stand_origen, nb_tipo_stand_origen) VALUES
(1, 'Básico'),
(2, 'Estándar'),
(3, 'Premium'),
(4, 'Gastronómico'),
(5, 'Isla'),
(6, 'Corporativo'),
(7, 'Food Truck');

-- 4. PAIS_ORIGEN
INSERT INTO PAIS_ORIGEN (cod_pais_origen, nb_pais_origen) VALUES
(1, 'Venezuela'),
(2, 'Colombia'),
(3, 'Argentina'),
(4, 'México'),
(5, 'España'),
(6, 'Estados Unidos'),
(7, 'Perú'),
(8, 'Chile'),
(9, 'Brasil'),
(10, 'Panamá');

-- 5. CATEGORIA_ORIGEN
INSERT INTO CATEGORIA_ORIGEN (cod_categoria_origen, nb_categoria_origen) VALUES
(10, 'Moda'),
(20, 'Gastronomía'),
(30, 'Tecnología'),
(40, 'Belleza y Bienestar'),
(50, 'Servicios Profesionales'),
(60, 'Artesanía'),
(70, 'Literatura y Educación');

-- 6. CLIENTE_ORIGEN
INSERT INTO CLIENTE_ORIGEN (cod_cliente_origen, nb_cliente_origen, cedula_rif, telefono, direccion, email) VALUES
(9001, 'Zara Venezuela C.A.', 'J-30123456-7', '0212-5551111', 'Av. Francisco de Miranda, CCCT', 'contacto@zara.ve'),
(9002, 'Bershka Fashion S.A.', 'J-30987654-1', '0212-5552222', 'CC San Ignacio, Local 45', 'ventas@bershka.ve'),
(9003, 'Stradivarius Style', 'J-31234567-8', '0212-5553333', 'Sambil Caracas, Nivel Libertador', 'admin@stradivarius.ve'),
(9004, 'Mac Store Venezuela C.A.', 'J-32345678-9', '0212-5554444', 'La Castellana, Torre Empresarial', 'info@macstore.ve'),
(9005, 'Sephora Beauty VE', 'J-33456789-0', '0212-5555555', 'Multiplaza, Local 120', 'contacto@sephora.ve'),
(9006, 'Burger King Venezuela', 'J-34567890-1', '0212-5556666', 'Altamira, Centro Comercial', 'ventas@burgerking.ve'),
(9007, 'Sushi Bar Caracas', 'J-35678901-2', '0212-5557777', 'Los Palos Grandes, Edif. Gastro', 'info@sushibar.ve'),
(9008, 'Panadería Danubio C.A.', 'J-36789012-3', '0212-5558888', 'Chacao, Av. Principal', 'admin@danubio.ve'),
(9009, 'Café Venezuela Premium', 'J-37890123-4', '0212-5559999', 'El Rosal, Torre Café', 'contacto@cafevzla.ve'),
(9010, 'FitZone Caracas', 'J-38901234-5', '0212-5550000', 'Las Mercedes, Centro Deportivo', 'info@fitzone.ve'),
(9011, 'YogaLife Studio', 'J-39012345-6', '0212-5551010', 'La Urbina, Complejo Wellness', 'contacto@yogalife.ve'),
(9012, 'TechSolutions VE C.A.', 'J-40123456-7', '0212-5552020', 'El Hatillo, Parque Tecnológico', 'ventas@techsolutions.ve'),
(9013, 'DataCorp Analytics', 'J-41234567-8', '0212-5553030', 'Chuao, Torre Corporativa', 'info@datacorp.ve'),
(9014, 'Artesanías del Valle', 'J-42345678-9', '0212-5554040', 'El Valle, Mercado Artesanal', 'contacto@artesaniasvalle.ve'),
(9015, 'Librería Universitaria', 'J-43456789-0', '0212-5555050', 'Sabana Grande, Boulevard', 'ventas@libreriauniv.ve');

-- 7. VISITANTE_ORIGEN
INSERT INTO VISITANTE_ORIGEN (cod_visitante_origen, cedula, nb_visitante_origen, sexo, email) VALUES
(7001, 'V-28456123', 'Shakira Mebarak', 'F', 'shakira@visitor.com'),
(7002, 'V-29567234', 'Carlos Vives', 'M', 'cvives@visitor.com'),
(7003, 'V-30678345', 'Maluma Restrepo', 'M', 'maluma@visitor.com'),
(7004, 'V-31789456', 'Karol G', 'F', 'karolg@visitor.com'),
(7005, 'V-32890567', 'J Balvin', 'M', 'jbalvin@visitor.com'),
(7006, 'V-33901678', 'Rosalía Vila', 'F', 'rosalia@visitor.com'),
(7007, 'V-34012789', 'Bad Bunny', 'M', 'badbunny@visitor.com'),
(7008, 'V-35123890', 'Becky G', 'F', 'beckyg@visitor.com'),
(7009, 'V-36234901', 'Ozuna Rosado', 'M', 'ozuna@visitor.com'),
(7010, 'V-37345012', 'Natti Natasha', 'F', 'natti@visitor.com');

-- 8. CIUDAD_ORIGEN
INSERT INTO CIUDAD_ORIGEN (cod_ciudad_origen, nb_ciudad_origen, cod_pais_origen) VALUES
(101, 'Caracas', 1),
(102, 'Valencia', 1),
(103, 'Maracaibo', 1),
(104, 'Barquisimeto', 1),
(201, 'Bogotá', 2),
(202, 'Medellín', 2),
(301, 'Buenos Aires', 3),
(401, 'Ciudad de México', 4),
(402, 'Monterrey', 4),
(501, 'Madrid', 5),
(502, 'Barcelona', 5),
(601, 'Miami', 6),
(602, 'New York', 6),
(701, 'Lima', 7),
(801, 'Santiago', 8);

-- 9. SUBCATEGORIA_ORIGEN
INSERT INTO SUBCATEGORIA_ORIGEN (cod_subcategoria_origen, nb_subcategoria_origen, cod_categoria_origen) VALUES
(101, 'Ropa Femenina', 10),
(102, 'Ropa Masculina', 10),
(103, 'Accesorios Fashion', 10),
(104, 'Calzado Premium', 10),
(201, 'Comida Rápida', 20),
(202, 'Comida Gourmet', 20),
(203, 'Café y Postres', 20),
(204, 'Food Truck Especializado', 20),
(301, 'Electrónica Consumer', 30),
(302, 'Software Empresarial', 30),
(303, 'Gadgets y Accesorios', 30),
(401, 'Cosmética Natural', 40),
(402, 'Cuidado Personal', 40),
(403, 'Fitness y Wellness', 40),
(501, 'Consultoría Empresarial', 50),
(502, 'Servicios Legales', 50),
(601, 'Artesanía Tradicional', 60),
(602, 'Arte Contemporáneo', 60),
(701, 'Libros Técnicos', 70),
(702, 'Literatura General', 70);

-- 10. SEDE_ORIGEN
INSERT INTO SEDE_ORIGEN (cod_sede_origen, nb_sede_origen, cod_ciudad_origen) VALUES
(1, 'Centro Comercial Parque Cerro Verde', 101),
(2, 'Centro Comercial La Viña', 102),
(3, 'Centro Comercial Sambil Chacao', 101),
(4, 'Centro Comercial Tolón Fashion Mall', 101),
(5, 'Expo Center Maracaibo', 103),
(6, 'WTC Valencia Convention Center', 102),
(7, 'Parque Central Convention Hall', 101),
(8, 'Brickell City Centre Miami', 601);

-- 11. EVENTO_ORIGEN
INSERT INTO EVENTO_ORIGEN (cod_evento_origen, nb_evento_origen, fecha_inicio, fecha_fin, descripcion, cod_sede_origen, email, cod_tipo_evento_origen) VALUES
(1001, 'Expo Moda Latina 2025', '2025-10-12', '2025-10-17', 'Gran exposición de moda latinoamericana con diseñadores emergentes y consolidados', 1, 'info@expomodalatina.com', 3),
(1002, 'Tech Summit Caracas 2025', '2025-11-02', '2025-11-07', 'Congreso internacional de tecnología, IA y transformación digital', 7, 'contacto@techsummit.ve', 5),
(1003, 'Festival Gastronómico Caribeño', '2025-10-15', '2025-10-17', 'Celebración culinaria con chefs reconocidos del Caribe y Latinoamérica', 3, 'hola@festgastro.com', 4),
(1004, 'Feria del Emprendedor Venezolano', '2025-11-05', '2025-11-07', 'Espacio para emprendimientos locales, networking y capacitación', 4, 'emprendedor@feriave.com', 1),
(1005, 'Expo Belleza y Bienestar 2025', '2025-10-13', '2025-10-16', 'Muestra de productos de belleza, wellness y vida saludable', 6, 'ventas@expobelleza.ve', 3),
(1006, 'Bazar Navideño Premium', '2025-11-03', '2025-11-06', 'Productos artesanales y de diseño para la temporada navideña', 2, 'bazar@navidadpremium.com', 2),
(1007, 'Caracas Book Fair 2025', '2025-10-14', '2025-10-17', 'Feria internacional del libro con autores invitados y editoriales', 3, 'info@caracasbookfair.ve', 1),
(1008, 'Miami Fashion Week Latino', '2025-11-04', '2025-11-07', 'Semana de la moda enfocada en diseñadores latinos', 8, 'contacto@miamifwlatino.com', 4);

-- 12. EVENTO_STAND_ORIGEN
INSERT INTO EVENTO_STAND_ORIGEN (cod_evento_origen, cod_tipo_stand_origen, cantidad_estimada, mts2, precio) VALUES
(1001, 1, 15, 9.00, 1800.00),
(1001, 2, 25, 16.00, 3200.00),
(1001, 3, 10, 25.00, 5500.00),
(1002, 2, 30, 20.00, 4800.00),
(1002, 6, 15, 40.00, 9500.00),
(1003, 4, 20, 15.00, 3500.00),
(1003, 7, 12, 20.00, 4200.00),
(1004, 1, 40, 8.00, 1500.00),
(1004, 2, 20, 12.00, 2400.00),
(1005, 2, 25, 14.00, 2800.00),
(1005, 3, 12, 22.00, 4900.00),
(1006, 1, 35, 6.00, 1200.00),
(1006, 5, 8, 18.00, 3600.00),
(1007, 2, 30, 12.00, 2500.00),
(1007, 3, 10, 20.00, 4500.00),
(1008, 3, 18, 30.00, 7200.00),
(1008, 5, 10, 35.00, 8500.00);

-- 13. CONTRATO_ORIGEN
INSERT INTO CONTRATO_ORIGEN (nro_contrato, nro_stand, cod_evento_origen, cod_tipo_stand_origen, fecha_alquiler, cod_cliente_origen, mts2, monto, cod_subcategoria_origen) VALUES
(5001, 101, 1001, 1, '2025-09-15', 9001, 9.00, 1800.00, 101),
(5002, 102, 1001, 2, '2025-09-16', 9002, 16.00, 3200.00, 102),
(5003, 103, 1001, 3, '2025-09-17', 9003, 25.00, 5500.00, 103),
(6001, 201, 1002, 2, '2025-10-10', 9004, 20.00, 4800.00, 301),
(6002, 202, 1002, 6, '2025-10-11', 9012, 40.00, 9500.00, 302),
(6003, 203, 1002, 6, '2025-10-12', 9013, 40.00, 9500.00, 303),
(7001, 301, 1003, 4, '2025-09-20', 9006, 15.00, 3500.00, 201),
(7002, 302, 1003, 7, '2025-09-21', 9007, 20.00, 4200.00, 202),
(7003, 303, 1003, 4, '2025-09-22', 9008, 15.00, 3500.00, 203),
(8001, 401, 1004, 1, '2025-10-15', 9014, 8.00, 1500.00, 601),
(8002, 402, 1004, 2, '2025-10-16', 9015, 12.00, 2400.00, 701),
(9001, 501, 1005, 2, '2025-09-25', 9005, 14.00, 2800.00, 401),
(9002, 502, 1005, 3, '2025-09-26', 9010, 22.00, 4900.00, 403),
(9003, 503, 1005, 3, '2025-09-27', 9011, 22.00, 4900.00, 403);

-- 14. ENTRADA_ORIGEN
INSERT INTO ENTRADA_ORIGEN (nro_entrada, cod_evento_origen, fecha_entrada, hora_entrada, cod_visitante_origen, recomienda_amigo, cod_calificacion_origen) VALUES
(1, 1001, '2025-10-12', '09:30:00', 7001, TRUE, 5),
(2, 1001, '2025-10-12', '10:15:00', 7002, TRUE, 5),
(3, 1001, '2025-10-13', '11:00:00', 7003, TRUE, 4),
(4, 1001, '2025-10-14', '14:30:00', 7004, FALSE, 3),
(5, 1002, '2025-11-02', '09:00:00', 7005, TRUE, 5),
(6, 1002, '2025-11-03', '10:30:00', 7006, TRUE, 5),
(7, 1002, '2025-11-04', '13:00:00', 7007, TRUE, 4),
(8, 1003, '2025-10-15', '12:00:00', 7008, TRUE, 5),
(9, 1003, '2025-10-16', '14:00:00', 7009, FALSE, 3),
(10, 1004, '2025-11-05', '10:00:00', 7010, TRUE, 4),
(11, 1005, '2025-10-13', '11:30:00', 7001, TRUE, 5),
(12, 1006, '2025-11-03', '15:00:00', 7002, FALSE, 4),
(13, 1007, '2025-10-14', '09:45:00', 7003, TRUE, 5),
(14, 1008, '2025-11-04', '16:30:00', 7004, TRUE, 5);


-- =====================================================
-- SCHEMA: DATA_WAREHOUSE (MODELO DIMENSIONAL - OLAP)
-- =====================================================

CREATE SCHEMA data_warehouse;

-- =====================================================
-- DIMENSIÓN CONFORMADA: TIEMPO
-- =====================================================
CREATE SEQUENCE data_warehouse.SeqTiempo START WITH 1 INCREMENT BY 1;

CREATE TABLE data_warehouse.DimTiempo (
    IdTiempo NUMERIC PRIMARY KEY DEFAULT nextval('data_warehouse.SeqTiempo'),
    Fecha DATE,
    CodigoAnio NUMERIC,
    CodigoTrimestre NUMERIC,
    DescripcionTrimestre VARCHAR(100),
    CodigoSemestre NUMERIC,
    CodigoMes NUMERIC,
    DescripcionMes VARCHAR(20),
    DescripcionMesCorta VARCHAR(20),
    CodigoSemana NUMERIC,
    CodigoDiaAnio NUMERIC,
    CodigoDiaMes NUMERIC,
    CodigoDiaSemana NUMERIC,
    DescripcionDiaSemana VARCHAR(20),
    EsFinDeSemana BOOLEAN
);

-- =====================================================
-- DIMENSIÓN CONFORMADA: SEDE
-- (Jerarquía: País → Ciudad → Sede)
-- =====================================================
CREATE SEQUENCE data_warehouse.SeqSede START WITH 1 INCREMENT BY 1;

CREATE TABLE data_warehouse.DimSede (
    IdSede NUMERIC PRIMARY KEY DEFAULT nextval('data_warehouse.SeqSede'),
    CodigoSede NUMERIC,
    NombreSede VARCHAR(100),
    Ciudad VARCHAR(100),
    Pais VARCHAR(100)
);

-- =====================================================
-- DIMENSIÓN CONFORMADA: EVENTO
-- =====================================================
CREATE SEQUENCE data_warehouse.SeqEvento START WITH 1 INCREMENT BY 1;

CREATE TABLE data_warehouse.DimEvento (
    IdEvento NUMERIC PRIMARY KEY DEFAULT nextval('data_warehouse.SeqEvento'),
    CodigoEvento NUMERIC,
    NombreEvento VARCHAR(100),
    Descripcion VARCHAR(200),
    TipoEvento VARCHAR(100)
);

-- =====================================================
-- DIMENSIÓN CONFORMADA: TIPO STAND
-- =====================================================
CREATE SEQUENCE data_warehouse.SeqTipoStand START WITH 1 INCREMENT BY 1;

CREATE TABLE data_warehouse.DimTipoStand (
    IdTipoStand NUMERIC PRIMARY KEY DEFAULT nextval('data_warehouse.SeqTipoStand'),
    CodigoTipoStand NUMERIC,
    TipoStand VARCHAR(100)
);

-- =====================================================
-- DIMENSIÓN CONFORMADA: CATEGORÍA
-- (Jerarquía: Categoría → Subcategoría)
-- =====================================================
CREATE SEQUENCE data_warehouse.SeqCategoria START WITH 1 INCREMENT BY 1;

CREATE TABLE data_warehouse.DimCategoria (
    IdCategoria NUMERIC PRIMARY KEY DEFAULT nextval('data_warehouse.SeqCategoria'),
    CodigoCategoria NUMERIC,
    NombreCategoria VARCHAR(100),
    CodigoSubcategoria NUMERIC,
    NombreSubcategoria VARCHAR(100)
);

-- =====================================================
-- DIMENSIÓN ESPECÍFICA: CLIENTE
-- =====================================================
CREATE SEQUENCE data_warehouse.SeqCliente START WITH 1 INCREMENT BY 1;

CREATE TABLE data_warehouse.DimCliente (
    IdCliente NUMERIC PRIMARY KEY DEFAULT nextval('data_warehouse.SeqCliente'),
    CodigoCliente NUMERIC,
    CedulaRif VARCHAR(100),
    NombreCliente VARCHAR(100),
    Telefono VARCHAR(100),
    Direccion VARCHAR(200),
    Email VARCHAR(100)
);

-- =====================================================