DELIMITER //

CREATE PROCEDURE buscarPublicacion(IN producto_nombre VARCHAR(255))
BEGIN
    SELECT p.publicacion_id, pr.nombre_producto, c.nombre_categoria, p.precio
    FROM Publicaciones p
    JOIN Productos pr ON p.producto_id = pr.producto_id
    JOIN Categorias c ON p.categoria_id = c.categoria_id
    WHERE pr.nombre_producto LIKE CONCAT('%', producto_nombre, '%');
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE crearPublicacion(
    IN producto_id INT,
    IN categoria_id INT,
    IN usuario_id INT,
    IN tipo_publicacion ENUM('BRONCE', 'PLATA', 'ORO', 'PLATINO'),
    IN tipo_venta ENUM('DIRECTA', 'SUBASTA'),
    IN precio DECIMAL(10, 2)
)
BEGIN
    INSERT INTO Publicaciones (producto_id, categoria_id, usuario_id, tipo_publicacion, tipo_venta, precio, estado)
    VALUES (producto_id, categoria_id, usuario_id, tipo_publicacion, tipo_venta, precio, 'ACTIVA');
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE verPreguntas(IN publicacion_id INT)
BEGIN
    SELECT pregunta_id, pregunta, respuesta, estado
    FROM PreguntasRespuestas
    WHERE publicacion_id = publicacion_id;
END //

DELIMITER ;

-- ----------------------------------------------------- -- 

DELIMITER //

CREATE FUNCTION comprarProducto(
    comprador_id INT,
    publicacion_id INT,
    medio_pago_id INT,
    medio_envio_id INT
) RETURNS VARCHAR(255)
BEGIN
    DECLARE mensaje VARCHAR(255);
    DECLARE tipo_venta ENUM('DIRECTA', 'SUBASTA');
    
    SELECT estado, tipo_venta INTO tipo_venta
    FROM Publicaciones
    WHERE publicacion_id = publicacion_id;
    
    IF tipo_venta = 'SUBASTA' THEN
        SET mensaje = 'Es una subasta';
    ELSE
        UPDATE Publicaciones
        SET estado = 'FINALIZADA'
        WHERE publicacion_id = publicacion_id AND estado = 'ACTIVA';
        
        -- Aquí puedes realizar los inserts correspondientes para la transacción de compra
        
        SET mensaje = 'Compra realizada con éxito';
    END IF;
    
    RETURN mensaje;
END //

DELIMITER ;

DELIMITER //

CREATE FUNCTION cerrarPublicacion(
    publicacion_id INT,
    vendedor_id INT
) RETURNS VARCHAR(255)
BEGIN
    DECLARE mensaje VARCHAR(255);
    
    SELECT estado, usuario_id INTO mensaje
    FROM Publicaciones
    WHERE publicacion_id = publicacion_id;
    
    IF mensaje = 'ACTIVA' THEN
        SELECT usuario_id INTO mensaje
        FROM Publicaciones
        WHERE publicacion_id = publicacion_id AND usuario_id = vendedor_id;
        
        IF mensaje = vendedor_id THEN
            -- Verificar si no hay calificaciones pendientes
            
            UPDATE Publicaciones
            SET estado = 'FINALIZADA'
            WHERE publicacion_id = publicacion_id;
            
            SET mensaje = 'Publicación cerrada con éxito';
        ELSE
            SET mensaje = 'Usuario no autorizado para cerrar la publicación';
        END IF;
    ELSE
        SET mensaje = 'La publicación no está activa';
    END IF;
    
    RETURN mensaje;
END //

DELIMITER ;

DELIMITER //

CREATE FUNCTION eliminarProducto(
    producto_id INT
) RETURNS VARCHAR(255)
BEGIN
    DECLARE mensaje VARCHAR(255);
    
    SELECT COUNT(*) INTO mensaje
    FROM Publicaciones
    WHERE producto_id = producto_id;
    
    IF mensaje > 0 THEN
        SET mensaje = 'El producto está asociado a una publicación';
    ELSE
        DELETE FROM Productos
        WHERE producto_id = producto_id;
        
        SET mensaje = 'Producto eliminado con éxito';
    END IF;
    
    RETURN mensaje;
END //

DELIMITER ;

DELIMITER //

CREATE FUNCTION pujarProducto(
    usuario_id INT,
    publicacion_id INT,
    monto_puja DECIMAL(10, 2)
) RETURNS VARCHAR(255)
BEGIN
    DECLARE mensaje VARCHAR(255);
    DECLARE tipo_venta ENUM('DIRECTA', 'SUBASTA');
    
    SELECT estado, tipo_venta INTO tipo_venta
    FROM Publicaciones
    WHERE publicacion_id = publicacion_id;
    
    IF tipo_venta = 'SUBASTA' THEN
        UPDATE Publicaciones
        SET precio = monto_puja
        WHERE publicacion_id = publicacion_id AND estado = 'ACTIVA';
        
        SET mensaje = 'Puja realizada con éxito';
    ELSE
        SET mensaje = 'No es una subasta';
    END IF;
    
    RETURN mensaje;
END //

DELIMITER ;

DELIMITER //

CREATE FUNCTION pujarProducto(
    usuario_id INT,
    publicacion_id INT,
    monto_puja DECIMAL(10, 2)
) RETURNS VARCHAR(255)
BEGIN
    DECLARE mensaje VARCHAR(255);
    DECLARE tipo_venta ENUM('DIRECTA', 'SUBASTA');
    
    SELECT estado, tipo_venta INTO tipo_venta
    FROM Publicaciones
    WHERE publicacion_id = publicacion_id;
    
    IF tipo_venta = 'SUBASTA' THEN
        UPDATE Publicaciones
        SET precio = monto_puja
        WHERE publicacion_id = publicacion_id AND estado = 'ACTIVA';
        
        SET mensaje = 'Puja realizada con éxito';
    ELSE
        SET mensaje = 'No es una subasta';
    END IF;
    
    RETURN mensaje;
END //

DELIMITER ;

DELIMITER //

CREATE FUNCTION eliminarCategoria(categoria_id INT) RETURNS VARCHAR(255)
BEGIN
    DECLARE mensaje VARCHAR(255);
    
    SELECT COUNT(*) INTO mensaje
    FROM Publicaciones
    WHERE categoria_id = categoria_id;
    
    IF mensaje > 0 THEN
        SET mensaje = 'No se puede eliminar la categoría, tiene publicaciones asociadas';
    ELSE
        DELETE FROM Categorias
        WHERE categoria_id = categoria_id;
        
        SET mensaje = 'Categoría eliminada con éxito';
    END IF;
    
    RETURN mensaje;
END //

DELIMITER ;

DELIMITER //

CREATE FUNCTION puntuarComprador(
    venta_id INT,
    vendedor_id INT,
    comprador_id INT,
    calificacion DECIMAL(5, 2)
) RETURNS VARCHAR(255)
BEGIN
    DECLARE mensaje VARCHAR(255);
    
    SELECT usuario_id INTO mensaje
    FROM Publicaciones
    WHERE publicacion_id = venta_id;
    
    IF mensaje = vendedor_id THEN
        -- Verificar si la venta existe
        
        -- Actualizar calificación del comprador
        
        SET mensaje = 'Comprador calificado con éxito';
    ELSE
        SET mensaje = 'Usuario no autorizado para calificar al comprador';
    END IF;
    
    RETURN mensaje;
END //

DELIMITER ;

DELIMITER //

CREATE FUNCTION responderPregunta(
    publicacion_id INT,
    vendedor_id INT,
    pregunta_id INT,
    respuesta TEXT
) RETURNS VARCHAR(255)
BEGIN
    DECLARE mensaje VARCHAR(255);
    
    SELECT usuario_id INTO mensaje
    FROM Publicaciones
    WHERE publicacion_id = publicacion_id;
    
    IF mensaje = vendedor_id THEN
        UPDATE PreguntasRespuestas
        SET respuesta = respuesta
        WHERE pregunta_id = pregunta_id;
        
        SET mensaje = 'Respuesta agregada con éxito';
    ELSE
        SET mensaje = 'Solo el vendedor puede responder';
    END IF;
    
    RETURN mensaje;
END //

DELIMITER ;

-- --------------------------------------------------------- --

DELIMITER //

CREATE TRIGGER borrarPreguntas BEFORE DELETE ON Publicaciones
FOR EACH ROW
BEGIN
    DELETE FROM PreguntasRespuestas WHERE publicacion_id = OLD.publicacion_id;
END //

DELIMITER ;

DELIMITER //

DELIMITER //

CREATE TRIGGER Calificar AFTER UPDATE ON Ventas
FOR EACH ROW
BEGIN
    IF NEW.calificacion_vendedor IS NOT NULL AND NEW.calificacion_comprador IS NOT NULL THEN
        -- Actualiza la calificación del vendedor y del comprador
        -- Puedes definir la lógica de cálculo de calificaciones aquí
        -- UPDATE Usuarios SET reputacion = ... WHERE usuario_id = ...
    END IF;
END; 

DELIMITER ;

DELIMITER //

CREATE TRIGGER cambiarCategoria AFTER INSERT ON Ventas
FOR EACH ROW
BEGIN
    -- Actualiza la categoría de usuario según la lógica que necesites
    -- UPDATE Usuarios SET nivel_usuario = ... WHERE usuario_id = ...
END //

DELIMITER ;



