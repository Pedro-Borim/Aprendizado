
ALTER TABLE PARAMETROS_TCE
RENAME TO CAMPOS_OBRIGATORIOS_CONTRATO;

DROP SEQUENCE SEQ_PARAMETROS_TCE;

CREATE SEQUENCE SEQ_CAMPOS_OBRIGATORIOS_CONTRATO MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;