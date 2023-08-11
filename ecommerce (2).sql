-- MySQL dump 10.13  Distrib 8.0.33, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: ecommerce
-- ------------------------------------------------------
-- Server version	8.0.33-0ubuntu0.22.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Categorias`
--

DROP TABLE IF EXISTS `Categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Categorias` (
  `categoria_id` int NOT NULL AUTO_INCREMENT,
  `nombre_categoria` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`categoria_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Categorias`
--

LOCK TABLES `Categorias` WRITE;
/*!40000 ALTER TABLE `Categorias` DISABLE KEYS */;
/*!40000 ALTER TABLE `Categorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MediosEnvios`
--

DROP TABLE IF EXISTS `MediosEnvios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MediosEnvios` (
  `envio_id` int NOT NULL AUTO_INCREMENT,
  `nombre_medio_envio` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`envio_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MediosEnvios`
--

LOCK TABLES `MediosEnvios` WRITE;
/*!40000 ALTER TABLE `MediosEnvios` DISABLE KEYS */;
/*!40000 ALTER TABLE `MediosEnvios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MediosPagos`
--

DROP TABLE IF EXISTS `MediosPagos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MediosPagos` (
  `pago_id` int NOT NULL AUTO_INCREMENT,
  `nombre_medio_pago` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`pago_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MediosPagos`
--

LOCK TABLES `MediosPagos` WRITE;
/*!40000 ALTER TABLE `MediosPagos` DISABLE KEYS */;
/*!40000 ALTER TABLE `MediosPagos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PreguntasRespuestas`
--

DROP TABLE IF EXISTS `PreguntasRespuestas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PreguntasRespuestas` (
  `pregunta_id` int NOT NULL AUTO_INCREMENT,
  `publicacion_id` int DEFAULT NULL,
  `usuario_id` int DEFAULT NULL,
  `pregunta` text,
  `respuesta` text,
  `estado` enum('ACTIVA','INHABILITADA') DEFAULT NULL,
  PRIMARY KEY (`pregunta_id`),
  KEY `publicacion_id` (`publicacion_id`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `PreguntasRespuestas_ibfk_1` FOREIGN KEY (`publicacion_id`) REFERENCES `Publicaciones` (`publicacion_id`),
  CONSTRAINT `PreguntasRespuestas_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `Usuarios` (`usuario_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PreguntasRespuestas`
--

LOCK TABLES `PreguntasRespuestas` WRITE;
/*!40000 ALTER TABLE `PreguntasRespuestas` DISABLE KEYS */;
/*!40000 ALTER TABLE `PreguntasRespuestas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Productos`
--

DROP TABLE IF EXISTS `Productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Productos` (
  `producto_id` int NOT NULL AUTO_INCREMENT,
  `nombre_producto` varchar(255) DEFAULT NULL,
  `descripcion` text,
  PRIMARY KEY (`producto_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Productos`
--

LOCK TABLES `Productos` WRITE;
/*!40000 ALTER TABLE `Productos` DISABLE KEYS */;
/*!40000 ALTER TABLE `Productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Publicaciones`
--

DROP TABLE IF EXISTS `Publicaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Publicaciones` (
  `publicacion_id` int NOT NULL AUTO_INCREMENT,
  `producto_id` int DEFAULT NULL,
  `categoria_id` int DEFAULT NULL,
  `usuario_id` int DEFAULT NULL,
  `tipo_publicacion` enum('BRONCE','PLATA','ORO','PLATINO') DEFAULT NULL,
  `tipo_venta` enum('DIRECTA','SUBASTA') DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `estado` enum('ACTIVA','FINALIZADA') DEFAULT NULL,
  PRIMARY KEY (`publicacion_id`),
  KEY `producto_id` (`producto_id`),
  KEY `categoria_id` (`categoria_id`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `Publicaciones_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `Productos` (`producto_id`),
  CONSTRAINT `Publicaciones_ibfk_2` FOREIGN KEY (`categoria_id`) REFERENCES `Categorias` (`categoria_id`),
  CONSTRAINT `Publicaciones_ibfk_3` FOREIGN KEY (`usuario_id`) REFERENCES `Usuarios` (`usuario_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Publicaciones`
--

LOCK TABLES `Publicaciones` WRITE;
/*!40000 ALTER TABLE `Publicaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `Publicaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Usuarios`
--

DROP TABLE IF EXISTS `Usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Usuarios` (
  `usuario_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) DEFAULT NULL,
  `correo_electronico` varchar(255) DEFAULT NULL,
  `nivel_usuario` enum('NORMAL','GOLD','PLATINUM') DEFAULT NULL,
  `cantidad_ventas` int DEFAULT NULL,
  `facturacion` decimal(10,2) DEFAULT NULL,
  `reputacion` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`usuario_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Usuarios`
--

LOCK TABLES `Usuarios` WRITE;
/*!40000 ALTER TABLE `Usuarios` DISABLE KEYS */;
/*!40000 ALTER TABLE `Usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-08-11 14:13:39
