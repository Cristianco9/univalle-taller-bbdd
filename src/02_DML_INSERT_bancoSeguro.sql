-------------------------------------
--      INSERTS
-------------------------------------

-- Sucursales
INSERT INTO sucursales (nombre_sucursal, direccion, ciudad, telefono, horario_atencion, fecha_apertura)
VALUES
('BancoSeguro Centro', 'Cra 10 # 20-30', 'Bogotá', '6011234567', 'Lun-Sab 8am-6pm', '2010-03-15'),
('BancoSeguro Norte',  'Av 45 # 102-12', 'Medellín', '604998877', 'Lun-Vie 8am-5pm', '2012-07-10'),
('BancoSeguro Sur',    'Calle 5 # 40-22', 'Cali', '602554433', 'Lun-Sab 9am-4pm', '2015-01-20'),
('BancoSeguro Café',   'Cra 14 # 18-11', 'Manizales', '606332211', 'Lun-Vie 8am-5pm', '2018-05-12');

-- Cargos
INSERT INTO cargos (nombre_cargo, descripcion)
VALUES
('Gerente', 'Responsable de la gestión de la sucursal'),
('Asesor', 'Atiende clientes y gestiona productos bancarios'),
('Cajero', 'Realiza operaciones de caja'),
('Analista', 'Analiza riesgos y operaciones del banco');

-- Empleados
INSERT INTO empleados (id_sucursal, id_cargo, numero_documento, nombres, apellidos, email, telefono, fecha_contratacion, salario, estado)
VALUES
(1, 1, '10101010', 'Carlos', 'Ramírez', 'carlos.ramirez@banco.com', '3001112233', '2019-02-10', 5500000, 'Activo'), -- Gerente
(1, 2, '20202020', 'María', 'Lopez', 'maria.lopez@banco.com', '3002223344', '2020-05-15', 3500000, 'Activo'), -- Asesora
(2, 2, '30303030', 'Juan', 'Gómez', 'juan.gomez@banco.com', '3003334455', '2021-03-10', 3300000, 'Activo'), -- Asesor
(3, 3, '40404040', 'Luisa', 'Martínez', 'luisa.martinez@banco.com', '3004445566', '2021-10-20', 2800000, 'Activo'), -- Cajera
(3, 3, '50505050', 'Andrés', 'Soto', 'andres.soto@banco.com', '3005556677', '2022-01-05', 2700000, 'Activo'), -- Cajero
(4, 4, '60606060', 'Diana', 'Vargas', 'diana.vargas@banco.com', '3006667788', '2020-12-12', 4000000, 'Activo'); -- Analista

-- Clientes
INSERT INTO clientes (tipo_documento, numero_documento, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_nacimiento, email, telefono, direccion, ciudad, estado)
VALUES
('CC','11001100','Jorge','Andrés','Pineda','Cruz','1990-05-12','jorge.pineda@mail.com','3101112233','Cll 10 #5-20','Bogotá','Activo'),
('CC','22002200','Laura','Marcela','Torres','Guzmán','1988-03-20','laura.torres@mail.com','3202223344','Cra 15 #8-12','Cali','Activo'),
('CE','33003300','Miguel',NULL,'Rodríguez','Mora','1995-11-01','miguel.rod@mail.com','3003334455','Av 3N #12-45','Medellín','Activo'),
('NIT','900123456','Empresa','XYZ', 'Industria','Colombia','2000-01-01','contacto@xyz.com','6013456677','Zona Industrial','Bogotá','Activo'),
('CC','44004400','Paula','Andrea','Giraldo','Ortiz','1997-09-22','paula.giraldo@mail.com','3104445566','Cll 45 #22-13','Cali','Activo'),
('PASAPORTE','P123456','Robert','James','Smith','Johnson','1985-07-17','robert.smith@mail.com','3205556677','Cll 90 #20-30','Bogotá','Activo'),
('CC','55005500','Natalia','Sofía','Muñoz','Rivas','1999-12-01','natalia.munoz@mail.com','3106667788','Cra 40 #10-40','Medellín','Activo'),
('CC','66006600','Camilo','José','Duarte','Salas','1992-02-10','camilo.duarte@mail.com','3007778899','Av 33 #44-11','Cali','Activo'),
('CC','77007700','Valentina','Alejandra','Rojas','Melo','2000-08-12','valentina.rojas@mail.com','3118889900','Cll 5 #12-55','Bogotá','Activo'),
('CE','88008800','Samuel','Esteban','Morales','Pérez','1994-06-18','samuel.morales@mail.com','3009990011','Cra 20 #33-22','Manizales','Activo'),
('CC','99009900','Carlos','Andrés','Vega','López','1991-04-25','carlos.vega@mail.com','3121234455','Cll 23 #11-09','Pereira','Activo');

-- Tipos de cuentas
INSERT INTO tipos_cuenta (nombre_tipo, descripcion, permite_interes)
VALUES 
('Ahorro', 'Cuenta de ahorros tradicional', TRUE),
('Corriente', 'Cuenta corriente empresarial y personal', FALSE),
('Nomina', 'Cuenta exclusiva para depósitos de nómina', FALSE);

-- Cuentas
INSERT INTO cuentas (numero_cuenta, id_cliente, id_sucursal, id_tipo_cuenta, saldo, fecha_apertura, estado, tasa_interes)
VALUES
(10000001,1,1,1,1500000,'2022-01-10','Activa',1.2),
(10000002,1,1,2,3000000,'2023-02-15','Activa',NULL),
(10000003,2,3,1,800000,'2021-05-20','Activa',1.1),
(10000004,3,2,1,1200000,'2022-07-11','Activa',1.3),
(10000005,4,1,2,9500000,'2020-03-25','Activa',NULL),
(10000006,5,3,1,500000,'2023-09-01','Activa',1.0),
(10000007,6,1,1,2000000,'2021-12-12','Activa',1.2),
(10000008,7,2,3,1200000,'2022-04-03','Activa',NULL),
(10000009,7,2,1,300000,'2022-05-01','Activa',1.1),
(10000010,8,3,2,4000000,'2023-07-07','Activa',NULL),
(10000011,9,1,1,600000,'2023-03-10','Activa',1.1),
(10000012,10,4,1,750000,'2022-08-18','Activa',1.2),
(10000013,10,4,3,950000,'2023-10-11','Activa',NULL),
(10000014,5,3,1,3000000,'2022-11-20','Activa',1.2),
(10000015,3,2,2,2500000,'2021-09-15','Activa',NULL);

-- Tipos de transacciones
INSERT INTO tipos_transaccion (nombre_tipo, descripcion, requiere_cuenta_destino, requiere_empleado)
VALUES
('Deposito', 'Depósito en efectivo o transferencia externa', FALSE, TRUE),
('Retiro', 'Retiro en ventanilla o cajero', FALSE, TRUE),
('Transferencia', 'Movimiento entre cuentas del banco', TRUE, TRUE),
('Pago', 'Pago de obligaciones o servicios', TRUE, TRUE);

-- Transacciones
INSERT INTO transacciones (
    id_empleado, numero_cuenta_origen, numero_cuenta_destino,
    id_tipo_transaccion, monto, descripcion, estado, fecha_hora
)
VALUES
(2,10000001,NULL,1,500000,'Depósito en ventanilla','Exitosa','2024-01-10 09:15:00'),
(4,10000003,NULL,2,200000,'Retiro en cajero','Exitosa','2024-01-22 14:40:00'),
(3,10000004,10000010,3,300000,'Transferencia cliente a cliente','Exitosa','2024-02-05 11:10:00'),
(1,10000002,NULL,2,150000,'Retiro sucursal','Exitosa','2024-02-17 16:25:00'),
(5,10000005,NULL,1,1000000,'Depósito empresarial','Exitosa','2024-03-03 10:05:00'),
(4,10000006,NULL,2,100000,'Retiro','Fallida','2024-03-18 13:20:00'),
(3,10000007,10000008,3,250000,'Envio entre cuentas','Exitosa','2024-04-12 15:45:00'),
(6,10000009,NULL,1,400000,'Depósito','Exitosa','2024-04-25 09:55:00'),
(2,10000011,NULL,2,50000,'Retiro','Exitosa','2024-05-04 12:10:00'),
(1,10000012,NULL,1,300000,'Depósito','Exitosa','2024-05-27 17:30:00'),
(4,10000013,10000009,3,150000,'Transferencia interna','Exitosa','2024-06-02 09:05:00'),
(3,10000014,NULL,1,200000,'Depósito','Exitosa','2024-06-20 11:22:00'),
(6,10000015,NULL,2,300000,'Retiro','Exitosa','2024-07-08 14:40:00'),
(2,10000008,10000002,3,350000,'Transferencia','Exitosa','2024-07-29 10:10:00'),
(1,10000010,NULL,1,450000,'Depósito','Exitosa','2024-08-14 08:50:00'),
(5,10000006,NULL,2,60000,'Retiro','Exitosa','2024-08-30 13:33:00'),
(4,10000001,10000003,3,500000,'Transferencia','Exitosa','2024-09-09 11:45:00'),
(3,10000002,NULL,1,200000,'Depósito','Exitosa','2024-09-25 16:10:00'),
(2,10000003,NULL,2,100000,'Retiro','Fallida','2024-10-11 15:55:00'),
(1,10000004,NULL,1,150000,'Depósito','Exitosa','2024-10-29 09:40:00'),
(3,10000007,NULL,1,220000,'Depósito reciente','Exitosa','2025-11-05 10:20:00'),
(4,10000002,NULL,2,90000,'Retiro reciente','Exitosa','2025-11-12 14:55:00'),
(1,10000010,10000003,3,320000,'Transferencia reciente','Exitosa','2025-11-20 09:10:00'),
(6,10000015,NULL,1,510000,'Depósito fin de mes','Exitosa','2025-11-28 16:30:00');

-- Tipos de prestamos
INSERT INTO tipos_prestamo (nombre_tipo, descripcion, tasa_minima, tasa_maxima, plazo_max_meses, requiere_garantia)
VALUES
('Personal', 'Crédito libre inversión', 1.0, 2.5, 60, FALSE),
('Hipotecario', 'Préstamo para compra de vivienda', 0.8, 1.8, 240, TRUE),
('Vehiculo', 'Compra de automóvil', 1.2, 2.0, 84, TRUE),
('Educativo', 'Crédito para estudios universitarios', 0.6, 1.5, 120, FALSE);

-- Prestamos
INSERT INTO prestamos (id_cliente, id_empleado, id_tipo_prestamo, monto_solicitado, monto_aprobado, tasa_interes, plazo_meses, cuota_mensual, fecha_solicitud, fecha_aprobacion, estado)
VALUES
(1,2,1,5000000,4500000,1.5,36,150000,'2023-01-10','2023-01-15','Aprobado'),
(2,3,2,200000000,180000000,1.2,180,1800000,'2022-05-22','2022-06-01','Aprobado'),
(3,6,3,35000000,32000000,1.8,60,850000,'2023-03-01','2023-03-05','Aprobado'),
(4,1,1,12000000,NULL,1.6,48,NULL,'2023-10-10',NULL,'Pendiente'),
(5,4,4,8000000,7500000,1.4,36,250000,'2023-06-15','2023-06-20','Aprobado'),
(6,2,1,3000000,NULL,1.5,24,NULL,'2022-09-01',NULL,'Rechazado'),
(7,5,3,50000000,48000000,1.9,72,1200000,'2021-12-12','2021-12-20','Aprobado'),
(8,3,4,10000000,9500000,1.2,48,270000,'2024-01-05','2024-01-10','Aprobado');

-- Tipos de tarjetas
INSERT INTO tipos_tarjeta (nombre_tipo, descripcion, permite_credito, limite_maximo, requiere_cuenta)
VALUES
('Débito', 'Tarjeta débito asociada a cuenta', FALSE, NULL, TRUE),
('Crédito', 'Tarjeta de crédito clásica', TRUE, 20000000, TRUE),
('Oro', 'Tarjeta de crédito nivel Oro', TRUE, 50000000, TRUE);

-- Tarjetas
INSERT INTO tarjetas (numero_tarjeta, numero_cuenta, id_tipo_tarjeta, fecha_emision, fecha_vencimiento, cvv, limite_credito, estado)
VALUES
('1111222233334444',10000001,1,'2022-01-10','2027-01-10','123',NULL,'Activa'),
('2222333344445555',10000002,2,'2021-06-11','2026-06-11','456',8000000,'Activa'),
('3333444455556666',10000003,1,'2023-03-10','2028-03-10','789',NULL,'Activa'),
('4444555566667777',10000004,1,'2022-08-20','2027-08-20','321',NULL,'Activa'),
('5555666677778888',10000005,3,'2020-01-15','2025-01-15','654',30000000,'Bloqueada'),
('6666777788889999',10000006,1,'2023-11-12','2028-11-12','987',NULL,'Activa'),
('7777888899990000',10000007,2,'2022-05-18','2027-05-18','741',12000000,'Activa'),
('8888999900001111',10000008,1,'2023-09-25','2028-09-25','852',NULL,'Activa'),
('9999000011112222',10000009,2,'2021-12-01','2026-12-01','963',15000000,'Vencida'),
('0000111122223333',10000010,3,'2020-06-22','2025-06-22','159',45000000,'Activa');
