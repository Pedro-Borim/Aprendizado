--
-- Add coluna 'DATA_PREVISTA_PRORROGACAO' na tabela 'CONTRATOS_ESTUDANTE_EMPRESA'
--

ALTER TABLE CONTRATOS_ESTUDANTES_EMPRESA
    ADD DATA_PREVISTA_PRORROGACAO TIMESTAMP(6);

--
-- View de prorrogações pendentes de aprovação ou emissão
--

CREATE OR REPLACE VIEW V_PRORROGACOES_CONTR_EST_EMP AS (
    SELECT CEE.ID,
           CEE.NOME_EMPRESA,
           MAX(TRUNC(TA.DATA_CRIACAO))         DATA_CRIACAO,
           RLC.ID                              LOCAL_CONTRATO_ID,
           RE.ENDERECO                         LOC_CONTR_ENDERECO,
           RE.BAIRRO                           LOC_CONTR_BAIRRO,
           RE.NUMERO                           LOC_CONTR_NUM_ENDERECO,
           RE.COMPLEMENTO                      LOC_CONT_COMPL_ENDERECO,
           RE.CEP                              LOC_CONTR_CEP,
           RE.CIDADE                           LOC_CONTR_CIDADE,
           RE.UF                               LOC_CONTR_UF,
           CEE.ID_ESTUDANTE                    ID_ESTUDANTE,
           CEE.NOME_ESTUDANTE,
           CASE
               WHEN CEE.PENDENCIA_TA = 1 THEN CEE.DATA_PREVISTA_PRORROGACAO
               ELSE CEE.DATA_FINAL_ESTAGIO END PRORROGADO_PARA,
           CASE
               WHEN (SELECT MAX(TA.SEQ_TA)
                     FROM CONTRATO_TA TA
                     WHERE TA.DESCRICAO_CAMPO <> 'dataFinal'
                       AND TA.ID_CONTR_EMP_EST = CEE.ID) IS NOT NULL THEN 1
               ELSE 0 END                      ALTERADO,
           CEE.EMISSAO_DOCUMENTO_PENDENTE      PENDENTE_EMISSAO,
           CEE.PENDENCIA_TA                    PENDENTE_APROVACAO,
           MAX(TA.SEQ_TA)                      SEQ_TA

    FROM CONTRATO_TA TA
             JOIN CONTRATOS_ESTUDANTES_EMPRESA CEE on TA.ID_CONTR_EMP_EST = CEE.ID
             JOIN REP_LOCAIS_CONTRATO RLC on CEE.ID_LOCAL_CONTRATO = RLC.ID
             JOIN REP_LOCAIS_ENDERECOS RLE on RLC.ID = RLE.ID_LOCAL_CONTRATO
             JOIN REP_ENDERECOS RE on RLE.ID_ENDERECO = RE.ID
    WHERE TA.DESCRICAO_CAMPO = 'dataFinal'
      AND (CEE.PENDENCIA_TA = 1 OR CEE.EMISSAO_DOCUMENTO_PENDENTE = 1)
    GROUP BY CEE.ID, CEE.NOME_EMPRESA, RLC.ID, RE.UF, RE.CIDADE, RE.CEP, RE.COMPLEMENTO, RE.ENDERECO,
             RE.BAIRRO, RE.NUMERO, CEE.ID_ESTUDANTE, CEE.NOME_ESTUDANTE, CEE.DATA_FINAL_ESTAGIO,
             CEE.EMISSAO_DOCUMENTO_PENDENTE, CEE.PENDENCIA_TA, CEE.DATA_PREVISTA_PRORROGACAO
);
