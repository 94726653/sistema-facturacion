-- phpMyAdmin SQL Dump
-- version 3.4.10.1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 20-03-2026 a las 00:41:05
-- Versión del servidor: 5.5.20
-- Versión de PHP: 5.3.10

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `sistema_maiyas`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE IF NOT EXISTS `clientes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `creado_por` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=13 ;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id`, `nombre`, `telefono`, `correo`, `fecha_registro`, `creado_por`) VALUES
(1, 'Karol', '94726653', 'karolinamorales12@gmail.com', '2026-03-04 23:00:00', NULL),
(5, 'Glenda', '3344455', 'Glenda12@gmail.com', '2026-03-04 23:00:00', 'admin'),
(6, 'Eduar ', '557788', 'eduar12@gmail.com', '2026-03-04 23:00:00', 'Glenda'),
(8, 'Cristhian Cruz', '674746366', 'Cristhian34@gmail.com', '2026-03-05 23:00:00', 'Javier Medina '),
(10, 'Clementino Lopez', '947636', 'Clemen3@gmail.com', '2026-03-08 23:00:00', 'Javier Medina ');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_venta`
--

CREATE TABLE IF NOT EXISTS `detalle_venta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `venta_id` int(11) DEFAULT NULL,
  `producto_id` int(11) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `precio` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=85 ;

--
-- Volcado de datos para la tabla `detalle_venta`
--

INSERT INTO `detalle_venta` (`id`, `venta_id`, `producto_id`, `cantidad`, `precio`) VALUES
(71, 52, 2, 2, 5),
(72, 52, 4, 4, 5),
(73, 53, 3, 1, 5),
(74, 53, 3, 2, 5),
(75, 54, 3, 1, 5),
(76, 54, 3, 1, 5),
(77, 55, 5, 1, 5),
(78, 55, 4, 2, 5),
(79, 56, 2, 2, 5),
(80, 57, 4, 1, 5),
(81, 57, 3, 1, 5),
(82, 58, 8, 3, 10),
(83, 58, 2, 2, 5),
(84, 59, 2, 2, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE IF NOT EXISTS `productos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT '',
  `precio` double DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `stock_minimo` int(11) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `nombre`, `descripcion`, `precio`, `cantidad`, `stock_minimo`) VALUES
(2, 'Lapizz', 'Azul', 5, 93, 1),
(3, 'Lapiz', 'Rojo', 5, 2, 1),
(4, 'Lapiz', 'Rosado', 5, 30, 1),
(5, 'Lapiz', 'Morado', 5, 7, 3),
(7, 'Lapiz', 'Carbon', 20, 10, 10),
(8, 'libro', 'negro', 10, 21, 10),
(10, 'libro', 'azul', 10, 36, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos_proveedores`
--

CREATE TABLE IF NOT EXISTS `productos_proveedores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `proveedor_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `proveedor_id` (`proveedor_id`),
  KEY `producto_id` (`producto_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=116 ;

--
-- Volcado de datos para la tabla `productos_proveedores`
--

INSERT INTO `productos_proveedores` (`id`, `proveedor_id`, `producto_id`) VALUES
(38, 21, 3),
(39, 21, 7),
(63, 30, 2),
(64, 30, 4),
(65, 30, 7),
(93, 40, 2),
(94, 40, 5),
(99, 43, 2),
(100, 43, 3),
(101, 43, 4),
(102, 43, 5),
(104, 43, 7),
(111, 45, 2),
(112, 45, 5),
(113, 45, 8),
(114, 19, 5),
(115, 19, 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE IF NOT EXISTS `proveedores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `productos_suministrados` text,
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `creado_por` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=46 ;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`id`, `nombre`, `telefono`, `correo`, `direccion`, `productos_suministrados`, `fecha_registro`, `creado_por`) VALUES
(19, 'Eduar Carcamo', '456678', 'edu4@gmail.com', 'Erandique', 'Lapiz (Morado), Lapiz (Carbon)', '2026-03-15 01:16:50', 'Javier Medina '),
(21, 'Cristhian Cruz', '4566', 'cris3@gmail.com', 'Erandique', 'Lapiz (Rojo), Lapiz (Carbon)', '2026-03-15 01:30:41', 'Javier Medina '),
(30, 'Glenda Quintanilla', '345677', 'glenda6@gmail.com', 'Gracias Lempira', 'Lapiz (Azul), Lapiz (Rosado), Lapiz (Carbon)', '2026-03-15 01:59:19', 'Javier Medina '),
(40, 'Karolina Morales', '4555', 'karol3@gmail.com', 'Erandique', 'Lapiz (Azul), Lapiz (Morado)', '2026-03-16 22:03:19', 'Eduar Carcamo '),
(43, 'Jaimito Rodrigues ', '123456', 'jaimi3@gmail.com', 'B centro ,Erandique', 'Lapiz (Azul), Lapiz (Rojo), Lapiz (Rosado), Lapiz (Morado), Libro (Azul), Lapiz (Carbon)', '2026-03-18 02:42:52', 'Javier Medina '),
(45, 'Silvia', '6474848', 'silvia2@gail.com', 'Santa Rosa', 'Lapizz (Azul), Lapiz (Morado), libro (negro)', '2026-03-20 00:26:35', 'Javier Medina ');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `reporte_inventario`
--
CREATE TABLE IF NOT EXISTS `reporte_inventario` (
`id` int(11)
,`nombre` varchar(100)
,`descripcion` varchar(255)
,`precio` double
,`cantidad` int(11)
);
-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `reporte_productos_mas_vendidos`
--
CREATE TABLE IF NOT EXISTS `reporte_productos_mas_vendidos` (
`id` int(11)
,`nombre` varchar(100)
,`descripcion` varchar(255)
,`total_vendido` decimal(32,0)
);
-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `reporte_ventas`
--
CREATE TABLE IF NOT EXISTS `reporte_ventas` (
`id` int(11)
,`fecha` datetime
,`usuario` varchar(50)
,`cliente` varchar(100)
,`producto` varchar(100)
,`descripcion` varchar(255)
,`cantidad` int(11)
,`precio` double
,`subtotal` double
);
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE IF NOT EXISTS `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `rol` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario` (`usuario`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=20 ;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `usuario`, `password`, `rol`) VALUES
(4, 'Javier Medina ', '123', 'ADMIN'),
(7, 'Cristhian Cruz', '1234', 'EMPLEADO'),
(13, 'Glenda Quintanilla', '1234567', 'EMPLEADO'),
(16, 'Eduar Carcamo ', 'Gatito2212', 'ADMIN'),
(17, 'Karolina Morales', '12', 'EMPLEADO'),
(19, 'Silvia', '1234rr', 'EMPLEADO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE IF NOT EXISTS `ventas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fecha` datetime DEFAULT NULL,
  `total` double DEFAULT NULL,
  `usuario` varchar(50) DEFAULT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  `numero_factura` varchar(20) DEFAULT NULL,
  `subtotal` double DEFAULT NULL,
  `impuesto` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `numero_factura` (`numero_factura`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=60 ;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`id`, `fecha`, `total`, `usuario`, `cliente_id`, `numero_factura`, `subtotal`, `impuesto`) VALUES
(52, '2026-03-12 02:06:10', 34.5, 'Javier Medina ', 1, 'FAC-1773277570655', 30, 4.5),
(53, '2026-03-14 23:10:05', 17.25, 'Javier Medina ', 10, 'FAC-1773526205213', 15, 2.25),
(54, '2026-03-14 23:19:49', 11.5, 'Javier Medina ', 8, 'FAC-1773526789383', 10, 1.5),
(55, '2026-03-15 01:13:06', 17.25, 'Javier Medina ', 1, 'FAC-1773533586218', 15, 2.25),
(56, '2026-03-15 01:14:49', 11.5, 'Javier Medina ', 8, 'FAC-1773533689631', 10, 1.5),
(57, '2026-03-18 03:44:34', 11.5, 'Javier Medina ', 8, 'FAC-1773801874062', 10, 1.5),
(58, '2026-03-19 23:42:26', 46, 'Cristhian Cruz', 10, 'FAC-1773960146898', 40, 6),
(59, '2026-03-20 01:28:21', 11.5, 'Javier Medina ', 8, 'FAC-1773966501439', 10, 1.5);

-- --------------------------------------------------------

--
-- Estructura para la vista `reporte_inventario`
--
DROP TABLE IF EXISTS `reporte_inventario`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `reporte_inventario` AS select `productos`.`id` AS `id`,`productos`.`nombre` AS `nombre`,`productos`.`descripcion` AS `descripcion`,`productos`.`precio` AS `precio`,`productos`.`cantidad` AS `cantidad` from `productos`;

-- --------------------------------------------------------

--
-- Estructura para la vista `reporte_productos_mas_vendidos`
--
DROP TABLE IF EXISTS `reporte_productos_mas_vendidos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `reporte_productos_mas_vendidos` AS select `p`.`id` AS `id`,`p`.`nombre` AS `nombre`,`p`.`descripcion` AS `descripcion`,sum(`dv`.`cantidad`) AS `total_vendido` from (`detalle_venta` `dv` join `productos` `p` on((`dv`.`producto_id` = `p`.`id`))) group by `p`.`id`,`p`.`nombre`,`p`.`descripcion` order by sum(`dv`.`cantidad`) desc;

-- --------------------------------------------------------

--
-- Estructura para la vista `reporte_ventas`
--
DROP TABLE IF EXISTS `reporte_ventas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `reporte_ventas` AS select `v`.`id` AS `id`,`v`.`fecha` AS `fecha`,`v`.`usuario` AS `usuario`,`c`.`nombre` AS `cliente`,`p`.`nombre` AS `producto`,`p`.`descripcion` AS `descripcion`,`dv`.`cantidad` AS `cantidad`,`dv`.`precio` AS `precio`,(`dv`.`cantidad` * `dv`.`precio`) AS `subtotal` from (((`ventas` `v` left join `clientes` `c` on((`v`.`cliente_id` = `c`.`id`))) join `detalle_venta` `dv` on((`v`.`id` = `dv`.`venta_id`))) join `productos` `p` on((`dv`.`producto_id` = `p`.`id`)));

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `productos_proveedores`
--
ALTER TABLE `productos_proveedores`
  ADD CONSTRAINT `productos_proveedores_ibfk_1` FOREIGN KEY (`proveedor_id`) REFERENCES `proveedores` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `productos_proveedores_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
