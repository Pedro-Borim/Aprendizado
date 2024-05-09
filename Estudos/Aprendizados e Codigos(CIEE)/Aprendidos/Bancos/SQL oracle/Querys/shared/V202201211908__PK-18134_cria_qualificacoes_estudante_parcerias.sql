INSERT INTO QUALIFICACAO 
(ID, NOME, NIVEL, SITUACAO, NUMERO_QUESTOES, NOTA_MINIMA, NOTA_MAXIMA, CRIADO_POR, DATA_CRIACAO, DATA_ALTERACAO, MODIFICADO_POR, DELETADO, TIPO) 
SELECT SEQ_QUALIFICACAO.nextval,'NOVOTEC', null, 0, null, null, null, 'PK-18134',current_timestamp, null, null, 0, 0 FROM DUAL
WHERE NOT EXISTS(SELECT 1 FROM QUALIFICACAO WHERE NOME = 'NOVOTEC' AND TIPO = 0);
---
INSERT INTO QUALIFICACAO 
(ID, NOME, NIVEL, SITUACAO, NUMERO_QUESTOES, NOTA_MINIMA, NOTA_MAXIMA, CRIADO_POR, DATA_CRIACAO, DATA_ALTERACAO, MODIFICADO_POR, DELETADO, TIPO) 
SELECT SEQ_QUALIFICACAO.nextval,'ICAB', null, 0, null, null, null, 'PK-18134',current_timestamp, null, null, 0, 0 FROM DUAL
WHERE NOT EXISTS(SELECT 1 FROM QUALIFICACAO WHERE NOME = 'ICAB' AND TIPO = 0);
---
INSERT INTO QUALIFICACAO 
(ID, NOME, NIVEL, SITUACAO, NUMERO_QUESTOES, NOTA_MINIMA, NOTA_MAXIMA, CRIADO_POR, DATA_CRIACAO, DATA_ALTERACAO, MODIFICADO_POR, DELETADO, TIPO) 
SELECT SEQ_QUALIFICACAO.nextval,'DIVERSITY', null, 0, null, null, null, 'PK-18134' ,current_timestamp, null, null, 0, 0 FROM DUAL
WHERE NOT EXISTS(SELECT 1 FROM QUALIFICACAO WHERE NOME = 'DIVERSITY' AND TIPO = 0);
