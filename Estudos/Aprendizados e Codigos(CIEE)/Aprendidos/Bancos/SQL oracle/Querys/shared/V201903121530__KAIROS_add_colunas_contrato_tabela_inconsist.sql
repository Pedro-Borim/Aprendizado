-- Criando coluna de status para Pre-Contrato/Contrato

ALTER TABLE PRE_CONTRATOS_ESTUDANTES_EMPRESA ADD SITUACAO NUMBER(1) DEFAULT 0;
ALTER TABLE CONTRATOS_ESTUDANTES_EMPRESA ADD SITUACAO NUMBER(1);

COMMENT ON COLUMN PRE_CONTRATOS_ESTUDANTES_EMPRESA.SITUACAO IS
'Flags:
  0: Rascunho
  1: Inconsistente';

ALTER TABLE PRE_CONTRATOS_ESTUDANTES_EMPRESA ADD CODIGO_ESTUDANTE VARCHAR2(20) NOT NULL;
ALTER TABLE CONTRATOS_ESTUDANTES_EMPRESA ADD CODIGO_ESTUDANTE VARCHAR2(20) NOT NULL;

CREATE TABLE INCONSISTENCIAS_CONTRATO (
  ID NUMBER(20) NOT NULL,
  ID_PRE_CONTRATOS_ESTUDANTES_EMPRESA NUMBER(20) NOT NULL,
  CAMPO VARCHAR2(255) NOT NULL,
  VALOR VARCHAR2(255) NOT NULL
);

CREATE TABLE HISTORICO_INCONSISTENCIAS (
  ID NUMBER(20) NOT NULL,
  ID_CONTRATOS_ESTUDANTES_EMPRESA NUMBER(20) NOT NULL,
  CAMPO VARCHAR2(255) NOT NULL,
  VALOR VARCHAR2(255) NOT NULL
);

ALTER TABLE INCONSISTENCIAS_CONTRATO ADD CONSTRAINT KRS_INDICE_02063 PRIMARY KEY (ID);
ALTER TABLE HISTORICO_INCONSISTENCIAS ADD CONSTRAINT KRS_INDICE_02064 PRIMARY KEY (ID);

ALTER TABLE INCONSISTENCIAS_CONTRATO ADD CONSTRAINT KRS_INDICE_02065 FOREIGN KEY (ID_PRE_CONTRATOS_ESTUDANTES_EMPRESA) REFERENCES PRE_CONTRATOS_ESTUDANTES_EMPRESA (ID);
ALTER TABLE HISTORICO_INCONSISTENCIAS ADD CONSTRAINT KRS_INDICE_02066 FOREIGN KEY (ID_CONTRATOS_ESTUDANTES_EMPRESA) REFERENCES CONTRATOS_ESTUDANTES_EMPRESA (ID);

COMMENT ON COLUMN INCONSISTENCIAS_CONTRATO.CAMPO IS 'Nome do campo que está inconsistente';
COMMENT ON COLUMN INCONSISTENCIAS_CONTRATO.VALOR IS 'Descrição sobre a inconsistencia';

COMMENT ON COLUMN HISTORICO_INCONSISTENCIAS.CAMPO IS 'Nome do campo que está inconsistente';
COMMENT ON COLUMN HISTORICO_INCONSISTENCIAS.VALOR IS 'Descrição sobre a inconsistencia';

CREATE SEQUENCE SEQ_INCONSISTENCIAS_CONTRATO MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER NOCYCLE NOKEEP NOSCALE GLOBAL;
CREATE SEQUENCE SEQ_HISTORICO_INCONSISTENCIAS MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER NOCYCLE NOKEEP NOSCALE GLOBAL;
