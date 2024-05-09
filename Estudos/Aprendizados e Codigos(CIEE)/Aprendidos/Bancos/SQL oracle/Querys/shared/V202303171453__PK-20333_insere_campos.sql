INSERT INTO CAMPOS
(ID, CAMPO, TIPO_CONTRATO, CRIADO_POR, DATA_CRIACAO, DATA_ALTERACAO, MODIFICADO_POR, DELETADO)
select (SELECT max(id)+1 from campos),'Código aprendiz',1,'PK-20333',current_timestamp,current_timestamp,'PK-20333',0 FROM DUAL
WHERE NOT EXISTS(SELECT 1 FROM CAMPOS WHERE CAMPO = 'Código aprendiz' AND TIPO_CONTRATO = 1);
INSERT INTO CAMPOS
(ID, CAMPO, TIPO_CONTRATO, CRIADO_POR, DATA_CRIACAO, DATA_ALTERACAO, MODIFICADO_POR, DELETADO)
select (SELECT max(id)+1 from campos),'CPF',1,'PK-20333',current_timestamp,current_timestamp,'PK-20333',0 FROM DUAL
WHERE NOT EXISTS(SELECT 1 FROM CAMPOS WHERE CAMPO = 'CPF' AND TIPO_CONTRATO = 1);
INSERT INTO CAMPOS
(ID, CAMPO, TIPO_CONTRATO, CRIADO_POR, DATA_CRIACAO, DATA_ALTERACAO, MODIFICADO_POR, DELETADO)
select (SELECT max(id)+1 from campos),'Curso',1,'PK-20333',current_timestamp,current_timestamp,'PK-20333',0 FROM DUAL
WHERE NOT EXISTS(SELECT 1 FROM CAMPOS WHERE CAMPO = 'Curso' AND TIPO_CONTRATO = 1);
INSERT INTO CAMPOS
(ID, CAMPO, TIPO_CONTRATO, CRIADO_POR, DATA_CRIACAO, DATA_ALTERACAO, MODIFICADO_POR, DELETADO)
select (SELECT max(id)+1 from campos),'Data de nascimento',1,'PK-20333',current_timestamp,current_timestamp,'PK-20333',0 FROM DUAL
WHERE NOT EXISTS(SELECT 1 FROM CAMPOS WHERE CAMPO = 'Data de nascimento' AND TIPO_CONTRATO = 1);
INSERT INTO CAMPOS
(ID, CAMPO, TIPO_CONTRATO, CRIADO_POR, DATA_CRIACAO, DATA_ALTERACAO, MODIFICADO_POR, DELETADO)
select (SELECT max(id)+1 from campos),'Data de rescisão',1,'PK-20333',current_timestamp,current_timestamp,'PK-20333',0 FROM DUAL
WHERE NOT EXISTS(SELECT 1 FROM CAMPOS WHERE CAMPO = 'Data de rescisão' AND TIPO_CONTRATO = 1);
INSERT INTO CAMPOS
(ID, CAMPO, TIPO_CONTRATO, CRIADO_POR, DATA_CRIACAO, DATA_ALTERACAO, MODIFICADO_POR, DELETADO)
select (SELECT max(id)+1 from campos),'Empresa',1,'PK-20333',current_timestamp,current_timestamp,'PK-20333',0 FROM DUAL
WHERE NOT EXISTS(SELECT 1 FROM CAMPOS WHERE CAMPO = 'Empresa' AND TIPO_CONTRATO = 1);
INSERT INTO CAMPOS
(ID, CAMPO, TIPO_CONTRATO, CRIADO_POR, DATA_CRIACAO, DATA_ALTERACAO, MODIFICADO_POR, DELETADO)
select (SELECT max(id)+1 from campos),'Escola',1,'PK-20333',current_timestamp,current_timestamp,'PK-20333',0 FROM DUAL
WHERE NOT EXISTS(SELECT 1 FROM CAMPOS WHERE CAMPO = 'Escola' AND TIPO_CONTRATO = 1);
INSERT INTO CAMPOS
(ID, CAMPO, TIPO_CONTRATO, CRIADO_POR, DATA_CRIACAO, DATA_ALTERACAO, MODIFICADO_POR, DELETADO)
select (SELECT max(id)+1 from campos),'Nome aprendiz',1,'PK-20333',current_timestamp,current_timestamp,'PK-20333',0 FROM DUAL
WHERE NOT EXISTS(SELECT 1 FROM CAMPOS WHERE CAMPO = 'Nome aprendiz' AND TIPO_CONTRATO = 1);
INSERT INTO CAMPOS
(ID, CAMPO, TIPO_CONTRATO, CRIADO_POR, DATA_CRIACAO, DATA_ALTERACAO, MODIFICADO_POR, DELETADO)
select (SELECT max(id)+1 from campos),'Nome do monitor do aprendiz',1,'PK-20333',current_timestamp,current_timestamp,'PK-20333',0 FROM DUAL
WHERE NOT EXISTS(SELECT 1 FROM CAMPOS WHERE CAMPO = 'Nome do monitor do aprendiz' AND TIPO_CONTRATO = 1);
INSERT INTO CAMPOS
(ID, CAMPO, TIPO_CONTRATO, CRIADO_POR, DATA_CRIACAO, DATA_ALTERACAO, MODIFICADO_POR, DELETADO)
select (SELECT max(id)+1 from campos),'Período da aprendizagem',1,'PK-20333',current_timestamp,current_timestamp,'PK-20333',0 FROM DUAL
WHERE NOT EXISTS(SELECT 1 FROM CAMPOS WHERE CAMPO = 'Período da aprendizagem' AND TIPO_CONTRATO = 1);
INSERT INTO CAMPOS
(ID, CAMPO, TIPO_CONTRATO, CRIADO_POR, DATA_CRIACAO, DATA_ALTERACAO, MODIFICADO_POR, DELETADO)
select (SELECT max(id)+1 from campos),'Relatório número',1,'PK-20333',current_timestamp,current_timestamp,'PK-20333',0 FROM DUAL
WHERE NOT EXISTS(SELECT 1 FROM CAMPOS WHERE CAMPO = 'Relatório número' AND TIPO_CONTRATO = 1);
INSERT INTO CAMPOS
(ID, CAMPO, TIPO_CONTRATO, CRIADO_POR, DATA_CRIACAO, DATA_ALTERACAO, MODIFICADO_POR, DELETADO)
select (SELECT max(id)+1 from campos),'RG',1,'PK-20333',current_timestamp,current_timestamp,'PK-20333',0 FROM DUAL
WHERE NOT EXISTS(SELECT 1 FROM CAMPOS WHERE CAMPO = 'RG' AND TIPO_CONTRATO = 1);
