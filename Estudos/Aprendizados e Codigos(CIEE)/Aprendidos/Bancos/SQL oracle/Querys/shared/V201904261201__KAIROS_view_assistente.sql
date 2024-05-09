CREATE OR REPLACE VIEW ACOMP_VAGAS_RES_ASSISTENTE AS (

  (SELECT DISTINCT RC.ID CONTRATO, VE.CODIGO_DA_VAGA, VE.PROCESSO_PERSONALIZADO VAGA_PP, 'E' TIPO_VAGA, VE.DATA_CRIACAO, P.ID ID_PCD, RPUC.DIAS_RET_ASSISTENTE, AC.DATA_CRIACAO DATA_ENVIO,
    (SELECT DISTINCT P.NOME FROM REP_ASSISTENTES RAC JOIN REP_PESSOAS P on RAC.ID_PESSOA = P.ID
      JOIN REP_CARTEIRAS CAR on RAC.ID = CAR.ID_ASSISTENTE
      JOIN REP_LOCAIS_ENDERECOS RLE ON RLE.ID_UNIDADE_CIEE = CAR.ID_UNIDADE_CIEE
      JOIN REP_ENDERECOS EN ON RLE.ID_ENDERECO = EN.ID
      JOIN REP_MAP_CARTEIRAS_TERRITORIOS MAP ON CAR.ID = MAP.ID_CARTEIRA AND EN.CEP = MAP.CEP
      JOIN REP_LOCAIS_CONTRATO RLC on RLE.ID_LOCAL_CONTRATO = RLC.ID
      WHERE VE.ID_LOCAL_CONTRATO = RLC.ID) ASSISTENTE,

     (SELECT DISTINCT CASE WHEN (
        SELECT V.ID FROM VAGAS_ESTAGIO V WHERE VE.DATA_ALTERACAO + DIAS_RET_ASSISTENTE <= SYSDATE AND V.ID = VE.ID) IS NOT NULL THEN 1 ELSE 0 END AS ALERTA
      FROM VAGAS_ESTAGIO) ALERTA

    FROM VAGAS_ESTAGIO VE
    JOIN REP_LOCAIS_CONTRATO LCT ON VE.ID_LOCAL_CONTRATO = LCT.ID
    JOIN REP_CONTRATOS RC ON LCT.ID_CONTRATO = RC.ID
    LEFT JOIN PCD P ON VE.ID = P.ID_VAGA_ESTAGIO
    JOIN REP_LOCAIS_ENDERECOS RLE on LCT.ID = RLE.ID_LOCAL_CONTRATO
    JOIN REP_PARAMETROS_UNIDADES_CIEE RPUC ON RPUC.ID_UNIDADE_CIEE = RLE.ID_UNIDADE_CIEE
    JOIN SITUACOES S on VE.ID_SITUACAO_VAGA = S.ID
    JOIN ACOMPANHAMENTOS_VAGAS AC ON AC.CODIGO_VAGA = VE.CODIGO_DA_VAGA
    WHERE VE.ID_SITUACAO_VAGA = S.ID AND VE.DELETADO = 0
          AND AC.DATA_CRIACAO = (SELECT MAX(A.DATA_CRIACAO) FROM ACOMPANHAMENTOS_VAGAS A WHERE A.CODIGO_VAGA = VE.CODIGO_DA_VAGA))

   UNION

   (SELECT DISTINCT RC.ID CONTRATO, VA.CODIGO_DA_VAGA, NULL VAGA_PP, 'A' TIPO_VAGA, VA.DATA_CRIACAO, P.ID ID_PCD, RPUC.DIAS_RET_ASSISTENTE, AC.DATA_CRIACAO DATA_ENVIO,
      (SELECT DISTINCT P.NOME FROM REP_ASSISTENTES RAC JOIN REP_PESSOAS P on RAC.ID_PESSOA = P.ID
        JOIN REP_CARTEIRAS CAR on RAC.ID = CAR.ID_ASSISTENTE
        JOIN REP_LOCAIS_ENDERECOS RLE ON RLE.ID_UNIDADE_CIEE = CAR.ID_UNIDADE_CIEE
        JOIN REP_ENDERECOS EN ON RLE.ID_ENDERECO = EN.ID
        JOIN REP_MAP_CARTEIRAS_TERRITORIOS MAP ON CAR.ID = MAP.ID_CARTEIRA AND EN.CEP = MAP.CEP
        JOIN REP_LOCAIS_CONTRATO RLC on RLE.ID_LOCAL_CONTRATO = RLC.ID
      WHERE VA.ID_LOCAL_CONTRATO = RLC.ID) ASSISTENTE,

      (SELECT DISTINCT CASE WHEN (
                                   SELECT V.ID FROM VAGAS_ESTAGIO V WHERE VA.DATA_ALTERACAO + DIAS_RET_ASSISTENTE <= SYSDATE AND V.ID = VA.ID) IS NOT NULL THEN 1 ELSE 0 END AS ALERTA
       FROM VAGAS_ESTAGIO) ALERTA

    FROM VAGAS_APRENDIZ VA
      JOIN REP_LOCAIS_CONTRATO LCT ON VA.ID_LOCAL_CONTRATO = LCT.ID
      JOIN REP_CONTRATOS RC ON LCT.ID_CONTRATO = RC.ID
      LEFT JOIN PCD_APRENDIZ P ON P.ID_VAGA_APENDIZ = VA.ID
      JOIN REP_LOCAIS_ENDERECOS RLE on LCT.ID = RLE.ID_LOCAL_CONTRATO
      JOIN REP_PARAMETROS_UNIDADES_CIEE RPUC ON RPUC.ID_UNIDADE_CIEE = RLE.ID_UNIDADE_CIEE
      JOIN SITUACOES S on VA.ID_SITUACAO_VAGA = S.ID
      JOIN ACOMPANHAMENTOS_VAGAS AC ON AC.CODIGO_VAGA = VA.CODIGO_DA_VAGA
    WHERE VA.ID_SITUACAO_VAGA = S.ID AND VA.DELETADO = 0
          AND AC.DATA_CRIACAO = (SELECT MAX(A.DATA_CRIACAO) FROM ACOMPANHAMENTOS_VAGAS A WHERE A.CODIGO_VAGA = VA.CODIGO_DA_VAGA))

);