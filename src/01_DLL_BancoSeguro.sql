-------------------------------------
-- Crear la BBDD
-------------------------------------
CREATE DATABASE BancoSeguroDB;

-------------------------------------
--      TABLAS
-------------------------------------

-- Entidad Clientes
CREATE TABLE clientes (
    id_cliente          SERIAL PRIMARY KEY,
    tipo_documento      VARCHAR(10) NOT NULL UNIQUE 
                        CHECK (tipo_documento IN ('CC','CE','NIT','PASAPORTE')),
    numero_documento    VARCHAR(20) NOT NULL,
    primer_nombre       VARCHAR(50) NOT NULL,
    segundo_nombre      VARCHAR(50),
    primer_apellido     VARCHAR(50) NOT NULL,
    segundo_apellido    VARCHAR(50),
    fecha_nacimiento    DATE NOT NULL,
    email               VARCHAR(100) UNIQUE NOT NULL,
    telefono            VARCHAR(20),
    direccion           VARCHAR(150),
    ciudad              VARCHAR(50),
    fecha_registro      DATE NOT NULL DEFAULT CURRENT_DATE,
    estado              VARCHAR(10) NOT NULL
                        CHECK (estado IN ('Activo','Inactivo'))
);

-- Entidad Sucursales
CREATE TABLE sucursales (
    id_sucursal         SERIAL PRIMARY KEY,
    nombre_sucursal     VARCHAR(100) NOT NULL,
    direccion           VARCHAR(150) NOT NULL,
    ciudad              VARCHAR(50) NOT NULL,
    telefono            VARCHAR(20),
    horario_atencion    VARCHAR(100),
    fecha_apertura      DATE NOT NULL
);

-- Entidad Empleados
CREATE TABLE empleados (
    id_empleado         SERIAL PRIMARY KEY,
    id_sucursal         INTEGER NOT NULL,
    id_cargo            INTEGER NOT NULL,
    numero_documento    VARCHAR(20) UNIQUE NOT NULL,
    nombres             VARCHAR(100) NOT NULL,
    apellidos           VARCHAR(100) NOT NULL,
    email               VARCHAR(100) UNIQUE NOT NULL,
    telefono            VARCHAR(20),
    fecha_contratacion  DATE NOT NULL,
    salario             NUMERIC(12,2) NOT NULL CHECK (salario > 0),
    estado              VARCHAR(10) NOT NULL
                        CHECK (estado IN ('Activo','Inactivo'))
);

-- Entidad Cargos
CREATE TABLE cargos (
    id_cargo            SERIAL PRIMARY KEY,
    nombre_cargo        VARCHAR(50) NOT NULL UNIQUE,
    descripcion         VARCHAR(150)
);

-- Entidad Cuentas
CREATE TABLE cuentas (
    numero_cuenta       BIGINT PRIMARY KEY,
    id_cliente          INTEGER NOT NULL,
    id_sucursal         INTEGER NOT NULL,
    id_tipo_cuenta      INTEGER NOT NULL,
    saldo               NUMERIC(15,2) NOT NULL DEFAULT 0 CHECK (saldo >= 0),
    fecha_apertura      DATE NOT NULL,
    estado              VARCHAR(15) NOT NULL CHECK (estado IN ('Activa','Bloqueada','Cerrada')),
    tasa_interes        NUMERIC(5,2)
);

-- Entidad Tipo de cuentas
CREATE TABLE tipos_cuenta (
    id_tipo_cuenta      SERIAL PRIMARY KEY,
    nombre_tipo         VARCHAR(30) NOT NULL UNIQUE,
    descripcion         VARCHAR(150),
    permite_interes     BOOLEAN NOT NULL DEFAULT FALSE
);

-- Entidad Transacciones
CREATE TABLE transacciones (
    id_transaccion      SERIAL PRIMARY KEY,
    id_empleado         INTEGER,
    numero_cuenta_origen BIGINT NOT NULL,
    numero_cuenta_destino BIGINT,
    id_tipo_transaccion INTEGER NOT NULL,
    monto               NUMERIC(15,2) NOT NULL CHECK (monto > 0),
    fecha_hora          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descripcion         VARCHAR(200),
    estado              VARCHAR(15) NOT NULL 
                        CHECK (estado IN ('Exitosa','Fallida','Pendiente'))
);

-- Entidad Tipos de trascacciones
CREATE TABLE tipos_transaccion (
    id_tipo_transaccion SERIAL PRIMARY KEY,
    nombre_tipo         VARCHAR(30) NOT NULL UNIQUE,
    descripcion         VARCHAR(150),

    -- Reglas de negocio
    requiere_cuenta_destino BOOLEAN NOT NULL,
    requiere_empleado   BOOLEAN NOT NULL
);

-- Entidad Prestamos
CREATE TABLE prestamos (
    id_prestamo         SERIAL PRIMARY KEY,
    id_cliente          INTEGER NOT NULL,
    id_empleado         INTEGER NOT NULL,
    id_tipo_prestamo    INTEGER NOT NULL,
    monto_solicitado    NUMERIC(15,2) NOT NULL CHECK (monto_solicitado > 0),
    monto_aprobado      NUMERIC(15,2),
    tasa_interes        NUMERIC(5,2) NOT NULL CHECK (tasa_interes > 0),
    plazo_meses         INTEGER NOT NULL CHECK (plazo_meses > 0),
    cuota_mensual       NUMERIC(15,2),
    fecha_solicitud     DATE NOT NULL,
    fecha_aprobacion    DATE,
    estado              VARCHAR(15) NOT NULL 
                        CHECK (estado IN ('Pendiente','Aprobado','Rechazado','Pagado'))
);

-- Entidad tipo de prestamo
CREATE TABLE tipos_prestamo (
    id_tipo_prestamo    SERIAL PRIMARY KEY,
    nombre_tipo         VARCHAR(30) NOT NULL UNIQUE,
    descripcion         VARCHAR(150),

    -- Reglas de negocio
    tasa_minima         NUMERIC(5,2) NOT NULL CHECK (tasa_minima > 0),
    tasa_maxima         NUMERIC(5,2) NOT NULL CHECK (tasa_maxima >= tasa_minima),
    plazo_max_meses     INTEGER NOT NULL CHECK (plazo_max_meses > 0),
    requiere_garantia   BOOLEAN NOT NULL
);

-- Entidad tarjetas
CREATE TABLE tarjetas (
    numero_tarjeta      CHAR(16) PRIMARY KEY,
    numero_cuenta       BIGINT NOT NULL,
    id_tipo_tarjeta     INTEGER NOT NULL,
    fecha_emision       DATE NOT NULL,
    fecha_vencimiento   DATE NOT NULL,
    cvv                 CHAR(3) NOT NULL,
    limite_credito      NUMERIC(15,2),
    estado              VARCHAR(15) NOT NULL 
                        CHECK (estado IN ('Activa','Bloqueada','Vencida'))
);

-- Entidad tipo de tarjeta
CREATE TABLE tipos_tarjeta (
    id_tipo_tarjeta     SERIAL PRIMARY KEY,
    nombre_tipo         VARCHAR(20) NOT NULL UNIQUE,
    descripcion         VARCHAR(150),

    -- Reglas de negocio
    permite_credito     BOOLEAN NOT NULL,
    limite_maximo       NUMERIC(15,2),
    requiere_cuenta     BOOLEAN NOT NULL
);

-------------------------------------
--      LLAVES FORÁNEAS
-------------------------------------

-- Empleado - Cargos (N:1)
ALTER TABLE empleados
ADD CONSTRAINT fk_empleado_cargo
FOREIGN KEY (id_cargo)
REFERENCES cargos(id_cargo);

-- Empleado - Sucursales (N:1)
ALTER TABLE empleados
ADD CONSTRAINT fk_empleado_sucursal
FOREIGN KEY (id_sucursal)
REFERENCES sucursales(id_sucursal);

-- Cuentas - Clientes (N:1)
ALTER TABLE cuentas
ADD CONSTRAINT fk_cuenta_cliente
FOREIGN KEY (id_cliente)
REFERENCES clientes(id_cliente);

-- Cuentas - Sucursales (N:1)
ALTER TABLE cuentas
ADD CONSTRAINT fk_cuenta_sucursal
FOREIGN KEY (id_sucursal)
REFERENCES sucursales(id_sucursal);

-- Cuentas - Tipos de cuenta (N:1)
ALTER TABLE cuentas
ADD CONSTRAINT fk_cuenta_tipo
FOREIGN KEY (id_tipo_cuenta)
REFERENCES tipos_cuenta(id_tipo_cuenta);

-- Transacciones - Tipos de transacciones (N:1)
ALTER TABLE transacciones
ADD CONSTRAINT fk_transaccion_tipo
FOREIGN KEY (id_tipo_transaccion)
REFERENCES tipos_transaccion(id_tipo_transaccion);

-- Transacciones - Cuentas (N:1) (Origen)
ALTER TABLE transacciones
ADD CONSTRAINT fk_transaccion_origen
FOREIGN KEY (numero_cuenta_origen)
REFERENCES cuentas(numero_cuenta);

-- Transacciones - Cuentas (N:1) (Destino)
ALTER TABLE transacciones
ADD CONSTRAINT fk_transaccion_destino
FOREIGN KEY (numero_cuenta_destino)
REFERENCES cuentas(numero_cuenta);

-- Transacciones - Empleado (N:1)
ALTER TABLE transacciones
ADD CONSTRAINT fk_transaccion_empleado
FOREIGN KEY (id_empleado)
REFERENCES empleados(id_empleado);

-- Prestamos - Tipo de prestamos (N:1)
ALTER TABLE prestamos
ADD CONSTRAINT fk_prestamo_tipo
FOREIGN KEY (id_tipo_prestamo)
REFERENCES tipos_prestamo(id_tipo_prestamo);

-- Prestamos - Cliente (N:1)
ALTER TABLE prestamos
ADD CONSTRAINT fk_prestamo_cliente
FOREIGN KEY (id_cliente)
REFERENCES clientes(id_cliente);

-- Prestamos - Empleados (N:1)
ALTER TABLE prestamos
ADD CONSTRAINT fk_prestamo_empleado
FOREIGN KEY (id_empleado)
REFERENCES empleados(id_empleado);

-- Tarjetas - Tipo de tarjetas (N:1)
ALTER TABLE tarjetas
ADD CONSTRAINT fk_tarjeta_tipo
FOREIGN KEY (id_tipo_tarjeta)
REFERENCES tipos_tarjeta(id_tipo_tarjeta);

-- Tarjetas - Cuentas (N:1)
ALTER TABLE tarjetas
ADD CONSTRAINT fk_tarjeta_cuenta
FOREIGN KEY (numero_cuenta)
REFERENCES cuentas(numero_cuenta);

-------------------------------------
--      MODIFICACIONES A LAS ENTIDADES
-------------------------------------
ALTER TABLE clientes
ADD COLUMN felefono_2 VARCHAR(20);

ALTER TABLE transacciones
ALTER COLUMN descripcion TYPE VARCHAR(500);

ALTER TABLE prestamos
ADD COLUMN observaciones TEXT;