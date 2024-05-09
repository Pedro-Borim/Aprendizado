INSERT INTO QUALIFICACAO
(ID, NOME, NIVEL, SITUACAO, NUMERO_QUESTOES, NOTA_MINIMA, NOTA_MAXIMA, CRIADO_POR, DATA_CRIACAO, DATA_ALTERACAO, MODIFICADO_POR, DELETADO, TIPO)
SELECT SEQ_QUALIFICACAO.nextval,'GOOGLE', null, 1, null, null, null, 'PK-20026' ,current_timestamp, null, null, 0, 0 FROM DUAL
WHERE NOT EXISTS(SELECT 1 FROM QUALIFICACAO WHERE NOME = 'GOOGLE' AND TIPO = 0);