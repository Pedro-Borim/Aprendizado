CREATE OR REPLACE VIEW V_ICN_CONTRATO_UNIDADE_CIEE AS 
  SELECT TBL_CONTRATO_UNIDADE_CIEE.ID_CONTRATO
      ,RUC.ID_UNIDADE_ADMINISTRATIVA
      ,TBL_CONTRATO_UNIDADE_CIEE.ID_UNIDADE_CIEE
      ,CASE
            WHEN RUC.ID_UNIDADE_ADMINISTRATIVA <> 101 AND 
                 RUC.ID_UNIDADE_ADMINISTRATIVA <> 2401 AND
                 RUC.ID_UNIDADE_ADMINISTRATIVA IS NOT NULL 
                 THEN NULL
            WHEN RUC.ID_UNIDADE_ADMINISTRATIVA = 101 THEN 'SP'
            WHEN RUC.ID_UNIDADE_ADMINISTRATIVA = 2401 THEN 'RJ'
            ELSE 'OUTROS' 
       END AS UF_UNIDADE_CIEE
  FROM (
        SELECT DISTINCT C.ID AS ID_CONTRATO
              ,CASE 
                WHEN RUC_CONTRATO.ID_UNIDADE_ADMINISTRATIVA IS NULL 
                    THEN RLE.ID_UNIDADE_CIEE
                    ELSE RCC.ID_UNIDADE_CIEE
                    END AS ID_UNIDADE_CIEE
          FROM REP_CONTRATOS C 
          INNER JOIN REP_LOCAIS_CONTRATO RLC ON C.ID = RLC.ID_CONTRATO
          INNER JOIN REP_LOCAIS_ENDERECOS RLE ON RLC.ID = RLE.ID_LOCAL_CONTRATO AND RLE.ENDERECO_PRINCIPAL = 1
          INNER JOIN REP_CONFIGURACAO_CONTRATOS RCC ON C.ID = RCC.ID_CONTRATO
          INNER JOIN REP_UNIDADES_CIEE RUC_CONTRATO ON RCC.ID_UNIDADE_CIEE = RUC_CONTRATO.ID
          order by c.id desc
        ) TBL_CONTRATO_UNIDADE_CIEE 
  INNER JOIN REP_UNIDADES_CIEE RUC ON TBL_CONTRATO_UNIDADE_CIEE.ID_UNIDADE_CIEE = RUC.ID;