--PK-15783-migration-para-adicionar-novas-colunas
ALTER TABLE CONTRATOS_ESTUDANTES_EMPRESA ADD ESTAGIO_AUTONOMO NUMBER(1) DEFAULT 0;
ALTER TABLE PRE_CONTRATOS_ESTUDANTES_EMPRESA ADD ESTAGIO_AUTONOMO NUMBER(1) DEFAULT 0;
