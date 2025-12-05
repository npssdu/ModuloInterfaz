-- ================================================================
-- CREACIÓN DE TABLAS - GABINETE DE ABOGADOS
-- Base de Datos Oracle - Profesor: Sonia Ordoñez Salinas
-- ================================================================

-- Tabla: TIPODOCUMENTO
CREATE TABLE TIPODOCUMENTO (
    idTipoDoc VARCHAR2(2) PRIMARY KEY,
    descTipoDoc VARCHAR2(30) NOT NULL
);

-- Tabla: TIPOCONTACTO
CREATE TABLE TIPOCONTACTO (
    idTipoConta VARCHAR2(3) PRIMARY KEY,
    descTipoConta VARCHAR2(30) NOT NULL
);

-- Tabla: TIPOLUGAR
CREATE TABLE TIPOLUGAR (
    idTipoLugar VARCHAR2(4) PRIMARY KEY,
    descTipoLugar VARCHAR2(50) NOT NULL
);

-- Tabla: FORMAPAGO
CREATE TABLE FORMAPAGO (
    idFormaPago VARCHAR2(3) PRIMARY KEY,
    descFormaPago VARCHAR2(30) NOT NULL
);

-- Tabla: FRANQUICIA
CREATE TABLE FRANQUICIA (
    codFranquisia VARCHAR2(3) PRIMARY KEY,
    nomFranquisia VARCHAR2(40) NOT NULL
);

-- Tabla: CLIENTE
CREATE TABLE CLIENTE (
    codCliente VARCHAR2(5) PRIMARY KEY,
    nomCliente VARCHAR2(30) NOT NULL,
    apellCliente VARCHAR2(30) NOT NULL,
    nDocumento VARCHAR2(15) NOT NULL,
    idTipoDoc VARCHAR2(2) NOT NULL,
    FOREIGN KEY (idTipoDoc) REFERENCES TIPODOCUMENTO(idTipoDoc)
);

-- Tabla: CONTACTO
CREATE TABLE CONTACTO (
    conseContacto NUMBER(4) PRIMARY KEY,
    valorContacto VARCHAR2(50) NOT NULL,
    notificacion NUMBER(1) NOT NULL,
    codCliente VARCHAR2(5) NOT NULL,
    idTipoConta VARCHAR2(3) NOT NULL,
    FOREIGN KEY (codCliente) REFERENCES CLIENTE(codCliente),
    FOREIGN KEY (idTipoConta) REFERENCES TIPOCONTACTO(idTipoConta)
);

-- Tabla: LUGAR
CREATE TABLE LUGAR (
    codLugar VARCHAR2(5) PRIMARY KEY,
    nomLugar VARCHAR2(30) NOT NULL,
    direLugar VARCHAR2(40) NOT NULL,
    telLugar VARCHAR2(15) NOT NULL,
    emailLugar VARCHAR2(50),
    idTipoLugar VARCHAR2(4) NOT NULL,
    FOREIGN KEY (idTipoLugar) REFERENCES TIPOLUGAR(idTipoLugar)
);

-- Tabla: ESPECIALIZACION
CREATE TABLE ESPECIALIZACION (
    codEspecializacion VARCHAR2(3) PRIMARY KEY,
    nomEspecializacion VARCHAR2(30) NOT NULL
);

-- Tabla: ABOGADO
CREATE TABLE ABOGADO (
    cedula VARCHAR2(10) PRIMARY KEY,
    nombre VARCHAR2(30) NOT NULL,
    apellido VARCHAR2(30) NOT NULL,
    nTarjetaProfesional VARCHAR2(10) NOT NULL,
    codEspecializacion VARCHAR2(3) NOT NULL,
    FOREIGN KEY (codEspecializacion) REFERENCES ESPECIALIZACION(codEspecializacion)
);

-- Tabla: ETAPAPRO CESAL
CREATE TABLE ETAPAPROCESAL (
    codEtapa VARCHAR2(3) PRIMARY KEY,
    nomEtapa VARCHAR2(30) NOT NULL
);

-- Tabla: INSTANCIA
CREATE TABLE INSTANCIA (
    nInstancia NUMBER(1) PRIMARY KEY,
    CHECK (nInstancia BETWEEN 1 AND 5)
);

-- Tabla: IMPUGNACION
CREATE TABLE IMPUGNACION (
    idImpugna VARCHAR2(2) PRIMARY KEY,
    nomimpugna VARCHAR2(30) NOT NULL
);

-- Tabla: ESPECIA_ETAPA (Tabla de relación)
CREATE TABLE ESPECIA_ETAPA (
    pasoEtapa NUMBER(2),
    codEspecializacion VARCHAR2(3) NOT NULL,
    codEtapa VARCHAR2(3) NOT NULL,
    idImpugna VARCHAR2(2) NOT NULL,
    nInstancia NUMBER(1) NOT NULL,
    PRIMARY KEY (pasoEtapa, codEspecializacion, codEtapa, idImpugna, nInstancia),
    FOREIGN KEY (codEspecializacion) REFERENCES ESPECIALIZACION(codEspecializacion),
    FOREIGN KEY (codEtapa) REFERENCES ETAPAPROCESAL(codEtapa),
    FOREIGN KEY (idImpugna) REFERENCES IMPUGNACION(idImpugna),
    FOREIGN KEY (nInstancia) REFERENCES INSTANCIA(nInstancia)
);

-- Tabla: CASO
CREATE TABLE CASO (
    noCaso NUMBER(5) PRIMARY KEY,
    fechaInicio DATE NOT NULL,
    fechaFin DATE,
    valor VARCHAR2(10) NOT NULL,
    codCliente VARCHAR2(5) NOT NULL,
    cedula VARCHAR2(10) NOT NULL,
    codLugar VARCHAR2(5) NOT NULL,
    FOREIGN KEY (codCliente) REFERENCES CLIENTE(codCliente),
    FOREIGN KEY (cedula) REFERENCES ABOGADO(cedula),
    FOREIGN KEY (codLugar) REFERENCES LUGAR(codLugar)
);

-- Tabla: SUCESO
CREATE TABLE SUCESO (
    conSuceso NUMBER(4) PRIMARY KEY,
    descSuceso VARCHAR2(200) NOT NULL,
    noCaso NUMBER(5) NOT NULL,
    FOREIGN KEY (noCaso) REFERENCES CASO(noCaso)
);

-- Tabla: DOCUMENTO
CREATE TABLE DOCUMENTO (
    conDoc NUMBER(4) PRIMARY KEY,
    ubicaDoc VARCHAR2(50) NOT NULL,
    noCaso NUMBER(5) NOT NULL,
    FOREIGN KEY (noCaso) REFERENCES CASO(noCaso)
);

-- Tabla: RESULTADO
CREATE TABLE RESULTADO (
    conResul NUMBER(4) PRIMARY KEY,
    descResul VARCHAR2(200) NOT NULL,
    noCaso NUMBER(5) NOT NULL,
    FOREIGN KEY (noCaso) REFERENCES CASO(noCaso)
);

-- Tabla: EXPEDIENTE
CREATE TABLE EXPEDIENTE (
    consecExpe NUMBER(4) PRIMARY KEY,
    fechaEtapa DATE NOT NULL,
    noCaso NUMBER(5) NOT NULL,
    codEtapa VARCHAR2(3) NOT NULL,
    FOREIGN KEY (noCaso) REFERENCES CASO(noCaso),
    FOREIGN KEY (codEtapa) REFERENCES ETAPAPROCESAL(codEtapa)
);

-- Tabla: PAGO
CREATE TABLE PAGO (
    consecPago NUMBER(3) PRIMARY KEY,
    fechaPago DATE NOT NULL,
    valorPago NUMBER(10,0) NOT NULL,
    nTarjeta NUMBER(15),
    idFormaPago VARCHAR2(3) NOT NULL,
    noCaso NUMBER(5) NOT NULL,
    codFranquisia VARCHAR2(3),
    FOREIGN KEY (idFormaPago) REFERENCES FORMAPAGO(idFormaPago),
    FOREIGN KEY (noCaso) REFERENCES CASO(noCaso),
    FOREIGN KEY (codFranquisia) REFERENCES FRANQUICIA(codFranquisia)
);

COMMIT;