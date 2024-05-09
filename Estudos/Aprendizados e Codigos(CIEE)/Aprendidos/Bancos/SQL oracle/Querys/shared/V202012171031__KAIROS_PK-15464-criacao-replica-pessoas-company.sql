CREATE TABLE SERVICE_VAGAS_DEV.REP_PESSOAS_COMPANY
(	ID NUMBER,
	ID_EMAIL NUMBER(19,0) NOT NULL ENABLE,
	NOME VARCHAR2(150 CHAR) NOT NULL ENABLE,
	CARGO VARCHAR2(100 CHAR) NOT NULL ENABLE,
	DEPARTAMENTO VARCHAR2(50 CHAR) NOT NULL ENABLE,
	DATA_CRIACAO TIMESTAMP (6) NOT NULL ENABLE,
	DATA_ALTERACAO TIMESTAMP (6) NOT NULL ENABLE,
	CRIADO_POR VARCHAR2(255 CHAR),
	MODIFICADO_POR VARCHAR2(255 CHAR),
	DELETADO NUMBER(1,0)
);
ALTER TABLE SERVICE_VAGAS_DEV.REP_PESSOAS_COMPANY ADD (CONSTRAINT KRS_INDICE_09900 PRIMARY KEY (id));
COMMENT ON TABLE SERVICE_VAGAS_DEV.REP_PESSOAS_COMPANY IS 'COMPANY_DEV:SERVICE_COMPANY_DEV:PESSOAS:ID';