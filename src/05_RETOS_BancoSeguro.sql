-------------------------------------
--      CHALLENGES
-------------------------------------

-- vistas

-- a) `vista_resumen_clientes`: 
-- Muestra id, 
-- nombre completo, 
-- cantidad de cuentas, 
-- saldo total
CREATE OR REPLACE VIEW vista_resumen_clientes AS
SELECT 
    c.id_cliente,
    CONCAT(
        c.primer_nombre, ' ',
        COALESCE(c.segundo_nombre, ''), ' ',
        c.primer_apellido, ' ',
        COALESCE(c.segundo_apellido, '')
    ) AS nombre_completo,
    COUNT(ct.numero_cuenta) AS cantidad_cuentas,
    COALESCE(SUM(ct.saldo), 0) AS saldo_total
FROM clientes c
LEFT JOIN cuentas ct ON c.id_cliente = ct.id_cliente
GROUP BY c.id_cliente, c.primer_nombre, c.segundo_nombre, 
        c.primer_apellido, c.segundo_apellido;

SELECT * FROM vista_resumen_clientes;


-- b) `vista_transacciones_detalle`: Muestra todas las transacciones con nombres 
-- de clientes (origen y destino)
CREATE OR REPLACE VIEW vista_transacciones_detalle AS
SELECT 
    t.id_transaccion,
    t.fecha_hora,
    tt.nombre_tipo AS tipo_transaccion,
    t.monto,
    t.estado,
    CONCAT(
        co.primer_nombre, ' ',
        co.primer_apellido
    ) AS cliente_origen,
    CONCAT(
        cd.primer_nombre, ' ',
        cd.primer_apellido
    ) AS cliente_destino
FROM transacciones t
JOIN tipos_transaccion tt ON t.id_tipo_transaccion = tt.id_tipo_transaccion
JOIN cuentas c_origen ON t.numero_cuenta_origen = c_origen.numero_cuenta
JOIN clientes co ON c_origen.id_cliente = co.id_cliente
LEFT JOIN cuentas c_destino ON t.numero_cuenta_destino = c_destino.numero_cuenta
LEFT JOIN clientes cd ON c_destino.id_cliente = cd.id_cliente;

SELECT * FROM vista_transacciones_detalle;

-- c) `vista_prestamos_activos`: Muestra todos los préstamos aprobados con 
-- información del cliente
CREATE OR REPLACE VIEW vista_prestamos_activos AS
SELECT 
    p.id_prestamo,
    CONCAT(
        c.primer_nombre, ' ',
        c.primer_apellido
    ) AS nombre_cliente,
    tp.nombre_tipo AS tipo_prestamo,
    p.monto_aprobado,
    p.tasa_interes,
    p.plazo_meses,
    p.cuota_mensual,
    p.fecha_aprobacion
FROM prestamos p
JOIN clientes c ON p.id_cliente = c.id_cliente
JOIN tipos_prestamo tp ON p.id_tipo_prestamo = tp.id_tipo_prestamo
WHERE p.estado = 'Aprobado';

SELECT * FROM vista_prestamos_activos;

-- Procedimientos Almacenados

-- a) `sp_abrir_cuenta`: Procedimiento que recibe datos de un cliente 
-- y abre una nueva cuenta
CREATE OR REPLACE PROCEDURE sp_abrir_cuenta(
    p_numero_cuenta   BIGINT,
    p_id_cliente      INTEGER,
    p_id_sucursal     INTEGER,
    p_id_tipo_cuenta  INTEGER,
    p_saldo_inicial   NUMERIC,
    p_tasa_interes    NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO cuentas (
        numero_cuenta,
        id_cliente,
        id_sucursal,
        id_tipo_cuenta,
        saldo,
        fecha_apertura,
        estado,
        tasa_interes
    )
    VALUES (
        p_numero_cuenta,
        p_id_cliente,
        p_id_sucursal,
        p_id_tipo_cuenta,
        p_saldo_inicial,
        CURRENT_DATE,
        'Activa',
        p_tasa_interes
    );
END;
$$;

CALL sp_abrir_cuenta(10000099, 1, 1, 1, 500000, 2.5);
SELECT * FROM cuentas;

-- b) `sp_realizar_transferencia`: Procedimiento que realiza una 
-- transferencia entre dos cuentas
CREATE OR REPLACE PROCEDURE sp_realizar_transferencia(
    p_cuenta_origen    BIGINT,
    p_cuenta_destino   BIGINT,
    p_monto            NUMERIC,
    p_id_empleado      INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_saldo_actual NUMERIC;
BEGIN
    -- Obtener saldo de la cuenta origen
    SELECT saldo
    INTO v_saldo_actual
    FROM cuentas
    WHERE numero_cuenta = p_cuenta_origen;

    -- Validar saldo suficiente
    IF v_saldo_actual < p_monto THEN
        RAISE EXCEPTION 'Saldo insuficiente en la cuenta origen';
    END IF;

    -- Descontar saldo cuenta origen
    UPDATE cuentas
    SET saldo = saldo - p_monto
    WHERE numero_cuenta = p_cuenta_origen;

    -- Aumentar saldo cuenta destino
    UPDATE cuentas
    SET saldo = saldo + p_monto
    WHERE numero_cuenta = p_cuenta_destino;

    -- Registrar transacción
    INSERT INTO transacciones (
        id_empleado,
        numero_cuenta_origen,
        numero_cuenta_destino,
        id_tipo_transaccion,
        monto,
        descripcion,
        estado
    )
    VALUES (
        p_id_empleado,
        p_cuenta_origen,
        p_cuenta_destino,
        3, -- Transferencia
        p_monto,
        'Transferencia entre cuentas',
        'Exitosa'
    );
END;
$$;

CALL sp_realizar_transferencia(10000001, 10000002, 200000, 1);
SELECT * FROM transacciones;

-- c) `sp_aprobar_prestamo`: Procedimiento que aprueba un 
-- préstamo y actualiza su estado
CREATE OR REPLACE PROCEDURE sp_aprobar_prestamo(
    p_id_prestamo     INTEGER,
    p_monto_aprobado  NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE prestamos
    SET monto_aprobado   = p_monto_aprobado,
        estado           = 'Aprobado',
        fecha_aprobacion = CURRENT_DATE
    WHERE id_prestamo = p_id_prestamo AND estado = 'Pendiente';
END;
$$;

CALL sp_aprobar_prestamo(3, 8000000);
SELECT * FROM prestamos;