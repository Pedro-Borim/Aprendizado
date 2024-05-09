DECLARE
    tabela_existente int:=0;
BEGIN
  SELECT count(*) into tabela_existente FROM all_tables where table_name = 'DADOS_MIGRACAO_INTEGRACAO_EMPREGADOR'; 

  if tabela_existente <= 0 then
    EXECUTE IMMEDIATE 'create table DADOS_MIGRACAO_INTEGRACAO_EMPREGADOR(
        ID NUMBER(20,0) PRIMARY KEY NOT NULL,
        CPF_ESTUDANTE VARCHAR2(11 CHAR)  NOT NULL,
        ID_CONTRATO_EMPRESA NUMBER(20,0)  NOT NULL,
        ID_LOCAL_CONTRATO_EMPRESA NUMBER(20,0) NOT NULL,
        DATA_TERMINO_CONTRATO_EMPREGADOR TIMESTAMP(6) NOT NULL,
        ENFILEIRADO NUMBER(1,0) DEFAULT 0,
        PROCESSADO NUMBER(1,0) DEFAULT 0,
        ERRO NUMBER(1,0) DEFAULT 0,
        INFORMACAO_ERRO VARCHAR2(4000 CHAR),
        ID_CONTRATO_ESTUDANTE_EMPRESA_GERADO NUMBER(20,0),
        INICIO_FERIAS1 TIMESTAMP(6),
        TERMINO_FERIAS1 TIMESTAMP(6),
        INICIO_FERIAS2 TIMESTAMP(6),
        TERMINO_FERIAS2 TIMESTAMP(6),
        INICIO_FERIAS3 TIMESTAMP(6),
        TERMINO_FERIAS3 TIMESTAMP(6),
        ID_MATRICULA_SECRETARIA_GERADO NUMBER(20,0)
    )';
    EXECUTE IMMEDIATE 'ALTER TABLE dados_migracao_integracao_empregador ADD CONSTRAINT validar_unique_id_estudante_id_contrato_id_local_contrato UNIQUE(CPF_ESTUDANTE, ID_CONTRATO_EMPRESA, ID_LOCAL_CONTRATO_EMPRESA)';
    
    EXECUTE IMMEDIATE 'CREATE SEQUENCE  SEQ_DADOS_MIGRACAO_INTEGRACAO_EMPREGADOR  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL';
  end if;
END;