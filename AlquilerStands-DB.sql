-- =====================================================
-- MODELO DIMENSIONAL: SISTEMA DE EVENTOS Y ALQUILERES
-- ExpoEventos 2526 C.A.
-- Esquema: Constelación de Hechos (Galaxy Schema)
-- =====================================================

-- =====================================================
-- DIMENSIÓN CONFORMADA: TIEMPO
-- =====================================================
CREATE SEQUENCE SeqTiempo START WITH 1 INCREMENT BY 1;

CREATE TABLE DimTiempo (
    IdTiempo NUMERIC PRIMARY KEY DEFAULT nextval('SeqTiempo'),
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

INSERT INTO DimTiempo (
    Fecha, CodigoAnio, CodigoTrimestre, DescripcionTrimestre, CodigoSemestre,
    CodigoMes, DescripcionMes, DescripcionMesCorta, CodigoSemana, 
    CodigoDiaAnio, CodigoDiaMes, CodigoDiaSemana, 
    DescripcionDiaSemana, EsFinDeSemana
) VALUES
-- ===== OCTUBRE 2025 =====
('2025-10-12', 2025, 4, 'Cuarto Trimestre', 2, 10, 'Octubre', 'Oct', 41, 285, 12, 1, 'Domingo', TRUE),
('2025-10-13', 2025, 4, 'Cuarto Trimestre', 2, 10, 'Octubre', 'Oct', 41, 286, 13, 2, 'Lunes',   FALSE),
('2025-10-14', 2025, 4, 'Cuarto Trimestre', 2, 10, 'Octubre', 'Oct', 41, 287, 14, 3, 'Martes',  FALSE),
('2025-10-15', 2025, 4, 'Cuarto Trimestre', 2, 10, 'Octubre', 'Oct', 41, 288, 15, 4, 'Miércoles', FALSE),
('2025-10-16', 2025, 4, 'Cuarto Trimestre', 2, 10, 'Octubre', 'Oct', 41, 289, 16, 5, 'Jueves',  FALSE),
('2025-10-17', 2025, 4, 'Cuarto Trimestre', 2, 10, 'Octubre', 'Oct', 41, 290, 17, 6, 'Viernes', FALSE),
-- ===== NOVIEMBRE 2025 =====
('2025-11-02', 2025, 4, 'Cuarto Trimestre', 2, 11, 'Noviembre', 'Nov', 44, 306, 2, 1, 'Domingo', TRUE),
('2025-11-03', 2025, 4, 'Cuarto Trimestre', 2, 11, 'Noviembre', 'Nov', 44, 307, 3, 2, 'Lunes',   FALSE),
('2025-11-04', 2025, 4, 'Cuarto Trimestre', 2, 11, 'Noviembre', 'Nov', 44, 308, 4, 3, 'Martes',  FALSE),
('2025-11-05', 2025, 4, 'Cuarto Trimestre', 2, 11, 'Noviembre', 'Nov', 44, 309, 5, 4, 'Miércoles', FALSE),
('2025-11-06', 2025, 4, 'Cuarto Trimestre', 2, 11, 'Noviembre', 'Nov', 44, 310, 6, 5, 'Jueves',  FALSE),
('2025-11-07', 2025, 4, 'Cuarto Trimestre', 2, 11, 'Noviembre', 'Nov', 44, 311, 7, 6, 'Viernes', FALSE);

-- =====================================================
-- DIMENSIÓN CONFORMADA: SEDE
-- (Jerarquía: País → Ciudad → Sede)
-- =====================================================
CREATE SEQUENCE SeqSede START WITH 1 INCREMENT BY 1;

CREATE TABLE DimSede (
    IdSede NUMERIC PRIMARY KEY DEFAULT nextval('SeqSede'),
    CodigoSede NUMERIC,
    NombreSede VARCHAR(100),
    Ciudad VARCHAR(100),
    Pais VARCHAR(100)
);

INSERT INTO DimSede (CodigoSede, NombreSede, Ciudad, Pais) VALUES
(101, 'Centro Comercial Parque Cerro Verde', 'Caracas',  'Venezuela'),
(102, 'Centro Comercial La Viña',            'Valencia', 'Venezuela'),
(201, 'Centro Comercial Sambil Chacao',      'Caracas',  'Venezuela'),
(202, 'Centro Comercial Tolón',              'Caracas',  'Venezuela'),
(203, 'Brickell City Centre',                'Brickell', 'Estados Unidos');

-- =====================================================
-- DIMENSIÓN CONFORMADA: EVENTO
-- =====================================================
CREATE SEQUENCE SeqEvento START WITH 1 INCREMENT BY 1;

CREATE TABLE DimEvento (
    IdEvento NUMERIC PRIMARY KEY DEFAULT nextval('SeqEvento'),
    CodigoEvento NUMERIC,
    NombreEvento VARCHAR(100),
    Descripcion VARCHAR(200),
    TipoEvento VARCHAR(100)
);

INSERT INTO DimEvento (CodigoEvento, NombreEvento, Descripcion, TipoEvento) VALUES
(1001, 'Mamá con Glamour', 
    'Feria dirigida a madres emprendedoras, marcas premium y experiencias familiares', 
    'Feria'),
(1002, 'Caracas Emprende', 
    'Evento de networking y exhibición de emprendimientos caraqueños', 
    'Feria'),
(1003, 'Expo Diseño CCS',
    'Exposición de diseño gráfico, industrial y moda emergente en Caracas',
    'Exposición'),
(1004, 'Caracas Food Fest', 
    'Festival gastronómico con food trucks, chefs invitados y experiencias culinarias',
    'Gastronómico'),
(1005, 'Tech Summit Caracas', 
    'Evento de innovación, startups, inteligencia artificial y transformación digital',
    'Tecnología'),
(1006, 'Venezuela Fashion Experience', 
    'Pasarelas, marcas de moda nacional y diseñadores independientes',
    'Moda'),
(2001, 'Expo Valencia Empresarial', 
    'Feria comercial orientada a pymes y empresas de la región central',
    'Feria'),
(2002, 'Sabores de Miami', 
    'Evento gastronómico internacional con chefs latinoamericanos',
    'Gastronómico');

-- =====================================================
-- DIMENSIÓN CONFORMADA: TIPO STAND
-- =====================================================
CREATE SEQUENCE SeqTipoStand START WITH 1 INCREMENT BY 1;

CREATE TABLE DimTipoStand (
    IdTipoStand NUMERIC PRIMARY KEY DEFAULT nextval('SeqTipoStand'),
    CodigoTipoStand NUMERIC,
    TipoStand VARCHAR(100)
);

INSERT INTO DimTipoStand (CodigoTipoStand, TipoStand) VALUES
(1, 'Stand Básico'),
(2, 'Stand Estándar'),
(3, 'Stand Premium'),
(4, 'Stand Gastronómico'),
(5, 'Stand Isla'),
(6, 'Stand Corporativo'),
(7, 'Stand Food Truck');

-- =====================================================
-- DIMENSIÓN CONFORMADA: CATEGORÍA
-- (Jerarquía: Categoría → Subcategoría)
-- =====================================================
CREATE SEQUENCE SeqCategoria START WITH 1 INCREMENT BY 1;

CREATE TABLE DimCategoria (
    IdCategoria NUMERIC PRIMARY KEY DEFAULT nextval('SeqCategoria'),
    CodigoCategoria NUMERIC,
    NombreCategoria VARCHAR(100),
    CodigoSubcategoria NUMERIC,
    NombreSubcategoria VARCHAR(100)
);

INSERT INTO DimCategoria (CodigoCategoria, NombreCategoria, CodigoSubcategoria, NombreSubcategoria) VALUES
-- Categoría: Moda
(10, 'Moda', 101, 'Ropa Femenina'),
(10, 'Moda', 102, 'Ropa Masculina'),
(10, 'Moda', 103, 'Accesorios'),
(10, 'Moda', 104, 'Calzado'),
-- Categoría: Gastronomía
(20, 'Gastronomía', 201, 'Comida Rápida'),
(20, 'Gastronomía', 202, 'Comida Gourmet'),
(20, 'Gastronomía', 203, 'Café y Postres'),
(20, 'Gastronomía', 204, 'Food Truck'),
-- Categoría: Tecnología
(30, 'Tecnología', 301, 'Electrónica'),
(30, 'Tecnología', 302, 'Software'),
(30, 'Tecnología', 303, 'Accesorios Tech'),
-- Categoría: Belleza y Bienestar
(40, 'Belleza',    401, 'Cosmética'),
(40, 'Belleza',    402, 'Cuidado Personal'),
(40, 'Bienestar',  403, 'Fitness'),
-- Categoría: Servicios
(50, 'Servicios', 501, 'Servicios Financieros'),
(50, 'Servicios', 502, 'Educación'),
(50, 'Servicios', 503, 'Consultoría');

-- =====================================================
-- DIMENSIÓN ESPECÍFICA: CLIENTE
-- =====================================================
CREATE SEQUENCE SeqCliente START WITH 1 INCREMENT BY 1;

CREATE TABLE DimCliente (
    IdCliente NUMERIC PRIMARY KEY DEFAULT nextval('SeqCliente'),
    CodigoCliente NUMERIC,
    CedulaRif VARCHAR(100),
    NombreCliente VARCHAR(100),
    Telefono VARCHAR(100),
    Direccion VARCHAR(200),
    Email VARCHAR(100)
);

INSERT INTO DimCliente (CodigoCliente, CedulaRif, NombreCliente, Telefono, Direccion, Email) VALUES
(9001, 'J-30123456-7', 'Zara C.A.',                '0414-1111111', 'Caracas, Chacao',        'contacto@zara.com'),
(9002, 'J-30987654-1', 'Bershka S.A.',             '0414-2222222', 'Caracas, El Rosal',      'ventas@bershka.com'),
(9003, 'V-18345678',   'Stradivarius',             '0414-3333333', 'Caracas, La Urbina',     'admin@stradivarius.com'),
(9004, 'V-21456789',   'Mac Store Caracas C.A.',   '0414-4444444', 'Valencia, Prebo',        'info@macstoreccs.com'),
(9005, 'J-29777111-9', 'Sephora',                  '0414-5555555', 'Valencia, Centro',       'contacto@sephora.com'),
(9006, 'J-41234567-2', 'Burger Shack CCS',         '0414-7777777', 'Caracas, Altamira',      'ventas@burgershack.com'),
(9007, 'J-42345678-3', 'Sushi Market Venezuela',   '0414-8888888', 'Caracas, Los Palos G.',  'info@sushimarket.com'),
(9008, 'J-43456789-4', 'Panadería La Castellana',  '0414-9999999', 'Caracas, La Castellana', 'admin@panaderialc.com'),
(9009, 'J-44567890-5', 'Café Aroma Andino',        '0414-1010101', 'Caracas, Bello Monte',   'contacto@aromaandino.com'),
(9010, 'J-45678901-6', 'Gold Gym Caracas',         '0414-2020202', 'Caracas, El Rosal',      'info@goldgymccs.com'),
(9011, 'J-46789012-7', 'Fit Studio CCS',           '0414-3030303', 'Caracas, Chacao',        'contacto@fitstudioccs.com'),
(9012, 'J-47890123-8', 'TechNova Solutions C.A.',  '0414-4040404', 'Caracas, La Urbina',     'ventas@technova.com'),
(9013, 'J-48901234-9', 'DataLab Analytics',        '0414-5050505', 'Caracas, Altamira',      'info@datalab.com');

-- =====================================================
-- DIMENSIÓN ESPECÍFICA: VISITANTE
-- =====================================================
CREATE SEQUENCE SeqVisitante START WITH 1 INCREMENT BY 1;

CREATE TABLE DimVisitante (
    IdVisitante NUMERIC PRIMARY KEY DEFAULT nextval('SeqVisitante'),
    CodigoVisitante NUMERIC,
    Cedula NUMERIC,
    NombreVisitante VARCHAR(100),
    Sexo VARCHAR(1)
);

INSERT INTO DimVisitante (CodigoVisitante, Cedula, NombreVisitante, Sexo) VALUES
(7001, 12345678, 'Taylor Swift',     'F'),
(7002, 23456789, 'Niall Horan',      'M'),
(7003, 34567890, 'Zayn Malik',       'M'),
(7004, 45678901, 'Louis Tomlinson',  'M'),
(7005, 56789012, 'Harry Styles',     'M'),
(7006, 67890123, 'Liam Payne',       'M'),
(7008, 78901234, 'Benson Boone',     'M');

-- =====================================================
-- DIMENSIÓN ESPECÍFICA: HORA
-- (Para análisis de horas pico)
-- =====================================================
CREATE SEQUENCE SeqHora START WITH 1 INCREMENT BY 1;

CREATE TABLE DimHora (
    IdHora NUMERIC PRIMARY KEY DEFAULT nextval('SeqHora'),
    Hora24h VARCHAR(5),
    Turno VARCHAR(20)
);

INSERT INTO DimHora (Hora24h, Turno) VALUES
('08:00', 'Mañana'), ('08:30', 'Mañana'), ('09:00', 'Mañana'), ('09:30', 'Mañana'),
('10:00', 'Mañana'), ('10:30', 'Mañana'), ('11:00', 'Mañana'), ('11:30', 'Mañana'),
('12:00', 'Tarde'),  ('12:30', 'Tarde'),  ('13:00', 'Tarde'),  ('13:30', 'Tarde'),
('14:00', 'Tarde'),  ('14:30', 'Tarde'),  ('15:00', 'Tarde'),  ('15:30', 'Tarde'),
('16:00', 'Tarde'),  ('16:30', 'Tarde'),  ('17:00', 'Tarde'),  ('17:30', 'Tarde'),
('18:00', 'Noche'),  ('18:30', 'Noche'),  ('19:00', 'Noche'),  ('19:30', 'Noche'),
('20:00', 'Noche'),  ('20:30', 'Noche'),  ('21:00', 'Noche'),  ('21:30', 'Noche');

-- =====================================================
-- DIMENSIÓN ESPECÍFICA: CALIFICACIÓN
-- (Separa datos de encuesta de satisfacción)
-- =====================================================
CREATE SEQUENCE SeqCalificacion START WITH 1 INCREMENT BY 1;

CREATE TABLE DimCalificacion (
    IdCalificacion NUMERIC PRIMARY KEY DEFAULT nextval('SeqCalificacion'),
    RecomiendaAmigo VARCHAR(10),
    NumeroEstrellas NUMERIC,
    DescripcionEstrellas VARCHAR(20)
);

INSERT INTO DimCalificacion (RecomiendaAmigo, NumeroEstrellas, DescripcionEstrellas) VALUES
('No',  1, 'Muy Malo'),
('No',  2, 'Malo'),
('No',  3, 'Regular'),
('Sí',  4, 'Bueno'),
('Sí',  5, 'Excelente');

-- =====================================================
-- TABLA DE HECHOS 1: ALQUILER
-- Proceso: Gestión de Alquileres (Ingresos)
-- Granularidad: Una fila por cada contrato de alquiler
-- =====================================================
CREATE TABLE FactAlquiler (
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
    FOREIGN KEY (IdEvento) REFERENCES DimEvento(IdEvento),
    FOREIGN KEY (IdTiempo) REFERENCES DimTiempo(IdTiempo),
    FOREIGN KEY (IdCliente) REFERENCES DimCliente(IdCliente),
    FOREIGN KEY (IdTipoStand) REFERENCES DimTipoStand(IdTipoStand),
    FOREIGN KEY (IdCategoria) REFERENCES DimCategoria(IdCategoria)
);

INSERT INTO FactAlquiler (IdEvento, IdTiempo, IdCliente, IdTipoStand, IdCategoria, NumeroContrato, NumeroStand, MontoAlquiler, MetrosCuadradosAlquilados, CantidadContratos) VALUES
(1, 1, 1, 1, 1, 5001, 1, 2500.00, 12.5, 1),
(1, 1, 2, 2, 2, 5002, 2, 4000.00, 20.0, 1),
(2, 7, 3, 3, 3, 6001, 1, 3000.00, 15.0, 1),
(2, 7, 4, 4, 5, 6002, 2, 5000.00, 25.0, 1),
(3, 5, 5, 5, 9, 7001, 1, 3600.00, 18.0, 1),
(3, 5, 6, 6, 10, 7002, 2, 4400.00, 22.0, 1),
(4, 10, 7, 7, 8, 8001, 1, 6000.00, 30.0, 1),
(4, 10, 8, 1, 1, 8002, 2, 5600.00, 28.0, 1);

-- =====================================================
-- TABLA DE HECHOS 2: VISITA
-- Proceso: Gestión de Visitas y Calidad
-- Granularidad: Una fila por cada entrada de visitante
-- =====================================================
CREATE TABLE FactVisita (
    IdEvento NUMERIC,
    IdTiempo NUMERIC,
    IdHora NUMERIC,
    IdVisitante NUMERIC,
    IdCalificacion NUMERIC,
    NumeroEntrada NUMERIC,
    CantidadVisitas NUMERIC DEFAULT 1,
    ValorCalificacion NUMERIC,

    PRIMARY KEY (IdEvento, IdTiempo, IdHora, IdVisitante, NumeroEntrada),
    FOREIGN KEY (IdEvento) REFERENCES DimEvento(IdEvento),
    FOREIGN KEY (IdTiempo) REFERENCES DimTiempo(IdTiempo),
    FOREIGN KEY (IdHora) REFERENCES DimHora(IdHora),
    FOREIGN KEY (IdVisitante) REFERENCES DimVisitante(IdVisitante),
    FOREIGN KEY (IdCalificacion) REFERENCES DimCalificacion(IdCalificacion)
);

INSERT INTO FactVisita (IdEvento, IdTiempo, IdHora, IdVisitante, IdCalificacion, NumeroEntrada, CantidadVisitas, ValorCalificacion) VALUES
(1, 1, 5,  1, 5, 1, 1, 5),
(1, 1, 6,  2, 5, 2, 1, 5),
(1, 1, 7,  3, 4, 3, 1, 4),
(2, 7, 9,  4, 3, 4, 1, 3),
(2, 7, 10, 5, 5, 5, 1, 5),
(3, 5, 13, 6, 5, 6, 1, 5),
(3, 5, 14, 7, 4, 7, 1, 4),
(4, 10, 17, 1, 5, 8, 1, 5),
(4, 10, 18, 2, 5, 9, 1, 5);

-- =====================================================
-- TABLA DE HECHOS 3: METAS STAND
-- Proceso: Gestión de Metas (Planificación de Stands)
-- Granularidad: Una fila por tipo de stand para cada evento
-- Nota: Incluye IdTiempo para saber CUÁNDO se planificó
-- =====================================================
CREATE TABLE FactMetasStand (
    IdEvento NUMERIC,
    IdTiempo NUMERIC,
    IdTipoStand NUMERIC,
    CantidadEstimada NUMERIC,
    MetrosCuadradosEstimadosTotales NUMERIC(10,4),
    PrecioUnitario NUMERIC(10,4),

    PRIMARY KEY (IdEvento, IdTiempo, IdTipoStand),
    FOREIGN KEY (IdEvento) REFERENCES DimEvento(IdEvento),
    FOREIGN KEY (IdTiempo) REFERENCES DimTiempo(IdTiempo),
    FOREIGN KEY (IdTipoStand) REFERENCES DimTipoStand(IdTipoStand)
);

INSERT INTO FactMetasStand (IdEvento, IdTiempo, IdTipoStand, CantidadEstimada, MetrosCuadradosEstimadosTotales, PrecioUnitario) VALUES
(1, 1, 1, 10, 125.0,  2500.00),
(1, 1, 2, 8,  160.0,  4000.00),
(2, 7, 1, 12, 180.0,  3000.00),
(2, 7, 4, 6,  150.0,  5000.00),
(3, 5, 5, 5,  90.0,   3600.00),
(3, 5, 6, 4,  88.0,   4400.00),
(4, 10, 7, 10, 300.0, 6000.00),
(4, 10, 1, 8,  224.0, 5600.00);

-- =====================================================
-- TABLA DE HECHOS 4: METAS EVENTO
-- Proceso: Gestión de Metas (Planificación General del Evento)
-- Granularidad: Una fila por evento planificado
-- Relacionada con: IdEvento, IdSede, IdTiempo
-- =====================================================
CREATE TABLE FactMetasEvento (
    IdEvento NUMERIC,
    IdSede NUMERIC,
    IdTiempo NUMERIC,
    CantidadEstimadaVisitantes NUMERIC,
    MetaIngresos NUMERIC(10,4),

    PRIMARY KEY (IdEvento, IdSede, IdTiempo),
    FOREIGN KEY (IdEvento) REFERENCES DimEvento(IdEvento),
    FOREIGN KEY (IdSede) REFERENCES DimSede(IdSede),
    FOREIGN KEY (IdTiempo) REFERENCES DimTiempo(IdTiempo)
);

INSERT INTO FactMetasEvento (IdEvento, IdSede, IdTiempo, CantidadEstimadaVisitantes, MetaIngresos) VALUES
(1, 1, 1,  2000, 50000.00),
(2, 3, 7,  1800, 45000.00),
(3, 4, 5,  1000, 35000.00),
(4, 3, 10, 2500, 80000.00),
(5, 1, 3,  1500, 40000.00),
(6, 3, 1,  2200, 55000.00),
(7, 2, 7,  1200, 38000.00),
(8, 5, 8,  3000, 90000.00);