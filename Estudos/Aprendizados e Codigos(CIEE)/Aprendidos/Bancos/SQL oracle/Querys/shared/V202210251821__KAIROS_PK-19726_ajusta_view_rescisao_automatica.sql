
 CREATE OR REPLACE FORCE EDITIONABLE VIEW "SERVICE_VAGAS_DEV"."V_CONTRATOS_RESCISAO_AUTOMATICA" ("ID", "DATA_FINAL_ESTAGIO", "DATA_FINAL_APRENDIZ") AS 
  (

SELECT C.ID, C.DATA_FINAL_ESTAGIO, C.DATA_FINAL_APRENDIZ
FROM CONTRATOS_ESTUDANTES_EMPRESA C
WHERE C.SITUACAO NOT IN (1,2) AND (C.DATA_FINAL_APRENDIZ < SYSDATE OR C.DATA_FINAL_ESTAGIO < SYSDATE)
    AND C.ID_MOTIVO_RESCISAO_CONTRATADO IS NULL
    AND ( (TRUNC(SYSDATE) - TRUNC(C.DATA_FINAL_ESTAGIO) >= (SELECT PPE.DIAS_RESCISAO_AUTOMATICA
                                                          FROM REP_PARAMETROS_PROGRAMA_EST PPE
                                                          WHERE PPE.CODIGO_CIEE IN (SELECT CIEE.ID
                                                                                    FROM REP_CIEES CIEE
                                                                                             INNER JOIN REP_PARAMETROS_UNIDADES_CIEE RPU ON RPU.ID_CIEE = CIEE.ID
                                                                                             INNER JOIN REP_UNIDADES_CIEE RU ON RU.ID = RPU.ID_UNIDADE_CIEE
                                                                                             INNER JOIN REP_LOCAIS_ENDERECOS RLE ON RLE.ID_UNIDADE_CIEE = RU.ID
                                                                                             INNER JOIN REP_LOCAIS_CONTRATO RLC on RLE.ID_LOCAL_CONTRATO = RLC.ID
                                                                                             INNER JOIN CONTRATOS_ESTUDANTES_EMPRESA CEE on RLC.ID = CEE.ID_LOCAL_CONTRATO
                                                                                    WHERE CEE.ID = C.ID)))
   OR (TRUNC(C.DATA_FINAL_APRENDIZ) - TRUNC(SYSDATE) <= (SELECT PPA.DIAS_RESCISAO_AUTOMATICA
                                                         FROM REP_PARAMETROS_PROGRAMA_APR PPA
                                                         WHERE PPA.CODIGO_CIEE IN (SELECT CIEE.ID
                                                                                   FROM REP_CIEES CIEE
                                                                                            INNER JOIN REP_PARAMETROS_UNIDADES_CIEE RPU ON RPU.ID_CIEE = CIEE.ID
                                                                                            INNER JOIN REP_UNIDADES_CIEE RU ON RU.ID = RPU.ID_UNIDADE_CIEE
                                                                                            INNER JOIN REP_LOCAIS_ENDERECOS RLE ON RLE.ID_UNIDADE_CIEE = RU.ID
                                                                                            INNER JOIN REP_LOCAIS_CONTRATO RLC on RLE.ID_LOCAL_CONTRATO = RLC.ID
                                                                                            INNER JOIN CONTRATOS_ESTUDANTES_EMPRESA CEE on RLC.ID = CEE.ID_LOCAL_CONTRATO
                                                                                   WHERE CEE.ID = C.ID))) )
);

