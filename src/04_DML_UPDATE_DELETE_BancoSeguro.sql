-------------------------------------
--      UPDATES
-------------------------------------

-- Actualizar datos

-- a) Actualiza el teléfono de un cliente específico
UPDATE clientes
SET telefono = '3001234567'
WHERE numero_documento = '11001100';

-- b) Cambia el estado de una cuenta a 'Bloqueada'
UPDATE cuentas
SET estado = 'Bloqueada'
WHERE numero_cuenta = 10000001;

-- c) Aumenta el salario de todos los empleados en un 10%
UPDATE empleados
SET salario = salario * 1.10
WHERE estado = 'Activo';

-- d) Actualiza el estado de un préstamo de 'Pendiente' a 'Aprobado'
UPDATE prestamos
SET estado = 'Aprobado', fecha_aprobacion = CURRENT_DATE
WHERE id_prestamo = 4 AND estado = 'pendiente';

-- e) Cambia el límite de crédito de todas las tarjetas de crédito aumentándolo en 500,000
UPDATE tarjetas
SET limite_credito = limite_credito + 500000;

-- a) Actualiza el saldo de una cuenta específica después de un depósito de 500,000
UPDATE cuentas
SET saldo = saldo + 500000
WHERE numero_cuenta = 10000002; 

-- b) Reduce el saldo de cuentas que tengan transacciones de retiro 
-- (simula el procesamiento de retiros pendientes)
UPDATE cuentas c
SET saldo = saldo - t.monto
FROM transacciones t
WHERE c.numero_cuenta = t.numero_cuenta_origen
    AND t.id_tipo_transaccion = 2 
    AND t.estado = 'Pendiente';

-- c) Actualiza el estado a 'Inactivo' de los clientes que no tienen cuentas activas
UPDATE clientes c
SET estado = 'Inactivo'
WHERE c.id_cliente NOT IN (
    SELECT id_cliente
    FROM cuentas
    WHERE estado = 'Activa'
);

-------------------------------------
--      DELETES
-------------------------------------

-- Eliminar datos

-- a) Elimina las transacciones con estado 'Fallida'
-- Primero busca
SELECT *
FROM transacciones
WHERE estado = 'Fallida';
-- Luego elimina
DELETE FROM transacciones
WHERE estado = 'Fallida';

-- b) Elimina las tarjetas vencidas (fecha_vencimiento menor a la fecha actual)
-- Primero busca
SELECT *
FROM tarjetas
WHERE fecha_vencimiento < CURRENT_DATE;
-- Luego elimina
DELETE FROM tarjetas
WHERE fecha_vencimiento < CURRENT_DATE;

-- c) Elimina los préstamos rechazados que tienen más de 1 añoA
DELETE FROM prestamos
WHERE estado = 'Rechazado' AND fecha_solicitud < CURRENT_DATE - INTERVAL '1 year';

-- Transacciones Bancarias Complejas

-- a) Verificar que la cuenta origen tenga saldo suficiente
SELECT CASE
            WHEN saldo >= 1000000 THEN 'Saldo suficiente'
            ELSE 'Saldo insuficiente'
        END AS validacion
FROM cuentas
WHERE numero_cuenta = 10000002;

-- b) Restar el monto de la cuenta origen
BEGIN;
-- Verificar saldo suficiente y bloquear la fila
SELECT saldo
FROM cuentas
WHERE numero_cuenta = 10000005
    AND saldo >= 1000000
FOR UPDATE;
-- Restar monto
UPDATE cuentas
SET saldo = saldo - 500000
WHERE numero_cuenta = 10000005;
COMMIT;

-- c) Sumar el monto a la cuenta destino
BEGIN;
-- Verificar y bloquear cuenta destino
SELECT saldo
FROM cuentas
WHERE numero_cuenta = 10000008
FOR UPDATE;
-- Abonar monto
UPDATE cuentas
SET saldo = saldo + 500000
WHERE numero_cuenta = 10000008;
COMMIT;

-- d) Registrar la transacción
INSERT INTO transacciones (
    id_empleado,
    numero_cuenta_origen,
    numero_cuenta_destino,
    id_tipo_transaccion,
    monto,
    descripcion,
    estado,
    fecha_hora
)
VALUES (
    5,
    10000005,
    10000008,
    3,
    500000,
    'Transferencia bancaria',
    'Exitosa',
    NOW()
);