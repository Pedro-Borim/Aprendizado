create or replace PROCEDURE                                                       proc_triagem_candidatos_analitico_aprendiz (
    V_CODIGO_DA_VAGA     NUMBER DEFAULT NULL,
    V_QUEM_TRIOU         NUMBER,
    V_CRIADO_POR         VARCHAR2,
    V_IDS_EST_VINC       VARCHAR2,
    V_OFFSET             NUMBER DEFAULT 0,
    V_NEXT               NUMBER DEFAULT 50
)
AS
BEGIN

    /*INSERT NA TABELA PARA ANÁLISE DA TRIAGEM */
    INSERT INTO SERVICE_VAGAS_DEV.TRIAGEM_CANDIDATOS_ANALITICO (
                                                                ID
                                                               ,ID_EMPRESA
                                                               ,ID_ESTUDANTE
                                                               ,CODIGO_VAGA
                                                               ,TIPO_VAGA
                                                               ,MORA
                                                               ,ESTUDA
                                                               ,SEMESTRE_VAGA
                                                               ,DATA_CONCLUSAO
                                                               ,HORARIO
                                                               ,SEXO
                                                               ,FAIXA_ETARIA
                                                               ,ESTADO_CIVIL
                                                               ,IDIOMAS
                                                               ,CONHECIMENTOS
                                                               ,RESERVISTA
                                                               ,FUMANTE
                                                               ,CNH
                                                               ,ESCOLA
                                                               ,TIPO_DEFICIENCIA
                                                               ,RECURSO
                                                               ,VALIDADE_LAUDO
                                                               ,OFERECE_ACESSIBILIDADE
                                                               ,VALIDO_COTA
                                                               ,CAPACITACAO_MORA
                                                               ,QUEM_TRIOU
                                                               ,DELETADO
                                                               ,DATA_CRIACAO
                                                               ,DATA_ALTERACAO
                                                               ,CRIADO_POR
                                                               ,MODIFICADO_POR
                                                               ,PARAMETRO_ESCOLAR
                                                               ,PRIORIZA_VULNERAVEL
                                                               ,QUALIFICACAO_RESTRITIVA
                                                               ,SITUACAO
    )
    SELECT
        -- GERAÇÃO DO IDENTITY DA TABELA
        SERVICE_VAGAS_DEV.SEQ_TRIAGEM_CAND_ANALITICO.nextval as ID,
        T.*,
        CASE WHEN (T.DISTANCIA_CASA+T.DISTANCIA_CAMPUS+T.HORARIO+T.SEXO+T.FAIXA_ETARIA+T.RESERVISTA+T.TIPO_DEFICIENCIA+T.RECURSO_ACESSIBILIDADE+T.VALIDADE_LAUDO+T.OFERECE_ACESSIBILIDADE+T.VALIDO_COTA+T.DISTANCIA_CAPACITACAO) = 12 THEN
                 1
             ELSE
                 0
            END as SITUACAO
    FROM (
             SELECT

                 V.ID_EMPRESA AS ID_EMPRESA

                  ,E.ID_ESTUDANTE AS ID_ESTUDANTE

                  ,V.CODIGO_DA_VAGA AS CODIGO_VAGA

                  --Enum: 0- Estagio, 1- Aprendiz
                  ,1 AS TIPO_VAGA

                  -- [I] CÁLCULO DE DISTÂNCIA ENTRE O LOCAL DE ESTÁGIO E O ENDEREÇO DO ALUNO
                  ,CASE WHEN
                                    NVL(V.LOCALIZACAO, 5) IN (2, 5, 6) OR
                                    (
                                                NVL(V.LOCALIZACAO, 1) IN (0, 1, 3, 4)
                                            AND EXISTS (SELECT 1 from TABLE (V.ENDERECO_GEOHASHS) E WHERE E.COLUMN_VALUE = E.ENDERECO_GEOHASH)
                                        --AND SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO, 0.005, 'unit=km') < NVL(V.VALOR_RAIO, 20)
                                        ) THEN 1 ELSE 0
                 END
                 AS DISTANCIA_CASA

                  -- [I] CÁLCULO DE DISTÂNCIA ENTRE O LOCAL DE ESTÁGIO E O ENDEREÇO DO CAMPUS DO ALUNO
                  , CASE WHEN
                                     NVL(V.LOCALIZACAO, 5) IN (1, 4, 5) OR
                                     (
                                                 NVL(V.LOCALIZACAO, 1) IN (0, 2, 3, 6)
                                             AND EXISTS (SELECT 1 from TABLE (V.ENDERECO_GEOHASHS) E WHERE E.COLUMN_VALUE = E.ENDERECO_CAMPUS_GEOHASH)
                                         --AND SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO_CAMPUS, 0.005, 'unit=km') < NVL(V.VALOR_RAIO, 20)
                                         ) THEN 1 ELSE 0
                 END
                 AS DISTANCIA_CAMPUS

                  -- [E] SE A VAGA ESPECIFICAR SEMESTRE, O ESTUDANTE DEVE POSSUIR
                  , NULL AS SEMESTRE_VAGA

                  -- [E] Validar data de conclusão
                  , NULL AS DATA_CONCLUSAO

                  -- [I] Validar Horário
                  ,CASE WHEN
                                (TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) >= 18 OR (extract(hour from V.HORARIO_ENTRADA) < 18 AND extract(hour from V.HORARIO_SAIDA) < 18))
                                AND (
                                            V.TIPO_HORARIO_ESTAGIO = 0 OR
                                            (
                                                        E.MODALIDADE = 'E'
                                                    OR (
                                                                    E.MODALIDADE = 'P'
                                                                AND
                                                                    (
                                                                                E.TIPO_PERIODO_CURSO = 'Variável'
                                                                            OR E.TIPO_PERIODO_CURSO IN ('Manhã', 'Integral') AND V.HORARIO_ENTRADA > E.HORARIO_SAIDA
                                                                            OR E.TIPO_PERIODO_CURSO = 'Tarde' AND (V.HORARIO_SAIDA < E.HORARIO_ENTRADA OR V.HORARIO_ENTRADA > E.HORARIO_SAIDA)
                                                                            OR E.TIPO_PERIODO_CURSO IN ('Noite', 'Vespertino') AND (V.HORARIO_SAIDA < E.HORARIO_ENTRADA)
                                                                        )
                                                            )
                                                )
                                    )
                            THEN 1 ELSE 0 END AS HORARIO

                  -- [I] SE A VAGA EXIGE GENERO BIOLOGICO ESPECÌFICO, VALIDAR O PERFIL DO ESTUDANTE
                  ,CASE WHEN V.SEXO IS NULL OR V.SEXO = 'I' OR V.SEXO = E.SEXO THEN 1 ELSE 0 END SEXO

                  -- [I] VALIDA A IDADE DO ESTUDANTE
                  ,CASE WHEN
                                (V.IDADE_MINIMA IS NULL OR TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) >= V.IDADE_MINIMA)
                                AND
                                (V.IDADE_MAXIMA IS NULL OR TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) <= V.IDADE_MAXIMA)
                            THEN 1
                        ELSE 0
                 END AS FAIXA_ETARIA

                  -- [E] SE A VAGA ESPECIFICOU UM ESTADO CÍVIL, O ESTUDANTE DEVE CONSTAR NELE
                  , NULL AS ESTADO_CIVIL

                  -- [E] REALIZA A COMPARAÇÃO POR IDIOMA
                  , NULL AS IDIOMAS

                  -- [E] EFETUA O BATIMENTO DE CONHECIMENTOS, LEVANDO EM CONSIDERAÇÃO O NÍVEL
                  , NULL AS CONHECIMENTOS

                  -- [I] Validar regra de Reservista
                  ,CASE WHEN V.RESERVISTA = 0 OR V.RESERVISTA = E.RESERVISTA THEN 1 ELSE 0 END AS RESERVISTA

                  -- [E] CASO A VAGA PERMITA ESTUDANTE, NÃO PRECISA CHECAR NO ALUNO. CASO NÃO PERMITE, DEVE SER FEITA A CHECAGEM.
                  ,NULL AS FUMANTE

                  -- [E] SE A VAGA EXIGE CNH, O ESTUDANTE DEVE POSSUIR
                  ,NULL AS CNH

                  -- [E] SE A VAGA ESPECIFICOU UMA ESCOLA, O ESTUDANTE DEVE CONSTAR NELA
                  --PARA JOVEM APRENDIZ, DEVE SER REVISTA A REGRA POIS:
                  --  SE O ALUNO JÁ FOI CADASTRADO COM ENSINO SUPERIOR, NÃO PODE PARTICIPAR PARA VAGA DE APRENDIZ
                  , NULL AS ESCOLA

                  -- [I] Validar regra de tipos de deficiência
                  ,CASE WHEN
                                    V.PCDS IS NULL OR
                                    V.PCDS IS EMPTY OR
                                    (
                                        SELECT COUNT(1)
                                        FROM
                                            TABLE(E.PCDS) PE,
                                            TABLE(V.PCDS) PV
                                        WHERE
                                                PE.ID_CID_AGRUPADO = PV.ID_CID_AGRUPADO
                                    ) > 0
                            THEN 1 ELSE 0
                 END AS TIPO_DEFICIENCIA

                  -- [I] Validar regra de recurso de acessibilidade (Se a vaga possui, o usuário deve possuir)
                  ,CASE WHEN
                                    V.RECURSOS_ACESSIBILIDADE IS NULL OR
                                    V.RECURSOS_ACESSIBILIDADE IS EMPTY OR
                                    EXISTS
                                        (
                                            SELECT 1
                                            FROM
                                                TABLE(E.RECURSOS_ACESSIBILIDADE) ERA, TABLE(V.RECURSOS_ACESSIBILIDADE) VRA
                                            WHERE
                                                    ERA.COLUMN_VALUE = VRA.COLUMN_VALUE
                                        )
                            THEN 1 ELSE 0
                 END AS RECURSO_ACESSIBILIDADE

                  -- [I] Validar regra de validade do laudo
                  -- TODO validar se estudante deve ter laudo para todos os CIDs indicados na vaga ou somente um deles
                  -- TODO remover duplicatas de PCD em vagas
                  ,CASE WHEN
                                    V.PCDS IS NULL OR
                                    V.PCDS IS EMPTY OR
                                    (
                                        SELECT COUNT(1)
                                        FROM
                                            TABLE(E.PCDS) PE,
                                            TABLE(V.PCDS) PV
                                        WHERE
                                                PE.ID_CID_AGRUPADO = PV.ID_CID_AGRUPADO
                                          AND
                                            (
                                                        PV.VALIDADE_MINIMA_LAUDO is null
                                                    OR (PE.VALIDADE_MINIMA_LAUDO is null and PV.VALIDADE_MINIMA_LAUDO is null)
                                                    OR TRUNC(PE.VALIDADE_MINIMA_LAUDO) >= TRUNC(PV.VALIDADE_MINIMA_LAUDO)
                                                )
                                    ) > 0
                            THEN 1 ELSE 0 END
                 AS VALIDADE_LAUDO

                  -- [I] Validar regra de recurso de acessibilidade
                  ,CASE WHEN (V.EMPRESA_COM_ACESSIBILIDADE = 0 AND (E.USA_RECURSOS_ACESSIBILIDADE IS NULL OR E.USA_RECURSOS_ACESSIBILIDADE = 0)) THEN 1
                        WHEN (V.EMPRESA_COM_ACESSIBILIDADE = 1) THEN 1
                        ELSE 0
                 END AS OFERECE_ACESSIBILIDADE

                  -- [I] Validar Regra de cota PCD válida
                  ,CASE WHEN
                                    V.POSSUI_PCD = 0 OR V.VALIDO_COTA = E.ELEGIVEL_PCD THEN 1 ELSE 0
                 END AS VALIDO_COTA

                  -- [A] CÁLCULO DE DISTÂNCIA ENTRE O LOCAL DE ESTÁGIO E O LOCAL DE CAPACITAÇÃO
                  , CASE WHEN TIPO_VAGA = 'A' THEN
                             CASE WHEN
                                              NVL(V.LOCALIZACAO, 5) IN (1, 2, 3) OR
                                              (
                                                          NVL(V.LOCALIZACAO, 1) IN (0, 4, 5, 6)
                                                      AND EXISTS (SELECT 1 from TABLE (V.CAPACITACAO_GEOHASHS) E WHERE E.COLUMN_VALUE = E.ENDERECO_GEOHASH)
                                                  --AND SDO_GEOM.SDO_DISTANCE(V.CAPACITACAO, E.ENDERECO, 0.005, 'unit=km') < NVL(V.VALOR_RAIO, 20)
                                                  ) THEN 1 ELSE 0
                                 END
                         ELSE
                             NULL
                 END
                 AS DISTANCIA_CAPACITACAO
                  , V_QUEM_TRIOU AS QUEM_TRIOU
                  , 0 AS DELETADO
                  , sysdate AS DATA_CRIACAO
                  , sysdate AS DATA_ALTERACAO
                  , V_CRIADO_POR AS CRIADO_POR
                  , V_CRIADO_POR AS MODIFICADO_POR
                  , NULL AS PARAMETRO_ESCOLAR

                  -- Parâmetro de ordenação de vulnerável para vagas com priorização de atendimento a vulneráveis
                  ,NULL AS PRIORIZA_VULNERAVEL

                  -- [I] Validar regra de qualificação restritiva
                  ,CASE WHEN
                                    V.QUALIFICACOES IS NULL OR
                                    V.QUALIFICACOES IS EMPTY OR
                                    (
                                        SELECT COUNT(1)
                                        FROM
                                            TABLE(V.QUALIFICACOES) VQ,
                                            TABLE(E.QUALIFICACOES) EQ
                                        WHERE
                                                VQ.COLUMN_VALUE = EQ.ID_QUALIFICACAO
                                          AND EQ.RESULTADO = 0
                                          AND EQ.DATA_VALIDADE >= SYSDATE
                                    ) = CARDINALITY(V.QUALIFICACOES)
                            THEN 1 ELSE 0 END
                 AS QUALIFICACAO_RESTRITIVA

             FROM
                 SERVICE_VAGAS_DEV."TRIAGENS_VAGAS" V,
                 SERVICE_VAGAS_DEV."TRIAGENS_ESTUDANTES" E
             WHERE
                     V.CODIGO_DA_VAGA = V_CODIGO_DA_VAGA
               AND V.TIPO_VAGA = 'A'
               AND E.NIVEL_ENSINO <> 'SU'
               AND E.TIPO_PROGRAMA IN (1, 2)
               AND E.APTO_TRIAGEM = 1
               AND E.ENDERECO IS NOT NULL
               -- Regra antiga PCD
               AND ((V.POSSUI_PCD = 0 AND CARDINALITY(E.PCDS) = 0) OR (V.POSSUI_PCD = 1 AND CARDINALITY(E.PCDS) > 0))
               --AND (V.POSSUI_PCD = 0 OR (V.POSSUI_PCD = 1 AND EXISTS(SELECT 1 FROM TABLE(E.PCDS))))

               AND
                 (
                         EXISTS (SELECT 1 from TABLE (V.ENDERECO_GEOHASHS) CC WHERE CC.COLUMN_VALUE = E.ENDERECO_GEOHASH)
                         OR
                         (
                                     E.CURSO_EAD = 0 AND E.ENDERECO_CAMPUS_GEOHASH IS NOT NULL AND V.ENDERECO_GEOHASHS IS NOT NULL
                                 AND EXISTS (SELECT 1 from TABLE (V.ENDERECO_GEOHASHS) CC WHERE CC.COLUMN_VALUE = E.ENDERECO_CAMPUS_GEOHASH)
                             )
                         OR
                         (
                             EXISTS (SELECT 1 from TABLE (V.CAPACITACAO_GEOHASHS) CC WHERE CC.COLUMN_VALUE = E.ENDERECO_GEOHASH)
                             )
                     )

               AND NOT EXISTS (SELECT 1 from TABLE(E.VINCULOS) EV where V.CODIGO_DA_VAGA = EV.ID)

               AND NOT EXISTS(
                     select 1 from (SELECT trim(regexp_substr(V_IDS_EST_VINC, '[^,]+', 1, LEVEL)) id_est_vinculado
                                    FROM dual
                                    CONNECT BY regexp_substr(V_IDS_EST_VINC, '[^,]+', 1, LEVEL) IS NOT NULL)
                     where id_est_vinculado = e.id_estudante
                 )
             ORDER BY
                        -- ### SCORE ###
                        -- EFETUA O CÁLCULO DO SCORE PARA REALIZAR O ORDENAMENTO DA QUERY
                        (
                                SEXO + FAIXA_ETARIA + OFERECE_ACESSIBILIDADE +
                                --DISTANCIA_CASA + DISTANCIA_CAMPUS + DISTANCIA_CAPACITACAO +
                                VALIDADE_LAUDO + TIPO_DEFICIENCIA + QUALIFICACAO_RESTRITIVA
                                + RESERVISTA + RECURSO_ACESSIBILIDADE + VALIDO_COTA + HORARIO
                            ) DESC,

                        -- APLICA AS REGRAS DE ORDENAÇÃO DE ACORDO COM O TIPO DE VAGA
                        E.QUALIFICACAO_VULNERAVEL DESC,

                        -- QUANTIDADE DE CONCOCAÇÕES
                        E.QTD_CONVOCACOES

                        --Efetua a limitação na quantidade de linhas retornadas
                 OFFSET V_OFFSET ROWS FETCH NEXT V_NEXT ROWS ONLY
         ) T
    where T.DISTANCIA_CASA+T.DISTANCIA_CAMPUS+T.HORARIO+T.SEXO+T.FAIXA_ETARIA+T.RESERVISTA+T.TIPO_DEFICIENCIA+T.RECURSO_ACESSIBILIDADE+T.VALIDADE_LAUDO+T.OFERECE_ACESSIBILIDADE+T.VALIDO_COTA+T.DISTANCIA_CAPACITACAO < 12;
END;