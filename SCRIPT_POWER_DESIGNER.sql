-- ================================================================
-- SCRIPT DDL - GABINETE DE ABOGADOS
-- Para importar en Power Designer (Reverse Engineering)
-- Base de Datos: Oracle
-- ================================================================

-- ============ TABLAS DE CATALOGO ============

CREATE TABLE TIPODOCUMENTO (
    idTipoDoc       VARCHAR2(2) PRIMARY KEY,
    descTipoDoc     VARCHAR2(30) NOT NULL
);

CREATE TABLE TIPOCONTACTO (
    idTipoConta     VARCHAR2(3) PRIMARY KEY,
    descTipoConta   VARCHAR2(30) NOT NULL
);

CREATE TABLE TIPOLUGAR (
    idTipoLugar     VARCHAR2(4) PRIMARY KEY,
    descTipoLugar   VARCHAR2(50) NOT NULL
);

CREATE TABLE FORMAPAGO (
    idFormaPago     VARCHAR2(3) PRIMARY KEY,
    descFormaPago   VARCHAR2(30) NOT NULL
);

CREATE TABLE FRANQUICIA (
    codFranquisia   VARCHAR2(3) PRIMARY KEY,
    nomFranquisia   VARCHAR2(40) NOT NULL
);

CREATE TABLE ESPECIALIZACION (
    codEspecializacion  VARCHAR2(3) PRIMARY KEY,
    nomEspecializacion  VARCHAR2(30) NOT NULL
);

CREATE TABLE ETAPAPROCESAL (
    codEtapa        VARCHAR2(3) PRIMARY KEY,
    nomEtapa        VARCHAR2(30) NOT NULL
);

CREATE TABLE INSTANCIA (
    nInstancia      NUMBER(1) PRIMARY KEY,
    CONSTRAINT ck_instancia CHECK (nInstancia BETWEEN 1 AND 5)
);

CREATE TABLE IMPUGNACION (
    idImpugna       VARCHAR2(2) PRIMARY KEY,
    nomimpugna      VARCHAR2(30) NOT NULL
);

-- ============ TABLAS PRINCIPALES ============

CREATE TABLE CLIENTE (
    codCliente      VARCHAR2(5) PRIMARY KEY,
    nomCliente      VARCHAR2(30) NOT NULL,
    apellCliente    VARCHAR2(30) NOT NULL,
    nDocumento      VARCHAR2(15) NOT NULL,
    idTipoDoc       VARCHAR2(2) NOT NULL,
    CONSTRAINT fk_cliente_tipodoc 
        FOREIGN KEY (idTipoDoc) REFERENCES TIPODOCUMENTO(idTipoDoc)
);

CREATE TABLE CONTACTO (
    conseContacto   NUMBER(4) PRIMARY KEY,
    valorContacto   VARCHAR2(50) NOT NULL,
    notificacion    NUMBER(1) NOT NULL,
    codCliente      VARCHAR2(5) NOT NULL,
    idTipoConta     VARCHAR2(3) NOT NULL,
    CONSTRAINT fk_contacto_cliente 
        FOREIGN KEY (codCliente) REFERENCES CLIENTE(codCliente),
    CONSTRAINT fk_contacto_tipo 
        FOREIGN KEY (idTipoConta) REFERENCES TIPOCONTACTO(idTipoConta)
);

CREATE TABLE LUGAR (
    codLugar        VARCHAR2(5) PRIMARY KEY,
    nomLugar        VARCHAR2(30) NOT NULL,
    direLugar       VARCHAR2(40) NOT NULL,
    telLugar        VARCHAR2(15) NOT NULL,
    emailLugar      VARCHAR2(50),
    idTipoLugar     VARCHAR2(4) NOT NULL,
    CONSTRAINT fk_lugar_tipo 
        FOREIGN KEY (idTipoLugar) REFERENCES TIPOLUGAR(idTipoLugar)
);

CREATE TABLE ABOGADO (
    cedula                  VARCHAR2(10) PRIMARY KEY,
    nombre                  VARCHAR2(30) NOT NULL,
    apellido                VARCHAR2(30) NOT NULL,
    nTarjetaProfesional     VARCHAR2(10) NOT NULL,
    codEspecializacion      VARCHAR2(3) NOT NULL,
    CONSTRAINT fk_abogado_especializacion 
        FOREIGN KEY (codEspecializacion) REFERENCES ESPECIALIZACION(codEspecializacion)
);

CREATE TABLE ESPECIA_ETAPA (
    pasoEtapa           NUMBER(2),
    codEspecializacion  VARCHAR2(3) NOT NULL,
    codEtapa            VARCHAR2(3) NOT NULL,
    idImpugna           VARCHAR2(2) NOT NULL,
    nInstancia          NUMBER(1) NOT NULL,
    CONSTRAINT pk_especia_etapa 
        PRIMARY KEY (pasoEtapa, codEspecializacion, codEtapa, idImpugna, nInstancia),
    CONSTRAINT fk_ee_especializacion 
        FOREIGN KEY (codEspecializacion) REFERENCES ESPECIALIZACION(codEspecializacion),
    CONSTRAINT fk_ee_etapa 
        FOREIGN KEY (codEtapa) REFERENCES ETAPAPROCESAL(codEtapa),
    CONSTRAINT fk_ee_impugnacion 
        FOREIGN KEY (idImpugna) REFERENCES IMPUGNACION(idImpugna),
    CONSTRAINT fk_ee_instancia 
        FOREIGN KEY (nInstancia) REFERENCES INSTANCIA(nInstancia)
);

CREATE TABLE CASO (
    noCaso          NUMBER(5) PRIMARY KEY,
    fechaInicio     DATE NOT NULL,
    fechaFin        DATE,
    valor           VARCHAR2(10) NOT NULL,
    codCliente      VARCHAR2(5) NOT NULL,
    cedula          VARCHAR2(10) NOT NULL,
    codLugar        VARCHAR2(5) NOT NULL,
    CONSTRAINT fk_caso_cliente 
        FOREIGN KEY (codCliente) REFERENCES CLIENTE(codCliente),
    CONSTRAINT fk_caso_abogado 
        FOREIGN KEY (cedula) REFERENCES ABOGADO(cedula),
    CONSTRAINT fk_caso_lugar 
        FOREIGN KEY (codLugar) REFERENCES LUGAR(codLugar)
);

CREATE TABLE SUCESO (
    conSuceso       NUMBER(4) PRIMARY KEY,
    descSuceso      VARCHAR2(200) NOT NULL,
    noCaso          NUMBER(5) NOT NULL,
    CONSTRAINT fk_suceso_caso 
        FOREIGN KEY (noCaso) REFERENCES CASO(noCaso)
);

CREATE TABLE DOCUMENTO (
    conDoc          NUMBER(4) PRIMARY KEY,
    ubicaDoc        VARCHAR2(50) NOT NULL,
    noCaso          NUMBER(5) NOT NULL,
    CONSTRAINT fk_documento_caso 
        FOREIGN KEY (noCaso) REFERENCES CASO(noCaso)
);

CREATE TABLE RESULTADO (
    conResul        NUMBER(4) PRIMARY KEY,
    descResul       VARCHAR2(200) NOT NULL,
    noCaso          NUMBER(5) NOT NULL,
    CONSTRAINT fk_resultado_caso 
        FOREIGN KEY (noCaso) REFERENCES CASO(noCaso)
);

CREATE TABLE EXPEDIENTE (
    consecExpe      NUMBER(4) PRIMARY KEY,
    fechaEtapa      DATE NOT NULL,
    noCaso          NUMBER(5) NOT NULL,
    codEtapa        VARCHAR2(3) NOT NULL,
    CONSTRAINT fk_expediente_caso 
        FOREIGN KEY (noCaso) REFERENCES CASO(noCaso),
    CONSTRAINT fk_expediente_etapa 
        FOREIGN KEY (codEtapa) REFERENCES ETAPAPROCESAL(codEtapa)
);

CREATE TABLE PAGO (
    consecPago      NUMBER(3) PRIMARY KEY,
    fechaPago       DATE NOT NULL,
    valorPago       NUMBER(10,0) NOT NULL,
    nTarjeta        NUMBER(15),
    idFormaPago     VARCHAR2(3) NOT NULL,
    noCaso          NUMBER(5) NOT NULL,
    codFranquisia   VARCHAR2(3),
    CONSTRAINT fk_pago_formapago 
        FOREIGN KEY (idFormaPago) REFERENCES FORMAPAGO(idFormaPago),
    CONSTRAINT fk_pago_caso 
        FOREIGN KEY (noCaso) REFERENCES CASO(noCaso),
    CONSTRAINT fk_pago_franquicia 
        FOREIGN KEY (codFranquisia) REFERENCES FRANQUICIA(codFranquisia)
);

-- ================================================================
-- FIN DEL SCRIPT DDL
-- Total: 17 Tablas
-- ================================================================
