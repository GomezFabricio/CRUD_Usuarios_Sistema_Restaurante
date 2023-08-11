CREATE TABLE proveedores (
  idProveedor INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  nombreProveedor VARCHAR(50)  NULL  ,
  direccion VARCHAR(80)  NULL  ,
  telefono INTEGER UNSIGNED  NULL  ,
  sitioWeb VARCHAR(100)  NULL  ,
  servicios TEXT  NULL    ,
PRIMARY KEY(idProveedor));



CREATE TABLE recetas (
  idReceta INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  descripcionReceta TEXT  NULL    ,
PRIMARY KEY(idReceta));



CREATE TABLE tipo_Mesa (
  idTipoMesa INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  tamanio VARCHAR(50)  NULL  ,
  capacidad INTEGER UNSIGNED  NULL    ,
PRIMARY KEY(idTipoMesa));



CREATE TABLE personas (
  idPersona INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  dni INTEGER UNSIGNED  NULL  ,
  nombre VARCHAR(50)  NULL  ,
  apellido VARCHAR(50)  NULL  ,
  telefono INTEGER UNSIGNED  NULL    ,
PRIMARY KEY(idPersona));



CREATE TABLE restaurante (
  idRestaurante INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  nombreRestaurante VARCHAR(50)  NULL  ,
  direccionLocal VARCHAR(50)  NULL  ,
  telefonoLocal INTEGER UNSIGNED  NULL    ,
PRIMARY KEY(idRestaurante));



CREATE TABLE tipo_menu (
  idTipoMenu INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  nombreTipoMenu VARCHAR(50)  NULL    ,
PRIMARY KEY(idTipoMenu));



CREATE TABLE bebidas (
  idBebida INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  nombreBebida VARCHAR(20)  NULL  ,
  precioBebida DECIMAL(9,2)  NULL    ,
PRIMARY KEY(idBebida));



CREATE TABLE tipo_factura (
  idTipo_factura INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  nombreTipoFactura VARCHAR(20)  NULL    ,
PRIMARY KEY(idTipo_factura));



CREATE TABLE roles (
  idRol INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  rol VARCHAR(20)  NULL    ,
PRIMARY KEY(idRol));



CREATE TABLE remitos (
  idRemito INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  idProveedor INTEGER UNSIGNED  NOT NULL  ,
  fechaRemito DATE  NULL  ,
  totalRemito DECIMAL(9,2)  NULL  ,
  fotoRemito BLOB  NULL    ,
PRIMARY KEY(idRemito)  ,
INDEX remitos_FKIndex1(idProveedor),
  FOREIGN KEY(idProveedor)
    REFERENCES proveedores(idProveedor)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION);



CREATE TABLE mesa (
  idMesa INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  idTipoMesa INTEGER UNSIGNED  NOT NULL  ,
  numeroMesa INTEGER UNSIGNED  NULL    ,
PRIMARY KEY(idMesa)  ,
INDEX mesa_FKIndex1(idTipoMesa),
  FOREIGN KEY(idTipoMesa)
    REFERENCES tipo_Mesa(idTipoMesa)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION);



CREATE TABLE clientes (
  idCliente INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  idPersona INTEGER UNSIGNED  NOT NULL  ,
  fechaRegistro DATE  NULL  ,
  preferencias VARCHAR(100)  NULL  ,
  condicionesEspeciales VARCHAR(100)  NULL    ,
PRIMARY KEY(idCliente)  ,
INDEX clientes_FKIndex1(idPersona),
  FOREIGN KEY(idPersona)
    REFERENCES personas(idPersona)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION);



CREATE TABLE comidas (
  idComida INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  idReceta INTEGER UNSIGNED  NOT NULL  ,
  nombreComida VARCHAR(20)  NULL  ,
  precioComida DECIMAL(9,2)  NULL    ,
PRIMARY KEY(idComida)  ,
INDEX comidas_FKIndex1(idReceta),
  FOREIGN KEY(idReceta)
    REFERENCES recetas(idReceta)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION);



CREATE TABLE menu (
  idMenu INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  idTipoMenu INTEGER UNSIGNED  NOT NULL  ,
  nombreMenu VARCHAR(40)  NULL  ,
  descripcionMenu TEXT  NULL  ,
  precio DECIMAL(9,2)  NULL    ,
PRIMARY KEY(idMenu)  ,
INDEX menus_FKIndex1(idTipoMenu),
  FOREIGN KEY(idTipoMenu)
    REFERENCES tipo_menu(idTipoMenu)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION);



CREATE TABLE inventario (
  idInventario INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  idProveedor INTEGER UNSIGNED  NOT NULL  ,
  nombreInsumo VARCHAR(100)  NULL  ,
  stockActual DECIMAL(10,2)  NULL  ,
  stockMinimo DECIMAL(10,2)  NULL    ,
PRIMARY KEY(idInventario)  ,
INDEX inventario_FKIndex1(idProveedor),
  FOREIGN KEY(idProveedor)
    REFERENCES proveedores(idProveedor)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION);



CREATE TABLE usuarios (
  idUsuario INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  idRol INTEGER UNSIGNED  NOT NULL  ,
  idPersona INTEGER UNSIGNED  NOT NULL  ,
  usuario VARCHAR(50)  NULL  ,
  pass VARCHAR(50)  NULL    ,
PRIMARY KEY(idUsuario)  ,
INDEX Usuarios_FKIndex1(idPersona)  ,
INDEX Usuarios_FKIndex2(idRol),
  FOREIGN KEY(idPersona)
    REFERENCES personas(idPersona)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(idRol)
    REFERENCES roles(idRol)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION);



CREATE TABLE ingredientes_recetas (
  idIngredientesRecetas INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  idReceta INTEGER UNSIGNED  NOT NULL  ,
  idInventario INTEGER UNSIGNED  NOT NULL  ,
  cantidad DECIMAL(10,2)  NULL    ,
PRIMARY KEY(idIngredientesRecetas)  ,
INDEX ingredientes_recetas_FKIndex1(idInventario)  ,
INDEX ingredientes_recetas_FKIndex2(idReceta),
  FOREIGN KEY(idInventario)
    REFERENCES inventario(idInventario)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(idReceta)
    REFERENCES recetas(idReceta)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION);



CREATE TABLE pedidos_proveedores (
  idPedidos_proveedores INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  idTipo_factura INTEGER UNSIGNED  NOT NULL  ,
  idProveedor INTEGER UNSIGNED  NOT NULL  ,
  fechaProveedor DATE  NULL  ,
  total DECIMAL(9,2)  NULL    ,
PRIMARY KEY(idPedidos_proveedores)  ,
INDEX pedidos_proveedores_FKIndex1(idProveedor)  ,
INDEX pedidos_proveedores_FKIndex2(idTipo_factura),
  FOREIGN KEY(idProveedor)
    REFERENCES proveedores(idProveedor)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(idTipo_factura)
    REFERENCES tipo_factura(idTipo_factura)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION);



CREATE TABLE reservas (
  idReserva INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  idCliente INTEGER UNSIGNED  NOT NULL  ,
  idMesa INTEGER UNSIGNED  NOT NULL  ,
  fechaYHora DATETIME  NULL    ,
PRIMARY KEY(idReserva)  ,
INDEX reservas_FKIndex1(idMesa)  ,
INDEX reservas_FKIndex2(idCliente),
  FOREIGN KEY(idMesa)
    REFERENCES mesa(idMesa)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(idCliente)
    REFERENCES clientes(idCliente)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION);



CREATE TABLE carta_menu (
  idCartaMenu INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  idMenu INTEGER UNSIGNED  NOT NULL  ,
  idComida INTEGER UNSIGNED  NOT NULL  ,
  idBebida INTEGER UNSIGNED  NOT NULL    ,
PRIMARY KEY(idCartaMenu)  ,
INDEX carta_menu_FKIndex1(idBebida)  ,
INDEX carta_menu_FKIndex2(idComida)  ,
INDEX carta_menu_FKIndex3(idMenu),
  FOREIGN KEY(idBebida)
    REFERENCES bebidas(idBebida)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(idComida)
    REFERENCES comidas(idComida)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(idMenu)
    REFERENCES menu(idMenu)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION);



CREATE TABLE pedidos_clientes (
  idPedido INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  idTipo_factura INTEGER UNSIGNED  NOT NULL  ,
  idRestaurante INTEGER UNSIGNED  NOT NULL  ,
  idCliente INTEGER UNSIGNED  NOT NULL  ,
  fecha DATE  NULL  ,
  total DECIMAL(9,2)  NULL    ,
PRIMARY KEY(idPedido)  ,
INDEX pedidos_FKIndex1(idRestaurante)  ,
INDEX pedidos_FKIndex2(idCliente)  ,
INDEX pedidos_FKIndex4(idTipo_factura),
  FOREIGN KEY(idRestaurante)
    REFERENCES restaurante(idRestaurante)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(idCliente)
    REFERENCES clientes(idCliente)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(idTipo_factura)
    REFERENCES tipo_factura(idTipo_factura)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION);



CREATE TABLE faltantes (
  idFaltante INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  idInventario INTEGER UNSIGNED  NOT NULL  ,
  cantidad DECIMAL(9,2)  NULL    ,
PRIMARY KEY(idFaltante)  ,
INDEX faltantes_FKIndex1(idInventario),
  FOREIGN KEY(idInventario)
    REFERENCES inventario(idInventario)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION);



CREATE TABLE detalle_pedidos_clientes (
  idDetalle_pedidos_clientes INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  idPedido_clientes INTEGER UNSIGNED  NOT NULL  ,
  idCartaMenu INTEGER UNSIGNED  NOT NULL  ,
  subTotal DECIMAL(9,2)  NULL    ,
PRIMARY KEY(idDetalle_pedidos_clientes)  ,
INDEX detalle_pedidos_FKIndex1(idCartaMenu)  ,
INDEX detalle_pedidos_FKIndex2(idPedido_clientes),
  FOREIGN KEY(idCartaMenu)
    REFERENCES carta_menu(idCartaMenu)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(idPedido_clientes)
    REFERENCES pedidos_clientes(idPedido)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION);



CREATE TABLE detalle_pedidos_proveedores (
  idDetalle_pedidos_proveedores INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  idPedidos_proveedores INTEGER UNSIGNED  NOT NULL  ,
  idFaltante INTEGER UNSIGNED  NOT NULL  ,
  subTotal DECIMAL(9,2)  NULL    ,
PRIMARY KEY(idDetalle_pedidos_proveedores)  ,
INDEX detalle_pedidos_proveedores_FKIndex1(idFaltante)  ,
INDEX detalle_pedidos_proveedores_FKIndex2(idPedidos_proveedores),
  FOREIGN KEY(idFaltante)
    REFERENCES faltantes(idFaltante)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(idPedidos_proveedores)
    REFERENCES pedidos_proveedores(idPedidos_proveedores)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION);




