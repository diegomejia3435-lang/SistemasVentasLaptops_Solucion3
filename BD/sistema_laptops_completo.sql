
-- TABLA USUARIOS
CREATE TABLE usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    correo VARCHAR(100) UNIQUE,
    password VARCHAR(100),
    rol VARCHAR(20) CHECK (rol IN ('Administrador','Empleado'))
);

-- TABLA PRODUCTOS
CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(150),
    marca VARCHAR(50),
    categoria VARCHAR(50),
    precio NUMERIC(10,2),
    stock INTEGER
);

-- TABLA VENTAS
CREATE TABLE ventas (
    id_venta SERIAL PRIMARY KEY,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total NUMERIC(10,2),
    id_usuario INTEGER,
    CONSTRAINT fk_ventas_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario)
);

-- TABLA DETALLE_VENTAS
CREATE TABLE detalle_ventas (
    id_detalle SERIAL PRIMARY KEY,
    id_venta INTEGER,
    id_producto INTEGER,
    cantidad INTEGER,
    precio_unitario NUMERIC(10,2),
    CONSTRAINT fk_detalle_venta
        FOREIGN KEY (id_venta)
        REFERENCES ventas(id_venta),
    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (id_producto)
        REFERENCES productos(id_producto)
);

-- DATOS DE USUARIOS
INSERT INTO usuarios (id_usuario, nombre, correo, password, rol)
VALUES
(1, 'Admin Tech', 'admin@tech.com', 'admin123', 'Administrador');

-- DATOS DE PRODUCTOS
INSERT INTO productos
(id_producto, nombre, marca, categoria, precio, stock)
VALUES
(1,'Laptop ZenBook 14','ASUS','Laptop',3500.00,9),
(3,'Laptop VivoBook 15','ASUS','Laptop',2800.00,12),
(4,'Laptop IdeaPad Slim 5','Lenovo','Laptop',2600.00,8),
(5,'Laptop ThinkPad E14','Lenovo','Laptop',4200.00,5),
(6,'Laptop Pavilion 15','HP','Laptop',2400.00,15),
(7,'Laptop Envy x360','HP','Laptop',4800.00,4),
(8,'Laptop MacBook Air M2','Apple','Laptop',7500.00,6),
(9,'Laptop MacBook Pro 14','Apple','Laptop',9800.00,3),
(10,'Laptop Inspiron 15','Dell','Laptop',2900.00,10),
(11,'Laptop XPS 13','Dell','Laptop',5600.00,4),
(12,'Laptop Gram 14','LG','Laptop',5100.00,7),
(13,'Laptop Swift 3','Acer','Laptop',2200.00,18),
(14,'Laptop Predator Helios 300','Acer','Gaming',6300.00,5),
(15,'Laptop ROG Strix G15','ASUS','Gaming',6800.00,4),
(16,'Laptop Legion 5 Pro','Lenovo','Gaming',7200.00,3),
(17,'Laptop OMEN 16','HP','Gaming',6500.00,6),
(18,'Laptop Surface Pro 9','Microsoft','2 en 1',6900.00,4),
(19,'Laptop Yoga 7i','Lenovo','2 en 1',4400.00,7),
(20,'Laptop Chromebook Spin 714','Acer','Chromebook',1800.00,9),
(21,'Mini PC NUC 13 Pro','Intel','Mini PC',3100.00,6),
(22,'Laptop EliteBook 840','HP','Empresarial',5300.00,5);

-- DATOS DE VENTAS
INSERT INTO ventas
(id_venta, fecha, total, id_usuario)
VALUES
(1,'2026-04-30 13:19:02.22357',3500.00,1);

-- DATOS DE DETALLE_VENTAS
INSERT INTO detalle_ventas
(id_detalle, id_venta, id_producto, cantidad, precio_unitario)
VALUES
(1,1,1,1,3500.00);

-- ACTUALIZAR SECUENCIAS
SELECT setval('usuarios_id_usuario_seq',
              (SELECT MAX(id_usuario) FROM usuarios));

SELECT setval('productos_id_producto_seq',
              (SELECT MAX(id_producto) FROM productos));

SELECT setval('ventas_id_venta_seq',
              (SELECT MAX(id_venta) FROM ventas));

SELECT setval('detalle_ventas_id_detalle_seq',
              (SELECT MAX(id_detalle) FROM detalle_ventas));
			  
SELECT * FROM usuarios;
