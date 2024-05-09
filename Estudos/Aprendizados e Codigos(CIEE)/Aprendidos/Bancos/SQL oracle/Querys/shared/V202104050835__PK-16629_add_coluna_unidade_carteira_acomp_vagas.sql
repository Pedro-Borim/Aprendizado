
-- ACOMP_VAGAS_NOVAS implementa id_unidade_ciee_local e id_carteira_local
CREATE OR REPLACE FORCE EDITIONABLE VIEW "SERVICE_VAGAS_DEV"."ACOMP_VAGAS_NOVAS" ("CONTRATO", "CODIGO_DA_VAGA", "VAGA_PP", "TIPO_VAGA", "DATA_CRIACAO", "NUMERO_VAGAS", "ID_PCD", "NUMERO_MIN_ESTUDANTES_TRIAGEM", "ENCAMINHADOS", "TRIADOS", "FOLLOW_UP", "FOLLOW_UP_MANUAL", "DATA_PROCESSO_SELETIVO", "ALERTA", "ID_UNIDADE_CIEE_LOCAL", "ID_CARTEIRA_LOCAL") AS 
  (
(SELECT DISTINCT RC.ID CONTRATO, VE.CODIGO_DA_VAGA, VE.PROCESSO_PERSONALIZADO VAGA_PP, 'E' TIPO_VAGA, VE.DATA_CRIACAO, VE.NUMERO_VAGAS, P.ID ID_PCD, RPUC.NUMERO_MIN_ESTUDANTES_TRIAGEM,
                 (SELECT COUNT(VV.ID) FROM VINCULOS_VAGA VV WHERE VV.CODIGO_VAGA = VE.CODIGO_DA_VAGA AND VV.SITUACAO_VINCULO = 1 AND VV.DELETADO = 0) ENCAMINHADOS,
                 (SELECT COUNT(VIV.ID) FROM VINCULOS_VAGA VIV  WHERE VIV.CODIGO_VAGA = VE.CODIGO_DA_VAGA AND VIV.DELETADO = 0) TRIADOS,
                 (SELECT COUNT(ACOMP.ID) FROM ACOMPANHAMENTOS_VAGAS ACOMP WHERE ACOMP.CODIGO_VAGA = VE.CODIGO_DA_VAGA AND ACOMP.DELETADO = 0) FOLLOW_UP,
                 (SELECT COUNT(ACOMP.ID) FROM ACOMPANHAMENTOS_VAGAS ACOMP WHERE ACOMP.CODIGO_VAGA = VE.CODIGO_DA_VAGA AND ACOMP.DELETADO = 0 and ACOMP.TIPO_REGISTRO = 0) FOLLOW_UP_MANUAL,
                 (SELECT MIN(DATA_INICIO) FROM ETAPAS_PERIODOS EP INNER JOIN ETAPAS_PROCESSO_SELETIVO E on EP.ID_ETAPA_PROCESSO_SELETIVO = E.ID
                  WHERE E.ID_VAGA = VE.CODIGO_DA_VAGA) DATA_PROCESSO_SELETIVO,
                 (SELECT DISTINCT CASE WHEN (
                                                SELECT MIN(EP.DATA_INICIO) FROM ETAPAS_PERIODOS EP INNER JOIN ETAPAS_PROCESSO_SELETIVO E on EP.ID_ETAPA_PROCESSO_SELETIVO = E.ID
                                                WHERE (EP.DATA_INICIO = SYSDATE + 1 OR EP.DATA_INICIO < SYSDATE) AND E.ID_VAGA = VE.CODIGO_DA_VAGA
                                                  AND NUMERO_MIN_ESTUDANTES_TRIAGEM > (SELECT COUNT(VIV.ID) FROM VINCULOS_VAGA VIV  WHERE VIV.CODIGO_VAGA = VE.CODIGO_DA_VAGA AND VIV.DELETADO = 0)) IS NOT NULL THEN 1 ELSE 0  END AS ALERTA
                  FROM ETAPAS_PERIODOS) ALERTA,
                  RLE.ID_UNIDADE_CIEE_LOCAL,
                  RLE.ID_CARTEIRA_LOCAL

 FROM VAGAS_ESTAGIO VE
          JOIN REP_LOCAIS_CONTRATO ON VE.ID_LOCAL_CONTRATO = REP_LOCAIS_CONTRATO.ID
          JOIN REP_CONTRATOS RC ON REP_LOCAIS_CONTRATO.ID_CONTRATO = RC.ID
          LEFT JOIN PCD_ESTAGIO P ON VE.ID = P.ID_VAGA_ESTAGIO
          JOIN REP_LOCAIS_ENDERECOS RLE on REP_LOCAIS_CONTRATO.ID = RLE.ID_LOCAL_CONTRATO
          JOIN REP_PARAMETROS_UNIDADES_CIEE RPUC ON RPUC.ID_UNIDADE_CIEE = RLE.ID_UNIDADE_CIEE
 WHERE (
             VE.ID_SITUACAO_VAGA = (SELECT ID FROM SITUACOES WHERE SIGLA = 'A')
         OR (
                         VE.ID_SITUACAO_VAGA = (SELECT ID FROM SITUACOES WHERE SIGLA = 'B')
                     AND not exists(select 1 from OCORRENCIAS_ESTAGIO OE where OE.ID_VAGA_ESTAGIO = VE.ID and OE.DELETADO = 0)
                 )
     )
   AND VE.DELETADO = 0)

UNION

(SELECT DISTINCT RC.ID CONTRATO, VA.CODIGO_DA_VAGA, NULL VAGA_PP, 'A' TIPO_VAGA, VA.DATA_CRIACAO, VA.NUMERO_VAGAS, P.ID ID_PCD, RPUC.NUMERO_MIN_ESTUDANTES_TRIAGEM,
                 (SELECT COUNT(VV.ID) FROM VINCULOS_VAGA VV WHERE VV.CODIGO_VAGA = VA.CODIGO_DA_VAGA AND VV.SITUACAO_VINCULO = 1 AND VV.DELETADO = 0) ENCAMINHADOS,
                 (SELECT COUNT(VIV.ID) FROM VINCULOS_VAGA VIV  WHERE VIV.CODIGO_VAGA = VA.CODIGO_DA_VAGA AND VIV.DELETADO = 0) TRIADOS,
                 (SELECT COUNT(ACOMP.ID) FROM ACOMPANHAMENTOS_VAGAS ACOMP WHERE ACOMP.CODIGO_VAGA = VA.CODIGO_DA_VAGA AND ACOMP.DELETADO = 0) FOLLOW_UP,
                 (SELECT COUNT(ACOMP.ID) FROM ACOMPANHAMENTOS_VAGAS ACOMP WHERE ACOMP.CODIGO_VAGA = VA.CODIGO_DA_VAGA AND ACOMP.DELETADO = 0 AND ACOMP.TIPO_REGISTRO = 0) FOLLOW_UP_MANUAL,
                 (SELECT MIN(DATA_INICIO) FROM ETAPAS_PERIODOS EP INNER JOIN ETAPAS_PROCESSO_SELETIVO E on EP.ID_ETAPA_PROCESSO_SELETIVO = E.ID
                  WHERE E.ID_VAGA = VA.CODIGO_DA_VAGA) DATA_PROCESSO_SELETIVO,
                 (SELECT DISTINCT CASE WHEN (
                                                SELECT MIN(EP.DATA_INICIO) FROM ETAPAS_PERIODOS EP INNER JOIN ETAPAS_PROCESSO_SELETIVO E on EP.ID_ETAPA_PROCESSO_SELETIVO = E.ID
                                                WHERE (EP.DATA_INICIO = SYSDATE + 1 OR EP.DATA_INICIO < SYSDATE) AND E.ID_VAGA = VA.CODIGO_DA_VAGA
                                                  AND NUMERO_MIN_ESTUDANTES_TRIAGEM > (SELECT COUNT(VIV.ID) FROM VINCULOS_VAGA VIV  WHERE VIV.CODIGO_VAGA = VA.CODIGO_DA_VAGA AND VIV.DELETADO = 0)) IS NOT NULL THEN 1 ELSE 0 END AS ALERTA
                  FROM ETAPAS_PERIODOS) ALERTA,
                  RLE.ID_UNIDADE_CIEE_LOCAL,
                  RLE.ID_CARTEIRA_LOCAL

 FROM VAGAS_APRENDIZ VA
          JOIN REP_LOCAIS_CONTRATO ON VA.ID_LOCAL_CONTRATO = REP_LOCAIS_CONTRATO.ID
          JOIN REP_CONTRATOS RC ON REP_LOCAIS_CONTRATO.ID_CONTRATO = RC.ID
          LEFT JOIN PCD_APRENDIZ P ON P.ID_VAGA_APRENDIZ = VA.ID
          JOIN REP_LOCAIS_ENDERECOS RLE on REP_LOCAIS_CONTRATO.ID = RLE.ID_LOCAL_CONTRATO
          JOIN REP_PARAMETROS_UNIDADES_CIEE RPUC ON RPUC.ID_UNIDADE_CIEE = RLE.ID_UNIDADE_CIEE
 WHERE (
             VA.ID_SITUACAO_VAGA = (SELECT ID FROM SITUACOES WHERE SIGLA = 'A')
         OR (
                         VA.ID_SITUACAO_VAGA = (SELECT ID FROM SITUACOES WHERE SIGLA = 'B')
                     AND not exists(select 1 from OCORRENCIAS_APRENDIZ OA where OA.ID_VAGA_APRENDIZ = VA.ID and OA.DELETADO = 0)
                 )
     ) AND VA.DELETADO = 0)
)
;

-- ACOMP_VAGAS_CONTATO_AGENDADO implementa id_unidade_ciee_local e id_carteira_local
CREATE OR REPLACE FORCE EDITIONABLE VIEW "SERVICE_VAGAS_DEV"."ACOMP_VAGAS_CONTATO_AGENDADO" ("CONTRATO", "CODIGO_DA_VAGA", "VAGA_PP", "TIPO_VAGA", "DATA_CRIACAO", "ID_PCD", "SITUACAO", "LIMITE_MIN_ENCAMINHADOS_VAGA", "ENCAMINHADOS", "DATA_ULTIMO_CONTATO", "DATA_AGENDAMENTO", "DATA_PROCESSO_SELETIVO", "ALERTA", "ID_UNIDADE_CIEE_LOCAL", "ID_CARTEIRA_LOCAL") AS 
  (

        (SELECT DISTINCT RC.ID CONTRATO, VE.CODIGO_DA_VAGA, VE.PROCESSO_PERSONALIZADO VAGA_PP, 'E' TIPO_VAGA, VE.DATA_CRIACAO, P.ID ID_PCD, S.SIGLA SITUACAO, RPUC.LIMITE_MIN_ENCAMINHADOS_VAGA,
                         (SELECT COUNT(VV.ID) FROM VINCULOS_VAGA VV WHERE VV.CODIGO_VAGA = VE.CODIGO_DA_VAGA AND VV.SITUACAO_VINCULO = 1 AND VV.DELETADO = 0) ENCAMINHADOS,
                         (SELECT MAX(AGE.DATA_CRIACAO) FROM AGENDA_EMPRESA_VAGA AGE WHERE AGE.CODIGO_VAGA = VE.CODIGO_DA_VAGA) DATA_ULTIMO_CONTATO,
                         (SELECT AGE.DATA_HORA FROM AGENDA_EMPRESA_VAGA AGE WHERE AGE.CODIGO_VAGA = VE.CODIGO_DA_VAGA AND AGE.DATA_CRIACAO =
                                                                                                                          (SELECT MAX(AGE.DATA_CRIACAO) FROM AGENDA_EMPRESA_VAGA AGE WHERE AGE.CODIGO_VAGA = VE.CODIGO_DA_VAGA)) DATA_AGENDAMENTO,
                         (SELECT MIN(DATA_INICIO) FROM ETAPAS_PERIODOS EP INNER JOIN ETAPAS_PROCESSO_SELETIVO E on EP.ID_ETAPA_PROCESSO_SELETIVO = E.ID
                          WHERE E.ID_VAGA = VE.CODIGO_DA_VAGA) DATA_PROCESSO_SELETIVO,
                         (SELECT DISTINCT CASE WHEN (
                                                        SELECT MIN(EP.DATA_INICIO) FROM ETAPAS_PERIODOS EP INNER JOIN ETAPAS_PROCESSO_SELETIVO E on EP.ID_ETAPA_PROCESSO_SELETIVO = E.ID
                                                        WHERE (EP.DATA_INICIO = SYSDATE + 1 OR EP.DATA_INICIO < SYSDATE) AND E.ID_VAGA = VE.CODIGO_DA_VAGA
                                                          AND LIMITE_MIN_ENCAMINHADOS_VAGA > (SELECT COUNT(VV.ID) FROM VINCULOS_VAGA VV WHERE VV.CODIGO_VAGA = VE.CODIGO_DA_VAGA AND VV.SITUACAO_VINCULO = 1 AND VV.DELETADO = 0)) IS NOT NULL THEN 1 ELSE 0  END AS ALERTA
                          FROM ETAPAS_PERIODOS) ALERTA,
                          RLE.ID_UNIDADE_CIEE_LOCAL,
                          RLE.ID_CARTEIRA_LOCAL

         FROM VAGAS_ESTAGIO VE
                  JOIN REP_LOCAIS_CONTRATO ON VE.ID_LOCAL_CONTRATO = REP_LOCAIS_CONTRATO.ID
                  JOIN REP_CONTRATOS RC ON REP_LOCAIS_CONTRATO.ID_CONTRATO = RC.ID
                  LEFT JOIN PCD_ESTAGIO P ON VE.ID = P.ID_VAGA_ESTAGIO
                  JOIN SITUACOES S ON VE.ID_SITUACAO_VAGA = S.ID
                  JOIN REP_LOCAIS_ENDERECOS RLE on REP_LOCAIS_CONTRATO.ID = RLE.ID_LOCAL_CONTRATO
                  JOIN REP_PARAMETROS_UNIDADES_CIEE RPUC ON RPUC.ID_UNIDADE_CIEE = RLE.ID_UNIDADE_CIEE
                  JOIN AGENDA_EMPRESA_VAGA AEG ON AEG.CODIGO_VAGA = VE.CODIGO_DA_VAGA
         WHERE S.SIGLA <> 'P' AND S.SIGLA <> 'C' AND VE.DELETADO = 0)

        UNION

        (SELECT DISTINCT RC.ID CONTRATO, VA.CODIGO_DA_VAGA, NULL VAGA_PP, 'A' TIPO_VAGA, VA.DATA_CRIACAO, P.ID ID_PCD, S.SIGLA SITUACAO, RPUC.LIMITE_MIN_ENCAMINHADOS_VAGA,
                         (SELECT COUNT(VV.ID) FROM VINCULOS_VAGA VV WHERE VV.CODIGO_VAGA = VA.CODIGO_DA_VAGA AND VV.SITUACAO_VINCULO = 1 AND VV.DELETADO = 0) ENCAMINHADOS,
                         (SELECT MAX(AGE.DATA_CRIACAO) FROM AGENDA_EMPRESA_VAGA AGE WHERE AGE.CODIGO_VAGA = VA.CODIGO_DA_VAGA) DATA_ULTIMO_CONTATO,
                         (SELECT AGE.DATA_HORA FROM AGENDA_EMPRESA_VAGA AGE WHERE AGE.CODIGO_VAGA = VA.CODIGO_DA_VAGA AND AGE.DATA_CRIACAO =
                                                                                                                          (SELECT MAX(AGE.DATA_CRIACAO) FROM AGENDA_EMPRESA_VAGA AGE WHERE AGE.CODIGO_VAGA = VA.CODIGO_DA_VAGA)) DATA_AGENDAMENTO ,
                         (SELECT MIN(DATA_INICIO) FROM ETAPAS_PERIODOS EP INNER JOIN ETAPAS_PROCESSO_SELETIVO E on EP.ID_ETAPA_PROCESSO_SELETIVO = E.ID
                          WHERE E.ID_VAGA = VA.CODIGO_DA_VAGA) DATA_PROCESSO_SELETIVO,
                         (SELECT DISTINCT CASE WHEN (
                                                        SELECT MIN(EP.DATA_INICIO) FROM ETAPAS_PERIODOS EP INNER JOIN ETAPAS_PROCESSO_SELETIVO E on EP.ID_ETAPA_PROCESSO_SELETIVO = E.ID
                                                        WHERE (EP.DATA_INICIO = SYSDATE + 1 OR EP.DATA_INICIO < SYSDATE) AND E.ID_VAGA = VA.CODIGO_DA_VAGA
                                                          AND LIMITE_MIN_ENCAMINHADOS_VAGA > (SELECT COUNT(VV.ID) FROM VINCULOS_VAGA VV WHERE VV.CODIGO_VAGA = VA.CODIGO_DA_VAGA AND VV.SITUACAO_VINCULO = 1 AND VV.DELETADO = 0)) IS NOT NULL THEN 1 ELSE 0  END AS ALERTA
                          FROM ETAPAS_PERIODOS) ALERTA,
                          RLE.ID_UNIDADE_CIEE_LOCAL,
                          RLE.ID_CARTEIRA_LOCAL

         FROM VAGAS_APRENDIZ VA
                  JOIN REP_LOCAIS_CONTRATO ON VA.ID_LOCAL_CONTRATO = REP_LOCAIS_CONTRATO.ID
                  JOIN REP_CONTRATOS RC ON REP_LOCAIS_CONTRATO.ID_CONTRATO = RC.ID
                  LEFT JOIN PCD_APRENDIZ P ON VA.ID = P.ID_VAGA_APRENDIZ
                  JOIN SITUACOES S ON VA.ID_SITUACAO_VAGA = S.ID
                  JOIN REP_LOCAIS_ENDERECOS RLE on REP_LOCAIS_CONTRATO.ID = RLE.ID_LOCAL_CONTRATO
                  JOIN REP_PARAMETROS_UNIDADES_CIEE RPUC ON RPUC.ID_UNIDADE_CIEE = RLE.ID_UNIDADE_CIEE
                  JOIN AGENDA_EMPRESA_VAGA AEG ON AEG.CODIGO_VAGA = VA.CODIGO_DA_VAGA
         WHERE S.SIGLA <> 'P' AND S.SIGLA <> 'C' AND  VA.DELETADO = 0)

    );
    
-- ACOMP_VAGAS_OCORRENCIAS implementa id_unidade_ciee_local e id_carteira_local
CREATE OR REPLACE FORCE EDITIONABLE VIEW "SERVICE_VAGAS_DEV"."ACOMP_VAGAS_OCORRENCIAS" ("CONTRATO", "CODIGO_DA_VAGA", "VAGA_PP", "TIPO_VAGA", "DATA_CRIACAO", "ID_PCD", "NUMERO_VAGAS", "SITUACAO", "PRAZO_TRATAR", "ENCAMINHADOS", "DATA_OCORRENCIA", "DATA_PROCESSO_SELETIVO", "ALERTA", "ID_UNIDADE_CIEE_LOCAL", "ID_CARTEIRA_LOCAL") AS 
  (

        (SELECT DISTINCT RC.ID CONTRATO, VE.CODIGO_DA_VAGA, VE.PROCESSO_PERSONALIZADO VAGA_PP, 'E' TIPO_VAGA, VE.DATA_CRIACAO, P.ID ID_PCD, VE.NUMERO_VAGAS, S.SIGLA SITUACAO, RPUC.DIAS_PRAZO_TRATAR PRAZO_TRATAR,
                         (SELECT COUNT(VV.ID) FROM VINCULOS_VAGA VV WHERE VV.CODIGO_VAGA = VE.CODIGO_DA_VAGA AND VV.SITUACAO_VINCULO = 1 AND VV.DELETADO = 0) ENCAMINHADOS,
                         (SELECT MAX(OCE.DATA_OCORRENCIA) FROM OCORRENCIAS_ESTAGIO OCE WHERE OCE.ID_VAGA_ESTAGIO = VE.ID) DATA_OCORRENCIA,
                         (SELECT MIN(DATA_INICIO) FROM ETAPAS_PERIODOS EP INNER JOIN ETAPAS_PROCESSO_SELETIVO E on EP.ID_ETAPA_PROCESSO_SELETIVO = E.ID
                          WHERE E.ID_VAGA = VE.CODIGO_DA_VAGA) DATA_PROCESSO_SELETIVO,
                         (SELECT DISTINCT CASE WHEN (
                                                        SELECT MAX(OCE.DATA_OCORRENCIA) FROM OCORRENCIAS_ESTAGIO OCE WHERE OCE.ID_VAGA_ESTAGIO = VE.ID AND OCE.DATA_OCORRENCIA < SYSDATE - DIAS_PRAZO_TRATAR)
                             IS NOT NULL THEN 1 ELSE 0  END AS ALERTA
                          FROM ETAPAS_PERIODOS) ALERTA,
                          RLE.ID_UNIDADE_CIEE_LOCAL,
                          RLE.ID_CARTEIRA_LOCAL

         FROM VAGAS_ESTAGIO VE
                  JOIN REP_LOCAIS_CONTRATO RLC ON VE.ID_LOCAL_CONTRATO = RLC.ID
                  JOIN REP_CONTRATOS RC ON RLC.ID_CONTRATO = RC.ID
                  JOIN REP_LOCAIS_ENDERECOS RLE ON RLE.ID_LOCAL_CONTRATO = RLC.ID
                  LEFT JOIN PCD_ESTAGIO P ON VE.ID = P.ID_VAGA_ESTAGIO
                  JOIN SITUACOES S ON VE.ID_SITUACAO_VAGA = S.ID
                  JOIN OCORRENCIAS_ESTAGIO OCE ON VE.ID = OCE.ID_VAGA_ESTAGIO
                  JOIN REP_PARAMETROS_UNIDADES_CIEE RPUC ON RLE.ID_UNIDADE_CIEE = RPUC.ID_UNIDADE_CIEE
         WHERE VE.DELETADO = 0 AND OCE.DELETADO=0)

        UNION

        (SELECT DISTINCT RC.ID CONTRATO, VA.CODIGO_DA_VAGA, NULL VAGA_PP, 'A' TIPO_VAGA, VA.DATA_CRIACAO, P.ID ID_PCD, VA.NUMERO_VAGAS, S.SIGLA SITUACAO, RPUC.DIAS_PRAZO_TRATAR PRAZO_TRATAR,
                         (SELECT COUNT(VV.ID) FROM VINCULOS_VAGA VV WHERE VV.CODIGO_VAGA = VA.CODIGO_DA_VAGA AND VV.SITUACAO_VINCULO = 1 AND VV.DELETADO = 0) ENCAMINHADOS,
                         (SELECT MAX(OCA.DATA_OCORRENCIA) FROM OCORRENCIAS_APRENDIZ OCA WHERE OCA.ID_VAGA_APRENDIZ = VA.ID) DATA_OCORRENCIA,
                         (SELECT MIN(DATA_INICIO) FROM ETAPAS_PERIODOS EP INNER JOIN ETAPAS_PROCESSO_SELETIVO E on EP.ID_ETAPA_PROCESSO_SELETIVO = E.ID
                          WHERE E.ID_VAGA = VA.CODIGO_DA_VAGA) DATA_PROCESSO_SELETIVO,
                         (SELECT DISTINCT CASE WHEN (
                                                        SELECT MAX(OCE.DATA_OCORRENCIA) FROM OCORRENCIAS_ESTAGIO OCE WHERE OCE.ID_VAGA_ESTAGIO = VA.ID AND OCE.DATA_OCORRENCIA < SYSDATE - DIAS_PRAZO_TRATAR)
                             IS NOT NULL THEN 1 ELSE 0  END AS ALERTA
                          FROM ETAPAS_PERIODOS) ALERTA,
                          RLE.ID_UNIDADE_CIEE_LOCAL,
                          RLE.ID_CARTEIRA_LOCAL

         FROM VAGAS_APRENDIZ VA
                  JOIN REP_LOCAIS_CONTRATO RLC ON VA.ID_LOCAL_CONTRATO = RLC.ID
                  JOIN REP_CONTRATOS RC ON RLC.ID_CONTRATO = RC.ID
                  JOIN REP_LOCAIS_ENDERECOS RLE ON RLE.ID_LOCAL_CONTRATO = RLC.ID
                  LEFT JOIN PCD_APRENDIZ P ON VA.ID = P.ID_VAGA_APRENDIZ
                  JOIN SITUACOES S ON VA.ID_SITUACAO_VAGA = S.ID
                  JOIN OCORRENCIAS_APRENDIZ OCA ON VA.ID = OCA.ID_VAGA_APRENDIZ
                  JOIN REP_PARAMETROS_UNIDADES_CIEE RPUC ON RLE.ID_UNIDADE_CIEE = RPUC.ID_UNIDADE_CIEE
         WHERE VA.DELETADO = 0 AND OCA.DELETADO=0)

    );
    
-- ACOMP_VAGAS_PROCESSO_SELETIVO implementa id_unidade_ciee_local e id_carteira_local
CREATE OR REPLACE FORCE EDITIONABLE VIEW "SERVICE_VAGAS_DEV"."ACOMP_VAGAS_PROCESSO_SELETIVO" ("CONTRATO", "CODIGO_DA_VAGA", "VAGA_PP", "TIPO_VAGA", "DATA_CRIACAO", "NUMERO_VAGAS", "ID_PCD", "LIMITE_MIN_ENCAMINHADOS_VAGA", "SITUACAO", "ENCAMINHADOS", "TRIADOS", "DATA_PROCESSO_SELETIVO", "ALERTA", "ID_UNIDADE_CIEE_LOCAL", "ID_CARTEIRA_LOCAL") AS 
  (

        (SELECT DISTINCT RC.ID CONTRATO, VE.CODIGO_DA_VAGA, VE.PROCESSO_PERSONALIZADO VAGA_PP, 'E' TIPO_VAGA, VE.DATA_CRIACAO, VE.NUMERO_VAGAS, P.ID ID_PCD, RPUC.LIMITE_MIN_ENCAMINHADOS_VAGA, S.SIGLA SITUACAO,
                         (SELECT COUNT(VV.ID) FROM VINCULOS_VAGA VV WHERE VV.CODIGO_VAGA = VE.CODIGO_DA_VAGA AND VV.SITUACAO_VINCULO = 1 AND VV.DELETADO = 0) ENCAMINHADOS,
                         (SELECT COUNT(VIV.ID) FROM VINCULOS_VAGA VIV  WHERE VIV.CODIGO_VAGA = VE.CODIGO_DA_VAGA AND VIV.DELETADO = 0) TRIADOS,
                         (SELECT MIN(DATA_INICIO) FROM ETAPAS_PERIODOS EP INNER JOIN ETAPAS_PROCESSO_SELETIVO E on EP.ID_ETAPA_PROCESSO_SELETIVO = E.ID
                          WHERE E.ID_VAGA = VE.CODIGO_DA_VAGA) DATA_PROCESSO_SELETIVO,
                         (SELECT DISTINCT CASE WHEN (
                                                        SELECT MIN(EP.DATA_INICIO) FROM ETAPAS_PERIODOS EP INNER JOIN ETAPAS_PROCESSO_SELETIVO E on EP.ID_ETAPA_PROCESSO_SELETIVO = E.ID
                                                        WHERE (EP.DATA_INICIO = SYSDATE + 1 OR EP.DATA_INICIO < SYSDATE) AND E.ID_VAGA = VE.CODIGO_DA_VAGA
                                                          AND LIMITE_MIN_ENCAMINHADOS_VAGA > (SELECT COUNT(VV.ID) FROM VINCULOS_VAGA VV WHERE VV.CODIGO_VAGA = VE.CODIGO_DA_VAGA AND VV.SITUACAO_VINCULO = 1 AND VV.DELETADO = 0)) IS NOT NULL THEN 1 ELSE 0  END AS ALERTA
                          FROM ETAPAS_PERIODOS) ALERTA,
                          RLE.ID_UNIDADE_CIEE_LOCAL,
                          RLE.ID_CARTEIRA_LOCAL

         FROM VAGAS_ESTAGIO VE
                  JOIN REP_LOCAIS_CONTRATO ON VE.ID_LOCAL_CONTRATO = REP_LOCAIS_CONTRATO.ID
                  JOIN REP_CONTRATOS RC ON REP_LOCAIS_CONTRATO.ID_CONTRATO = RC.ID
                  LEFT JOIN PCD_ESTAGIO P ON VE.ID = P.ID_VAGA_ESTAGIO
                  JOIN REP_LOCAIS_ENDERECOS RLE on REP_LOCAIS_CONTRATO.ID = RLE.ID_LOCAL_CONTRATO
                  JOIN REP_PARAMETROS_UNIDADES_CIEE RPUC ON RPUC.ID_UNIDADE_CIEE = RLE.ID_UNIDADE_CIEE
                  JOIN SITUACOES S on VE.ID_SITUACAO_VAGA = S.ID
         WHERE VE.ID_SITUACAO_VAGA IN (SELECT ID FROM SITUACOES WHERE SIGLA = 'E' OR SIGLA = 'S') AND VE.DELETADO = 0)

        UNION

        (SELECT DISTINCT RC.ID CONTRATO, VA.CODIGO_DA_VAGA, NULL VAGA_PP, 'A' TIPO_VAGA, VA.DATA_CRIACAO, VA.NUMERO_VAGAS, P.ID ID_PCD, RPUC.LIMITE_MIN_ENCAMINHADOS_VAGA, S.SIGLA SITUACAO,
                         (SELECT COUNT(VV.ID) FROM VINCULOS_VAGA VV WHERE VV.CODIGO_VAGA = VA.CODIGO_DA_VAGA AND VV.SITUACAO_VINCULO = 1 AND VV.DELETADO = 0) ENCAMINHADOS,
                         (SELECT COUNT(VIV.ID) FROM VINCULOS_VAGA VIV  WHERE VIV.CODIGO_VAGA = VA.CODIGO_DA_VAGA AND VIV.DELETADO = 0) TRIADOS,
                         (SELECT MIN(DATA_INICIO) FROM ETAPAS_PERIODOS EP INNER JOIN ETAPAS_PROCESSO_SELETIVO E on EP.ID_ETAPA_PROCESSO_SELETIVO = E.ID
                          WHERE E.ID_VAGA = VA.CODIGO_DA_VAGA) DATA_PROCESSO_SELETIVO,
                         (SELECT DISTINCT CASE WHEN (
                                                        SELECT MIN(EP.DATA_INICIO) FROM ETAPAS_PERIODOS EP INNER JOIN ETAPAS_PROCESSO_SELETIVO E on EP.ID_ETAPA_PROCESSO_SELETIVO = E.ID
                                                        WHERE (EP.DATA_INICIO = SYSDATE + 1 OR EP.DATA_INICIO < SYSDATE) AND E.ID_VAGA = VA.CODIGO_DA_VAGA
                                                          AND LIMITE_MIN_ENCAMINHADOS_VAGA > (SELECT COUNT(VV.ID) FROM VINCULOS_VAGA VV WHERE VV.CODIGO_VAGA = VA.CODIGO_DA_VAGA AND VV.SITUACAO_VINCULO = 1 AND VV.DELETADO = 0)) IS NOT NULL THEN 1 ELSE 0 END AS ALERTA
                          FROM ETAPAS_PERIODOS) ALERTA,
                          RLE.ID_UNIDADE_CIEE_LOCAL,
                          RLE.ID_CARTEIRA_LOCAL

         FROM VAGAS_APRENDIZ VA
                  JOIN REP_LOCAIS_CONTRATO ON VA.ID_LOCAL_CONTRATO = REP_LOCAIS_CONTRATO.ID
                  JOIN REP_CONTRATOS RC ON REP_LOCAIS_CONTRATO.ID_CONTRATO = RC.ID
                  LEFT JOIN PCD_APRENDIZ P ON P.ID_VAGA_APRENDIZ = VA.ID
                  JOIN REP_LOCAIS_ENDERECOS RLE on REP_LOCAIS_CONTRATO.ID = RLE.ID_LOCAL_CONTRATO
                  JOIN REP_PARAMETROS_UNIDADES_CIEE RPUC ON RPUC.ID_UNIDADE_CIEE = RLE.ID_UNIDADE_CIEE
                  JOIN SITUACOES S on VA.ID_SITUACAO_VAGA = S.ID
         WHERE VA.ID_SITUACAO_VAGA IN (SELECT ID FROM SITUACOES WHERE SIGLA = 'E' OR SIGLA = 'S') AND VA.DELETADO = 0)

    );
    
-- ACOMP_VAGAS_RES_ASSISTENTE implementa id_unidade_ciee_local e id_carteira_local
CREATE OR REPLACE FORCE EDITIONABLE VIEW "SERVICE_VAGAS_DEV"."ACOMP_VAGAS_RES_ASSISTENTE" ("CONTRATO", "CODIGO_DA_VAGA", "VAGA_PP", "TIPO_VAGA", "DATA_CRIACAO", "ID_PCD", "DIAS_RET_ASSISTENTE", "DATA_ENVIO", "ASSISTENTE", "ALERTA", "ID_UNIDADE_CIEE_LOCAL", "ID_CARTEIRA_LOCAL") AS 
  (SELECT DISTINCT RC.ID CONTRATO, VE.CODIGO_DA_VAGA, VE.PROCESSO_PERSONALIZADO VAGA_PP, 'E' TIPO_VAGA, VE.DATA_CRIACAO, P.ID ID_PCD, RPUC.DIAS_RET_ASSISTENTE, AC.DATA_CRIACAO DATA_ENVIO,

                     (SELECT MIN(P.NOME) FROM REP_ASSISTENTES RAC
                                                  JOIN REP_PESSOAS P on RAC.ID_PESSOA = P.ID
                                                  JOIN REP_CARTEIRAS CAR on RAC.ID = CAR.ID_ASSISTENTE
                                                  JOIN REP_LOCAIS_ENDERECOS RLE ON RLE.ID_CARTEIRA = CAR.ID
                                                  JOIN REP_LOCAIS_CONTRATO RLC on RLE.ID_LOCAL_CONTRATO = RLC.ID
                      WHERE VE.ID_LOCAL_CONTRATO = RLC.ID
                      GROUP BY RLE.ID_LOCAL_CONTRATO) ASSISTENTE,

                     (SELECT DISTINCT CASE WHEN (
                                                    SELECT V.ID FROM VAGAS_ESTAGIO V WHERE VE.DATA_ALTERACAO + DIAS_RET_ASSISTENTE <= SYSDATE AND V.ID = VE.ID) IS NOT NULL THEN 1 ELSE 0 END AS ALERTA
                      FROM VAGAS_ESTAGIO) ALERTA,
                      RLE.ID_UNIDADE_CIEE_LOCAL,
                      RLE.ID_CARTEIRA_LOCAL

     FROM VAGAS_ESTAGIO VE
              JOIN REP_LOCAIS_CONTRATO LCT ON VE.ID_LOCAL_CONTRATO = LCT.ID
              JOIN REP_CONTRATOS RC ON LCT.ID_CONTRATO = RC.ID
              LEFT JOIN PCD_ESTAGIO P ON VE.ID = P.ID_VAGA_ESTAGIO
              JOIN REP_LOCAIS_ENDERECOS RLE on LCT.ID = RLE.ID_LOCAL_CONTRATO
              JOIN REP_PARAMETROS_UNIDADES_CIEE RPUC ON RPUC.ID_UNIDADE_CIEE = RLE.ID_UNIDADE_CIEE
              JOIN SITUACOES S on VE.ID_SITUACAO_VAGA = S.ID
              JOIN ACOMPANHAMENTOS_VAGAS AC ON AC.CODIGO_VAGA = VE.CODIGO_DA_VAGA
     WHERE S.SIGLA = 'I' AND VE.DELETADO = 0
       AND AC.DATA_CRIACAO = (SELECT MAX(A.DATA_CRIACAO) FROM ACOMPANHAMENTOS_VAGAS A WHERE A.CODIGO_VAGA = VE.CODIGO_DA_VAGA))

    UNION

    (SELECT DISTINCT RC.ID CONTRATO, VA.CODIGO_DA_VAGA, NULL VAGA_PP, 'A' TIPO_VAGA, VA.DATA_CRIACAO, P.ID ID_PCD, RPUC.DIAS_RET_ASSISTENTE, AC.DATA_CRIACAO DATA_ENVIO,

                     (SELECT MIN(P.NOME) FROM REP_ASSISTENTES RAC
                                                  JOIN REP_PESSOAS P on RAC.ID_PESSOA = P.ID
                                                  JOIN REP_CARTEIRAS CAR on RAC.ID = CAR.ID_ASSISTENTE
                                                  JOIN REP_LOCAIS_ENDERECOS RLE ON RLE.ID_CARTEIRA = CAR.ID
                                                  JOIN REP_LOCAIS_CONTRATO RLC on RLE.ID_LOCAL_CONTRATO = RLC.ID
                      WHERE VA.ID_LOCAL_CONTRATO = RLC.ID
                      GROUP BY RLE.ID_LOCAL_CONTRATO) ASSISTENTE,

                     (SELECT DISTINCT CASE WHEN (
                                                    SELECT V.ID FROM VAGAS_ESTAGIO V WHERE VA.DATA_ALTERACAO + DIAS_RET_ASSISTENTE <= SYSDATE AND V.ID = VA.ID) IS NOT NULL THEN 1 ELSE 0 END AS ALERTA
                      FROM VAGAS_ESTAGIO) ALERTA,
                      RLE.ID_UNIDADE_CIEE_LOCAL,
                      RLE.ID_CARTEIRA_LOCAL

     FROM VAGAS_APRENDIZ VA
              JOIN REP_LOCAIS_CONTRATO LCT ON VA.ID_LOCAL_CONTRATO = LCT.ID
              JOIN REP_CONTRATOS RC ON LCT.ID_CONTRATO = RC.ID
              LEFT JOIN PCD_APRENDIZ P ON P.ID_VAGA_APRENDIZ = VA.ID
              JOIN REP_LOCAIS_ENDERECOS RLE on LCT.ID = RLE.ID_LOCAL_CONTRATO
              JOIN REP_PARAMETROS_UNIDADES_CIEE RPUC ON RPUC.ID_UNIDADE_CIEE = RLE.ID_UNIDADE_CIEE
              JOIN SITUACOES S on VA.ID_SITUACAO_VAGA = S.ID
              JOIN ACOMPANHAMENTOS_VAGAS AC ON AC.CODIGO_VAGA = VA.CODIGO_DA_VAGA
     WHERE S.SIGLA = 'I' AND VA.DELETADO = 0
       AND AC.DATA_CRIACAO = (SELECT MAX(A.DATA_CRIACAO) FROM ACOMPANHAMENTOS_VAGAS A WHERE A.CODIGO_VAGA = VA.CODIGO_DA_VAGA));


