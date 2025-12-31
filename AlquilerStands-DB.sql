-- =====================================================
-- MODELO DIMENSIONAL: SISTEMA DE EVENTOS Y ALQUILERES
-- =====================================================

-- =====================================================
-- DIMENSIÓN: TIEMPO
-- =====================================================
CREATE SEQUENCE SeqTiempo START WITH 1 INCREMENT BY 1;

CREATE TABLE DimTiempo (
    IdTiempo NUMERIC PRIMARY KEY DEFAULT nextval('SeqTiempo'),
    CodigoAnio NUMERIC,
    CodigoTrimestre NUMERIC,
    DescripcionTrimestre VARCHAR(100),
    CodigoMes NUMERIC,
    DescripcionMes VARCHAR(20),
    DescripcionMesCorta VARCHAR(20),
    CodigoSemana NUMERIC,
    CodigoDiaAnio NUMERIC,
    CodigoDiaMes NUMERIC,
    CodigoDiaSemana NUMERIC,
    DescripcionDiaSemana VARCHAR(20),
    Fecha DATE
);

INSERT INTO DimTiempo (
    CodigoAnio, CodigoTrimestre, DescripcionTrimestre, CodigoMes, 
    DescripcionMes, DescripcionMesCorta, CodigoSemana, 
    CodigoDiaAnio, CodigoDiaMes, CodigoDiaSemana, 
    DescripcionDiaSemana, Fecha
) VALUES
-- ===== OCTUBRE 2025 =====
(2025, 4, 'Cuarto Trimestre', 10, 'Octubre', 'Oct', 41, 285, 12, 1, 'Domingo', '2025-10-12'),
(2025, 4, 'Cuarto Trimestre', 10, 'Octubre', 'Oct', 41, 286, 13, 2, 'Lunes',   '2025-10-13'),
(2025, 4, 'Cuarto Trimestre', 10, 'Octubre', 'Oct', 41, 287, 14, 3, 'Martes',  '2025-10-14'),
(2025, 4, 'Cuarto Trimestre', 10, 'Octubre', 'Oct', 41, 288, 15, 4, 'Miércoles','2025-10-15'),
(2025, 4, 'Cuarto Trimestre', 10, 'Octubre', 'Oct', 41, 289, 16, 5, 'Jueves',  '2025-10-16'),
(2025, 4, 'Cuarto Trimestre', 10, 'Octubre', 'Oct', 41, 290, 17, 6, 'Viernes', '2025-10-17'),
-- ===== NOVIEMBRE 2025 =====
(2025, 4, 'Cuarto Trimestre', 11, 'Noviembre', 'Nov', 44, 306, 2, 1, 'Domingo', '2025-11-02'),
(2025, 4, 'Cuarto Trimestre', 11, 'Noviembre', 'Nov', 44, 307, 3, 2, 'Lunes',   '2025-11-03'),
(2025, 4, 'Cuarto Trimestre', 11, 'Noviembre', 'Nov', 44, 308, 4, 3, 'Martes' , '2025-11-04'),
(2025, 4, 'Cuarto Trimestre', 11, 'Noviembre', 'Nov', 44, 309, 5, 4, 'Miércoles','2025-11-05'),
(2025, 4, 'Cuarto Trimestre', 11, 'Noviembre', 'Nov', 44, 310, 6, 5, 'Jueves',  '2025-11-06'),
(2025, 4, 'Cuarto Trimestre', 11, 'Noviembre', 'Nov', 44, 311, 7, 6, 'Viernes', '2025-11-07');

-- =====================================================
-- DIMENSIÓN: SEDE
-- =====================================================
CREATE SEQUENCE SeqSede START WITH 1 INCREMENT BY 1;

CREATE TABLE DimSede (
    IdSede NUMERIC PRIMARY KEY DEFAULT nextval('SeqSede'),
    CodigoPais NUMERIC,
    NombrePais VARCHAR(100),
    NombreCiudad VARCHAR(100),
    CodigoSede NUMERIC,
    NombreSede VARCHAR(100)
);

INSERT INTO DimSede (CodigoSede, NombreSede, NombreCiudad, NombrePais) VALUES
(101, 'Centro Comercial Parque Cerro Verde', 'Caracas',  'Venezuela'),
(102, 'Centro Comercial La Viña', 'Valencia', 'Venezuela'),
(201, 'Centro Comercial Sambil Chacao', 'Caracas', 'Venezuela'),
(202, 'Centro Comercial Tolón', 'Caracas', 'Venezuela'),
(203, 'Brickell City Centre', 'Brickell', 'Estados Unidos');

-- =====================================================
-- DIMENSIÓN: EVENTO
-- =====================================================
CREATE SEQUENCE SeqEvento START WITH 1 INCREMENT BY 1;

CREATE TABLE DimEvento (
    IdEvento NUMERIC PRIMARY KEY DEFAULT nextval('SeqEvento'),
    CodigoTipoEvento NUMERIC,
    NombreTipoEvento VARCHAR(100),
    CodigoEvento NUMERIC,
    NombreEvento VARCHAR(100),
    Descripcion VARCHAR(200)
);

INSERT INTO DimEvento (CodigoTipoEvento, NombreTipoEvento, CodigoEvento, NombreEvento, Descripcion) VALUES
(1, 'Feria', 1001, 'Mamá con Glamour', 'Feria dirigida a madres emprendedoras, marcas premium y experiencias familiares en Cerro Verde'),
(1, 'Feria', 1002, 'Caracas Emprende', 'Evento de networking y exhibición de emprendimientos caraqueños'),
(2, 'Exposición', 1003, 'Expo Diseño CCS', 'Exposición de diseño gráfico, industrial y moda emergente en Caracas'),
(3, 'Gastronómico', 1004, 'Caracas Food Fest', 'Festival gastronómico con food trucks, chefs invitados y experiencias culinarias'),
(4, 'Tecnología', 1005, 'Tech Summit Caracas', 'Evento de innovación, startups, inteligencia artificial y transformación digital'),
(5, 'Moda', 1006, 'Venezuela Fashion Experience', 'Pasarelas, marcas de moda nacional y diseñadores independientes'),
(1, 'Feria', 2001, 'Expo Valencia Empresarial', 'Feria comercial orientada a pymes y empresas de la región central'),
(3, 'Gastronómico', 2002, 'Sabores de Miami', 'Evento gastronómico internacional con chefs latinoamericanos');

-- =====================================================
-- DIMENSIÓN: CLIENTE
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
-- DIMENSIÓN: VISITANTE
-- =====================================================
CREATE SEQUENCE SeqVisitante START WITH 1 INCREMENT BY 1;

CREATE TABLE DimVisitante (
    IdVisitante NUMERIC PRIMARY KEY DEFAULT nextval('SeqVisitante'),
    CodigoVisitante NUMERIC,
    Cedula NUMERIC,
    NombreVisitante VARCHAR(100),
    Sexo VARCHAR(100),
    Email VARCHAR(100)
);

INSERT INTO DimVisitante (CodigoVisitante, Cedula, NombreVisitante, Sexo, Email) VALUES
(7001, 12345678, 'Taylor Swift',     'F', 'taylor1989@mail.com'),
(7002, 23456789, 'Niall Horan',      'M', 'nialljameshoran@mail.com'),
(7003, 34567890, 'Zayn Malik',       'M', 'zayn@mail.com'),
(7004, 45678901, 'Louis Tomlinson',  'M', 'ltomlinson.24@mail.com'),
(7005, 56789012, 'Harry Styles',     'M', 'hstyles@mail.com'),
(7006, 67890123, 'Liam Payne',       'M', 'liampayne@mail.com'),
(7008, 78901234, 'Benson Boone',     'M', 'benson.boone@mail.com');

-- =====================================================
-- DIMENSIÓN: TIPO DE STAND
-- =====================================================
CREATE SEQUENCE SeqTipoStand START WITH 1 INCREMENT BY 1;

CREATE TABLE DimTipoStand (
    IdTipoStand NUMERIC PRIMARY KEY DEFAULT nextval('SeqTipoStand'),
    CodigoTipoStand NUMERIC,
    NombreTipoStand VARCHAR(100)
);

INSERT INTO DimTipoStand (CodigoTipoStand, NombreTipoStand) VALUES
(1, 'Stand Básico'),
(2, 'Stand Estándar'),
(3, 'Stand Premium'),
(4, 'Stand Gastronómico'),
(5, 'Stand Isla'),
(6, 'Stand Corporativo'),
(7, 'Stand Food Truck');

-- =====================================================
-- DIMENSIÓN: CATEGORÍA
-- =====================================================
CREATE SEQUENCE SeqCategoria START WITH 1 INCREMENT BY 1;

CREATE TABLE DimCategoria (
    IdCategoria NUMERIC PRIMARY KEY DEFAULT nextval('SeqCategoria'),
    CodigoSubcategoria NUMERIC,
    NombreSubcategoria VARCHAR(100),
    CodigoCategoria NUMERIC,
    NombreCategoria VARCHAR(100)
);

INSERT INTO DimCategoria (CodigoSubcategoria, NombreSubcategoria, CodigoCategoria, NombreCategoria) VALUES
(101, 'Ropa Femenina',          10, 'Moda'),
(102, 'Ropa Masculina',         10, 'Moda'),
(103, 'Accesorios',             10, 'Moda'),
(104, 'Calzado',                10, 'Moda'),
(201, 'Comida Rápida',          20, 'Gastronomía'),
(202, 'Comida Gourmet',         20, 'Gastronomía'),
(203, 'Café y Postres',         20, 'Gastronomía'),
(204, 'Food Truck',             20, 'Gastronomía'),
(301, 'Electrónica',            30, 'Tecnología'),
(302, 'Software',               30, 'Tecnología'),
(303, 'Accesorios Tech',        30, 'Tecnología'),
(401, 'Cosmética',              40, 'Belleza'),
(402, 'Cuidado Personal',       40, 'Belleza'),
(403, 'Fitness',                40, 'Bienestar'),
(501, 'Servicios Financieros',  50, 'Servicios'),
(502, 'Educación',              50, 'Servicios'),
(503, 'Consultoría',            50, 'Servicios');

-- =====================================================
-- DIMENSIÓN: LEYENDA (ESCALA DE CALIFICACIÓN)
-- =====================================================
CREATE SEQUENCE SeqLeyenda START WITH 1 INCREMENT BY 1;

CREATE TABLE DimLeyenda (
    IdLeyenda NUMERIC PRIMARY KEY DEFAULT nextval('SeqLeyenda'),
    CodigoLeyenda NUMERIC,
    NombreLeyenda VARCHAR(100)
);

INSERT INTO DimLeyenda (CodigoLeyenda, NombreLeyenda) VALUES
(1, '1 estrella'),
(2, '1 estrella y media'),
(3, '2 estrellas'),
(4, '2 estrellas y media'),
(5, '3 estrellas'),
(6, '3 estrellas y media'),
(7, '4 estrellas'),
(8, '4 estrellas y media'),
(9, '5 estrellas'),
(10, '5 estrellas');

-- =====================================================
-- TABLA DE HECHOS: EVENTO
-- =====================================================
CREATE TABLE FactEvento (
    IdEvento NUMERIC,
    IdSede NUMERIC,
    IdFechaEvento NUMERIC,
    CantidadEvento NUMERIC,
    CantidadEstimadaVisitantes NUMERIC,
    MetaIngresos NUMERIC(10,4),

    PRIMARY KEY (IdEvento, IdSede, IdFechaEvento),
    FOREIGN KEY (IdEvento) REFERENCES DimEvento(IdEvento),
    FOREIGN KEY (IdSede) REFERENCES DimSede(IdSede),
    FOREIGN KEY (IdFechaEvento) REFERENCES DimTiempo(IdTiempo)
);

INSERT INTO FactEvento (IdEvento, IdSede, IdFechaEvento, CantidadEvento, CantidadEstimadaVisitantes, MetaIngresos) VALUES
(1, 1, 1,  500, 2000, 2500),
(2, 1, 7,  450, 1800, 2200),
(3, 1, 5,  300, 1000, 1200),
(4, 3, 10, 600, 2500, 3000);

-- =====================================================
-- TABLA DE HECHOS: EVENTO STAND (OFERTA)
-- =====================================================
CREATE TABLE FactEventoStand (
    IdEvento NUMERIC,
    IdTipoStand NUMERIC,
    CantidadEstimada NUMERIC,
    MetrosCuadrados NUMERIC(10,4),
    Precio NUMERIC(10,4),

    PRIMARY KEY (IdEvento, IdTipoStand),
    FOREIGN KEY (IdEvento) REFERENCES DimEvento(IdEvento),
    FOREIGN KEY (IdTipoStand) REFERENCES DimTipoStand(IdTipoStand)
);

INSERT INTO FactEventoStand (IdEvento, IdTipoStand, CantidadEstimada, MetrosCuadrados, Precio) VALUES
(1, 1, 1, 12.5, 2500.00),
(1, 2, 1, 20.0, 4000.00),
(2, 1, 1, 15.0, 3000.00),
(2, 4, 1, 25.0, 5000.00),
(3, 5, 1, 18.0, 3600.00),
(3, 6, 1, 22.0, 4400.00),
(4, 7, 1, 30.0, 6000.00),
(4, 1, 1, 28.0, 5600.00);

-- =====================================================
-- TABLA DE HECHOS: ALQUILER
-- =====================================================
CREATE TABLE FactAlquiler (
    IdEvento NUMERIC,
    IdCliente NUMERIC,
    IdFechaAlquiler NUMERIC,
    IdTipoStand NUMERIC,
    IdCategoria NUMERIC,
    NumeroContrato NUMERIC,
    NumeroStand NUMERIC,
    MetrosCuadrados NUMERIC(10,4),
    MontoTotal NUMERIC(10,4),
    Cantidad NUMERIC,

    PRIMARY KEY (IdEvento, IdCliente, IdFechaAlquiler, IdTipoStand, IdCategoria, NumeroContrato, NumeroStand),
    FOREIGN KEY (IdEvento) REFERENCES DimEvento(IdEvento),
    FOREIGN KEY (IdCliente) REFERENCES DimCliente(IdCliente),
    FOREIGN KEY (IdFechaAlquiler) REFERENCES DimTiempo(IdTiempo),
    FOREIGN KEY (IdTipoStand) REFERENCES DimTipoStand(IdTipoStand),
    FOREIGN KEY (IdCategoria) REFERENCES DimCategoria(IdCategoria)
);

INSERT INTO FactAlquiler (IdEvento, IdCliente, IdFechaAlquiler, IdTipoStand, IdCategoria, NumeroContrato, NumeroStand, MetrosCuadrados, MontoTotal, Cantidad) VALUES
(1, 1, 1, 2, 1, 5001, 1, 12.5, 2500.00, 1),
(1, 2, 1, 3, 2, 5002, 2, 20.0, 4000.00, 1),
(2, 3, 7, 1, 3, 6001, 1, 15.0, 3000.00, 1),
(2, 4, 7, 4, 4, 6002, 2, 25.0, 5000.00, 1),
(3, 5, 5, 5, 5, 7001, 1, 18.0, 3600.00, 1),
(3, 6, 5, 6, 6, 7002, 2, 22.0, 4400.00, 1),
(4, 7, 10, 7, 7, 8001, 1, 30.0, 6000.00, 1),
(4, 8, 10, 1, 8, 8002, 2, 28.0, 5600.00, 1);

-- =====================================================
-- TABLA DE HECHOS: VISITA
-- =====================================================
CREATE TABLE FactVisita (
    IdEvento NUMERIC,
    IdVisitante NUMERIC,
    IdFechaEntrada NUMERIC,
    IdLeyendaEstrellas NUMERIC,
    NumeroEntrada NUMERIC,
    HoraEntrada TIMESTAMP,
    CantidadVisitas NUMERIC,
    CalificacionEvento VARCHAR(100),
    RecomiendaAmigo VARCHAR(100),

    PRIMARY KEY (IdEvento, IdVisitante, IdFechaEntrada, IdLeyendaEstrellas, NumeroEntrada),
    FOREIGN KEY (IdEvento) REFERENCES DimEvento(IdEvento),
    FOREIGN KEY (IdVisitante) REFERENCES DimVisitante(IdVisitante),
    FOREIGN KEY (IdLeyendaEstrellas) REFERENCES DimLeyenda(IdLeyenda),
    FOREIGN KEY (IdFechaEntrada) REFERENCES DimTiempo(IdTiempo)
);

INSERT INTO FactVisita (IdEvento, IdVisitante, IdFechaEntrada, IdLeyendaEstrellas, NumeroEntrada, HoraEntrada, CantidadVisitas, CalificacionEvento, RecomiendaAmigo) VALUES
(1, 1, 1, 9,  1, '2025-10-12 10:00:00', 1, 'Excelente', 'Sí'),
(1, 2, 1, 8,  2, '2025-10-12 10:15:00', 1, 'Muy Bueno', 'Sí'),
(1, 3, 1, 7,  3, '2025-10-12 10:30:00', 1, 'Bueno',     'No'),
(2, 4, 7, 6,  4, '2025-11-03 11:00:00', 1, 'Regular',   'No'),
(2, 5, 7, 9,  5, '2025-11-03 11:15:00', 1, 'Excelente', 'Sí'),
(3, 6, 5, 8,  6, '2025-10-14 12:00:00', 1, 'Muy Bueno', 'Sí'),
(3, 7, 5, 7,  7, '2025-10-14 12:15:00', 1, 'Bueno',     'No'),
(4, 1, 10, 10, 8, '2025-11-05 13:00:00', 1, 'Excelente', 'Sí'),
(4, 2, 10, 9,  9, '2025-11-05 13:15:00', 1, 'Muy Bueno', 'Sí');