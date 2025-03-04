-- Configuración inicial
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = '+01:00';

-- Creamos la BBDD si no existe
CREATE DATABASE BikeRide CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE BikeRide;

-- Tabla de Usuarios
CREATE TABLE Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL, -- Almacenar como hash
    fecha_nac DATE NOT NULL,
    status ENUM('activo', 'inactivo', 'baneado') NOT NULL DEFAULT 'activo'
);

-- Tabla de Emails (usuarios pueden tener múltiples emails)
CREATE TABLE Emails (
    id_email INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    id_usuario INT,
    CONSTRAINT fk_email_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

-- Tabla de Bicicletas
CREATE TABLE Bicicletas (
    id_bici INT AUTO_INCREMENT PRIMARY KEY,
    tipo_bici ENUM('road', 'mtb', 'gravel') NOT NULL,
    marca VARCHAR(255) NOT NULL,
    modelo VARCHAR(255) NOT NULL,
    anio YEAR,
    peso DECIMAL(5,2),
    material VARCHAR(255) NOT NULL,
    status ENUM('en uso', 'vendida', 'en mantenimiento') NOT NULL DEFAULT 'en uso',
    id_usuario INT,
    CONSTRAINT fk_bicicleta_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE SET NULL
);

-- Tabla de Imagenes (se usa para múltiples entidades)
CREATE TABLE Imagenes (
    id_imagen INT AUTO_INCREMENT PRIMARY KEY,
    url VARCHAR(255) NOT NULL,
    tipo ENUM('usuario', 'bicicleta') NOT NULL,
    id_usuario INT NULL,
    id_bici INT NULL,
    CONSTRAINT fk_imagen_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_imagen_bici FOREIGN KEY (id_bici) REFERENCES Bicicletas(id_bici) ON DELETE CASCADE
);

-- Tabla de Rutas (plantilla de rutas sin dueño)
CREATE TABLE Rutas (
    id_ruta INT AUTO_INCREMENT PRIMARY KEY,
    nombre_ruta VARCHAR(255) NOT NULL,
    distancia DECIMAL(7,2) NOT NULL,
    desnivel INT NOT NULL,
    tipo_terreno ENUM('asfalto', 'montaña', 'mixto') NOT NULL,
    descripcion_ruta VARCHAR(255)
);

-- Tabla de Actividades (registro de recorridos realizados)
CREATE TABLE Actividades (
    id_actividad INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    duracion TIME NOT NULL DEFAULT '00:00:00',
    velocidad_media DECIMAL(5,2) NOT NULL,
    velocidad_max DECIMAL(5,2) NOT NULL,
    calorias DECIMAL(7,2),
    id_usuario INT,
    id_bici INT,
    id_ruta INT,
    CONSTRAINT fk_actividades_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE SET NULL,
    CONSTRAINT fk_actividades_bici FOREIGN KEY (id_bici) REFERENCES Bicicletas(id_bici) ON DELETE SET NULL,
    CONSTRAINT fk_actividades_ruta FOREIGN KEY (id_ruta) REFERENCES Rutas(id_ruta) ON DELETE SET NULL
);

-- Tabla de Comentarios
CREATE TABLE Comentarios (
    id_comentario INT AUTO_INCREMENT PRIMARY KEY,
    comentario VARCHAR(255) NOT NULL,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    id_usuario INT,
    id_actividad INT,
    CONSTRAINT fk_comentario_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE SET NULL,
    CONSTRAINT fk_comentario_actividad FOREIGN KEY (id_actividad) REFERENCES Actividades(id_actividad) ON DELETE SET NULL
);

insert into Usuarios (nombre, password, fecha_nac, status)
values(
"Jesus Gonzalez Blanco",
"changeme",
"1982-03-09",
"activo"
);

insert into Emails (email, id_usuario)values
("chuso1982@gmail.com",1),
("jesusgonzalezblanco82@outlook.com",1);

insert into Bicicletas (tipo_bici, marca, modelo, anio, peso, material, status, id_usuario) values
("road", "Orbea", "Orca M20 iTeam", 2022, 7.98, "carbono", "en uso", 1),
("mtb", "Orbea", "Alma H20", 2018, 13.50, "aluminio", "en uso", 1),
("gravel", "Cube", "Analog", 2014, 10.90, "aluminio", "vendida", 1),
("road", "Specialized", "Tarmcac", 2010, 6.90, "Carbono", "en uso", 1);

insert into Rutas(nombre_ruta, distancia, desnivel, tipo_terreno, descripcion_ruta) values
("Triple Corona", 87.45, 1888, "asfalto", "Ruta de alta montaña por la sierra de Madrid en la que ascendemos los puertos de la Morcuera, Navafria y Canencia"),
("Horizontal", 93.35, 834, "montaña", "Ruta por la cuerda Horizontal de la Sierra Norte, desde Somosierra a Navafria ida y vuelta"),
("L'etape 2023", 152.49, 2584, "asfalto", "Ruta muy dura por la Sierra de Gredos"),
("El Caseton", 45.31, 631, "mixta", "Ruta por los caminos del canal hasta el Caseton del Canal");

insert into Actividades(fecha, duracion, velocidad_media, velocidad_max, calorias, id_usuario, id_bici, id_ruta) values
('2022-01-18', '02:41:42', 16.8, 42.8, 1251, 1, 3, 4),
('2023-10-01', '06:09:20', 24.8, 69.6, 2595, 1, 4, 3),
('2019-05-02', '05:07:23', 18.2, 45.4, 834, 1, 2, 2),
('2021-05-29', '04:19:40', 20.02, 67.3, 1977, 1, 4, 1),
('2024-10-10', '04:19:40', 20.02, 67.3, 1977, 1, 1, 1);

insert into Comentarios (comentario, fecha, id_usuario, id_actividad) values
("Ruta muy dura, solo para usuarios expertos", '24-10-10', 1, 5),
("Espectaculares vistas de la Sierra Norte de Madrid", '2019-05-02', 1, 2),
("Si realmente quieres sentir el ciclismo en Madrid tienes que hacer esta ruta, imprescindible", '2021-05-29', 1, 4);

INSERT INTO Usuarios (nombre, password, fecha_nac, status) VALUES
("Jesus Gonzalez Blanco", "changeme", "1982-03-09", "activo"),
("Ana Maria Gonzalez", "password123", "1990-05-12", "activo"),
("Carlos Lopez", "12345", "1985-07-25", "activo"),
("Laura Fernandez", "pass1234", "1992-01-18", "activo"),
("Pedro Sanchez", "pedsan456", "1988-09-30", "activo"),
("David Romero", "davrom789", "1995-11-03", "activo"),
("Sofia Perez", "sofperez01", "1994-02-20", "activo"),
("Manuel Garcia", "manguar202", "1983-08-14", "activo"),
("Lucia Martinez", "lucmar03", "1991-04-11", "activo"),
("Miguel Torres", "miguel78", "1987-10-23", "activo"),
("Alba Rodriguez", "albarod567", "1986-06-05", "activo"),
("Javier Fernandez", "javi87", "1990-12-14", "activo"),
("Raquel Lopez", "raquellop", "1993-03-22", "activo"),
("Luis Gonzalez", "luisgonz23", "1992-09-29", "activo"),
("Cristina Sanchez", "crissan88", "1990-04-16", "activo");

INSERT INTO Emails (email, id_usuario) VALUES
("chuso1982@gmail.com", 1),
("jesusgonzalezblanco82@outlook.com", 1),
("anamg@example.com", 2),
("carloslopez@example.com", 3),
("laura_fer@example.com", 4),
("pedrosanchez@example.com", 5),
("davidromero@example.com", 6),
("sofia.perez@example.com", 7),
("manuelgarcia@example.com", 8),
("lucia.martinez@example.com", 9),
("miguel.torres@example.com", 10),
("alba.rodriguez@example.com", 11),
("javier.fernandez@example.com", 12),
("raquel.lopez@example.com", 13),
("luis.gonzalez@example.com", 14),
("cristina.sanchez@example.com", 15);

INSERT INTO Bicicletas (tipo_bici, marca, modelo, anio, peso, material, status, id_usuario) VALUES
("road", "Trek", "Emonda SL", 2020, 7.50, "carbono", "en uso", 2), 
("mtb", "Cannondale", "Scalpel SE", 2021, 12.00, "aluminio", "en uso", 3),
("gravel", "Bianchi", "Intenso", 2017, 9.50, "acero", "en uso", 4),
("road", "Merida", "Scultura 4000", 2019, 8.30, "carbono", "en uso", 5),
("mtb", "Scott", "Spark 930", 2021, 11.50, "aluminio", "en uso", 6),
("road", "Pinarello", "Dogma F10", 2018, 6.80, "carbono", "en uso", 7),
("gravel", "Felt", "FX 2", 2016, 10.20, "aluminio", "en uso", 8),
("road", "Giant", "Defy Advanced", 2020, 7.80, "carbono", "en uso", 9),
("mtb", "Trek", "Marlin 7", 2022, 12.50, "aluminio", "en uso", 10),
("road", "Canyon", "Endurace CF SL", 2021, 7.60, "carbono", "en uso", 11),
("gravel", "BMC", "URS 01", 2020, 9.40, "carbono", "en uso", 12),
("mtb", "GT", "Force Carbon", 2021, 12.80, "carbono", "en uso", 2),  
("gravel", "Cannondale", "Topstone Carbon", 2020, 9.90, "carbono", "en uso", 3), 
("road", "Cervélo", "R5", 2022, 7.10, "carbono", "en uso", 4),  
("mtb", "Trek", "Fuel EX 9.9", 2020, 12.00, "carbono", "en uso", 5), 
("gravel", "Specialized", "Sequoia", 2018, 10.40, "aluminio", "en uso", 6),
("road", "Bianchi", "Oltre XR4", 2021, 6.90, "carbono", "en uso", 7), 
("mtb", "Marin", "Mount Vision", 2022, 13.20, "aluminio", "en uso", 8), 
("gravel", "Orbea", "Terra", 2021, 9.00, "aluminio", "en uso", 9),  
("road", "Scott", "Addict RC", 2022, 7.50, "carbono", "en uso", 10), 
("mtb", "Cube", "Stereo Hybrid", 2021, 13.00, "aluminio", "en uso", 11), 
("gravel", "Felt", "VR3", 2019, 10.10, "carbono", "en uso", 12), 
("road", "Bianchi", "Oltre XR4", 2021, 6.90, "carbono", "en uso", 13),
("mtb", "Cannondale", "Jekyll 29", 2020, 14.00, "carbono", "en uso", 14),
("gravel", "Trek", "Checkpoint ALR 5", 2021, 10.30, "aluminio", "en uso", 15);

INSERT INTO Rutas (nombre_ruta, distancia, desnivel, tipo_terreno, descripcion_ruta) VALUES
("La Vuelta a la Comunidad", 112.50, 1500, "asfalto", "Ruta en la que se recorre toda la comunidad de Madrid por carreteras secundarias"),
("Desierto de las Bardenas", 75.00, 500, "mixto", "Ruta por las desérticas llanuras de las Bardenas Reales"),
("Sierra de Guadarrama", 120.30, 1800, "montaña", "Ruta exigente por la Sierra de Guadarrama, incluyendo algunos de los picos más altos"),
("La Senda de Cervantes", 98.20, 900, "asfalto", "Ruta tranquila por caminos y carreteras secundarias, ideal para iniciados"),
("Vía Verde del Tajuña", 75.00, 400, "asfalto", "Ruta muy fácil, ideal para todos los niveles a lo largo del río Tajuña"),
("El Camino del Cid", 150.00, 1600, "mixto", "Ruta larga por el interior de Castilla, siguiendo los pasos de El Cid");

INSERT INTO Actividades (fecha, duracion, velocidad_media, velocidad_max, calorias, id_usuario, id_bici, id_ruta) VALUES
('2022-06-12', '03:30:15', 22.3, 58.2, 1850, 2, 5, 5),
('2021-09-15', '02:50:30', 19.5, 55.4, 1600, 3, 6, 1),
('2023-02-10', '01:45:12', 15.8, 47.2, 1350, 4, 7, 2),
('2023-07-19', '04:00:00', 21.0, 60.5, 2000, 5, 8, 6),
('2022-11-03', '05:12:22', 17.5, 50.3, 1400, 6, 9, 3),
('2024-03-25', '03:10:40', 20.7, 65.4, 1900, 7, 10, 4),
('2023-04-20', '02:30:00', 18.0, 45.0, 1200, 8, 11, 5),
('2022-08-22', '04:20:10', 19.8, 53.2, 1700, 9, 12, 2),
('2021-12-05', '03:40:50', 22.1, 62.5, 2100, 10, 13, 1),
('2023-01-14', '03:05:30', 20.3, 59.8, 1800, 11, 14, 6),
('2023-06-25', '02:45:00', 18.5, 55.5, 1450, 12, 15, 4),
('2022-09-30', '04:10:30', 20.0, 50.0, 1600, 13, 27, 5),
('2023-03-15', '03:20:40', 22.4, 62.0, 2000, 14, 28, 2),
('2024-01-05', '04:00:10', 19.3, 58.7, 1750, 15, 29, 6);

INSERT INTO Comentarios (comentario, fecha, id_usuario, id_actividad) VALUES
("Recorrido muy técnico, ideal para los amantes del MTB", '2022-06-12', 2, 6),
("Una ruta muy bonita, aunque algo exigente en algunos tramos", '2021-09-15', 3, 7),
("Perfecta para un día soleado, me encantaron los paisajes", '2023-02-10', 4, 8),
("Desafiante pero muy gratificante, las vistas desde la cima son impresionantes", '2023-07-19', 5, 9),
("Ruta relajada, ideal para un paseo tranquilo", '2022-11-03', 6, 10),
("Excelente para principiantes, se disfruta mucho", '2024-03-25', 7, 11),
("Muy recomendable, aunque hay que estar preparado físicamente", '2023-04-20', 8, 12),
("El terreno es variado, me encantó la combinación de asfalto y caminos", '2022-08-22', 9, 13),
("Un recorrido increíble con vistas panorámicas", '2021-12-05', 10, 14),
("Un poco de todo, desde senderos fáciles hasta tramos difíciles", '2023-01-14', 11, 15),
("La ruta es fácil de seguir y muy agradable", '2023-06-25', 12, 16),
("Excelente experiencia para toda la familia", '2022-09-30', 13, 17),
("Un recorrido largo pero satisfactorio", '2023-03-15', 14, 18),
("Muy variada y divertida, me encantó", '2024-01-05', 15, 19);



