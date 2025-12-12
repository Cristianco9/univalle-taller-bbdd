-------------------------------------
--      QUERIES
-------------------------------------

-- SELECT básicas

-- a) Selecciona todos los clientes ordenados alfabéticamente por apellido
SELECT * 
FROM clientes
ORDER BY primer_apellido ASC;

-- b) Muestra todas las cuentas con saldo mayor a 1,000,000
SELECT * 
FROM cuentas
WHERE saldo > 1000000;

-- c) Lista todos los empleados que trabajan en la sucursal de Bogotá
SELECT * 
FROM empleados
WHERE id_sucursal = (SELECT id_sucursal FROM sucursales WHERE ciudad = 'Bogotá');

-- d) Muestra todas las transacciones realizadas en el último mes
SELECT *
FROM transacciones
WHERE fecha_hora >= NOW() - INTERVAL '1 month';

-- e) Lista todos los préstamos aprobados
SELECT *
FROM prestamos
WHERE estado = 'Aprobado';

-- f) Muestra las tarjetas de crédito activas con su límite
SELECT *
FROM tarjetas t
JOIN tipos_tarjeta tt 
    ON t.id_tipo_tarjeta = tt.id_tipo_tarjeta
WHERE 
    t.estado = 'Activa'
    AND tt.permite_credito = TRUE;

-- SELECT con JOIN

-- a) Muestra el nombre del cliente, número de cuenta y saldo de todas las cuentas
SELECT CONCAT(
	c.primer_nombre, ' ', 
	c.segundo_nombre, ' ', 
	c.primer_apellido, ' ', 
	c.segundo_apellido) AS nombre_completo,
	ct.numero_cuenta,
	ct.saldo
FROM clientes c
JOIN cuentas ct ON ct.id_cliente = c.id_cliente;

-- b) Lista todas las transacciones mostrando: fecha, tipo, monto, cuenta origen 
-- (con nombre del cliente)
SELECT 
	tr.fecha_hora, 
	tr.numero_cuenta_origen,
	tr.monto,
	tt.nombre_tipo AS tipo_transaccion,
    CONCAT_WS(
        ' ', 
        c.primer_nombre, 
        c.segundo_nombre, 
        c.primer_apellido, 
        c.segundo_apellido
    ) AS nombre_completo
FROM transacciones tr
JOIN tipos_transaccion tt ON tr.id_tipo_transaccion = tt.id_tipo_transaccion
JOIN cuentas ct ON ct.numero_cuenta = tr.numero_cuenta_origen
JOIN clientes c ON c.id_cliente = ct.id_cliente;

-- c) Muestra los préstamos con: nombre del cliente, tipo de préstamo, 
-- monto aprobado y nombre del empleado que aprobó
SELECT
	tp.nombre_tipo,
	tp.descripcion,
	p.monto_solicitado,
	p.monto_aprobado,
	CONCAT_WS(
        ' ', 
        cl.primer_nombre, 
        cl.segundo_nombre, 
        cl.primer_apellido, 
        cl.segundo_apellido
    ) AS cliente,
	CONCAT_WS(
		' ',
		ep.nombres,
		ep.apellidos
	) AS empleado
FROM prestamos p
JOIN clientes cl ON cl.id_cliente = p.id_cliente
JOIN tipos_prestamo tp ON tp.id_tipo_prestamo = p.id_tipo_prestamo
JOIN empleados ep ON ep.id_empleado = p.id_empleado;

-- d) Lista las cuentas de cada sucursal mostrando: nombre sucursal, cantidad de 
-- cuentas, suma total de saldos
SELECT 
    s.nombre_sucursal,
    COUNT(c.numero_cuenta) AS cantidad_cuentas,
    SUM(c.saldo) AS saldo_total
FROM sucursales s
JOIN cuentas c 
    ON c.id_sucursal = s.id_sucursal
GROUP BY s.nombre_sucursal;

-- e) Muestra los clientes que tienen tarjetas de crédito con su límite disponible
SELECT 
    CONCAT_WS(
        ' ', 
        c.primer_nombre, 
        c.segundo_nombre, 
        c.primer_apellido, 
        c.segundo_apellido
    ) AS cliente,
	ct.numero_cuenta,
	tj.numero_tarjeta,
	tj.limite_credito
FROM clientes c
JOIN cuentas ct ON ct.id_cliente = c.id_cliente
JOIN tarjetas tj ON tj.numero_cuenta = ct.numero_cuenta
WHERE tj.id_tipo_tarjeta = (
SELECT id_tipo_tarjeta FROM tipos_tarjeta WHERE nombre_tipo = 'Crédito');

-- SELECT con funciones de agregación

-- a) ¿Cuántos clientes tiene el banco en total?
SELECT COUNT(*) AS total_clientes
FROM clientes;

-- b) ¿Cuál es el saldo promedio de las cuentas de ahorro?
SELECT AVG(saldo) AS saldo_promedio_ahorros
FROM cuentas
WHERE id_tipo_cuenta = (
SELECT id_tipo_cuenta FROM tipos_cuenta WHERE nombre_tipo = 'Ahorro'
);

-- c) ¿Cuál es el monto total de préstamos aprobados por tipo de préstamo?
SELECT 
	tp.nombre_tipo AS tipo_prestamo,
	SUM(p.monto_aprobado) AS monto_total
FROM prestamos p
JOIN tipos_prestamo tp ON tp.id_tipo_prestamo = p.id_tipo_prestamo
WHERE estado = 'Aprobado'
GROUP BY tp.nombre_tipo;

-- d) ¿Cuántas transacciones se han realizado por tipo?
SELECT
    tp.nombre_tipo AS tipo_transaccion,
    COUNT(*) AS total_transacciones
FROM transacciones t
JOIN tipos_transaccion tp ON tp.id_tipo_transaccion = t.id_tipo_transaccion
GROUP BY tp.nombre_tipo;

-- e) ¿Cuál es la sucursal con más empleados?
SELECT
	s.nombre_sucursal,
	COUNT(e.id_empleado) AS total_empleados
FROM sucursales s
JOIN empleados e ON e.id_sucursal = s.id_sucursal
GROUP BY s.id_sucursal, s.nombre_sucursal
ORDER BY total_empleados DESC
LIMIT 1;

-- f) ¿Cuál es el cliente con mayor saldo total (sumando todas sus cuentas)?
SELECT
	c.id_cliente,
    CONCAT_WS(
        ' ', 
        c.primer_nombre, 
        c.segundo_nombre, 
        c.primer_apellido, 
        c.segundo_apellido
    ) AS cliente,
	SUM(ct.saldo) AS saldo_total
FROM clientes c
JOIN cuentas ct ON ct.id_cliente = c.id_cliente
GROUP BY c.id_cliente, cliente
ORDER BY saldo_total DESC
LIMIT 1;

-- SELECT avanzadas

-- a) Lista los clientes que NO tienen ninguna cuenta
SELECT
	c.id_cliente,
    CONCAT_WS(
        ' ',
        c.primer_nombre,
        c.segundo_nombre,
        c.primer_apellido,
        c.segundo_apellido
    ) AS cliente
FROM clientes c
LEFT JOIN cuentas ct ON ct.id_cliente = c.id_cliente
WHERE ct.id_cliente IS NULL;

-- b) Muestra los empleados que han aprobado más de 2 préstamos
SELECT
	e.id_empleado,
	CONCAT_WS(
		' ', 
		e.nombres, 
		e.apellidos
	) AS empleado,
	COUNT(*) AS cantidad_prestamos_aprobados
FROM prestamos p
JOIN empleados e ON e.id_empleado = p.id_empleado
GROUP BY e.id_empleado, empleado
HAVING COUNT(*) > 1;

-- c) Lista las cuentas que no han tenido transacciones en los últimos 30 días
SELECT 
    c.numero_cuenta,
    c.id_cliente,
    c.saldo
FROM cuentas c
LEFT JOIN transacciones t
    ON (t.numero_cuenta_origen = c.numero_cuenta 
        OR t.numero_cuenta_destino = c.numero_cuenta)
    AND t.fecha_hora >= NOW() - INTERVAL '30 days'
WHERE t.id_transaccion IS NULL;

-- d) Muestra los clientes que tienen tanto cuenta de ahorro como cuenta corriente
SELECT 
    c.id_cliente,
    CONCAT_WS(
		' ', 
		c.primer_nombre, 
		c.segundo_nombre, 
		c.primer_apellido, 
		c.segundo_apellido
	) AS nombre_completo
FROM clientes c
JOIN cuentas ct ON ct.id_cliente = c.id_cliente
WHERE ct.id_tipo_cuenta IN (
	(SELECT id_tipo_cuenta FROM tipos_cuenta WHERE nombre_tipo = 'Ahorro'), 
	(SELECT id_tipo_cuenta FROM tipos_cuenta WHERE nombre_tipo = 'Corriente')
)
GROUP BY c.id_cliente, nombre_completo
HAVING COUNT(DISTINCT ct.id_tipo_cuenta) = 2;

-- e) Lista las 5 transacciones de mayor monto realizadas
SELECT *
FROM transacciones
ORDER BY monto DESC
LIMIT 5;