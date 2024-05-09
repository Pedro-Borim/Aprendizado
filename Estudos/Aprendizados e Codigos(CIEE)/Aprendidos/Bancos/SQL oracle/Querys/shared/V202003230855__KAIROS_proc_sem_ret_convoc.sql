CREATE OR REPLACE PROCEDURE PROC_CLASSIFICACOES_ESTUDANTES_SEM_RET_CONVOC
(
    P_LISTA_ESTUDANTE IN IDS_TYP,
    P_ID_ITEM IN NUMBER,
    P_FAIXA IN VARCHAR2,
    P_PERIODO IN NUMBER,
    P_PONTOS IN NUMBER,
    P_ERRO OUT NUMBER
) AS

    V_RETORNO NUMBER;
    V_DATA TIMESTAMP;
    V_DATA_INICIAL TIMESTAMP;

    V_INICIO_PROCESSO TIMESTAMP;
    V_PROCEDURE VARCHAR2(255 CHAR) := $$PLSQL_UNIT;
    V_MENSAGEM VARCHAR2(4000 CHAR);
BEGIN
    V_INICIO_PROCESSO := CURRENT_TIMESTAMP;

    MERGE INTO CLASSIFICACOES_ESTUDANTES_ANALITICO A
        USING (
        SELECT T.ID_ESTUDANTE FROM (SELECT
            V.ID_ESTUDANTE AS ID_ESTUDANTE,
            COUNT(V.ID_ESTUDANTE) AS QTD

        FROM VINCULOS_VAGA V
        WHERE
            V.ID_ESTUDANTE IN( (SELECT COLUMN_VALUE ID_ESTUDANTE FROM TABLE(P_LISTA_ESTUDANTE)) )
            AND V.SITUACAO_VINCULO = 0
            AND V.TIPO_COMUNICACAO_CONVOCACAO IS NOT NULL
            AND V.DELETADO = 0
            AND V.DATA_CRIACAO < (SYSDATE - 3)
            AND ( DATEDIFF('DD', V.DATA_CRIACAO, SYSDATE) >= 0 )
            AND ( DATEDIFF('DD', V.DATA_CRIACAO, SYSDATE) <= P_PERIODO )
        GROUP BY V.ID_ESTUDANTE) T
        WHERE FUNC_INTERPRETAR_EXPRESSAO(REPLACE(P_FAIXA, '$', T.QTD)) = 1
    ) B
        ON (A.ID_ESTUDANTE = B.ID_ESTUDANTE)
        WHEN MATCHED THEN UPDATE SET A.PONTUACAO_ATUAL = P_PONTOS, A.DATA_ALTERACAO = CURRENT_TIMESTAMP
        WHEN NOT MATCHED THEN INSERT (
                A.ID,
                A.DATA_CRIACAO,
                A.DATA_ALTERACAO,
                A.CRIADO_POR,
                A.MODIFICADO_POR,
                A.DELETADO,
                A.PONTUACAO_ATUAL,
                A.ID_CLASSIFICACAO_PARAMETROS_ITEN,
                A.ID_ESTUDANTE
            )
            VALUES (
                SEQ_CLASSIFICACOES_ESTUDANTES_ANALITICO.NEXTVAL,
                CURRENT_TIMESTAMP,
                CURRENT_TIMESTAMP,
                'PROC_CLASSIFICACOES_ESTUDANTES_SEM_RET_CONVOC',
                'PROC_CLASSIFICACOES_ESTUDANTES_SEM_RET_CONVOC',
                0,
                P_PONTOS,
                P_ID_ITEM,
                B.ID_ESTUDANTE
            );

EXCEPTION
    WHEN OTHERS THEN
        P_ERRO := 1;
        V_MENSAGEM := SQLERRM;


INSERT INTO CLASSIFICACOES_ESTUDANTES_LOG (ID, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR, DELETADO,
    IDS_ESTUDANTES, ID_CLASSIFICACOES_PARAMETROS_ITENS, INICIO_PROCESSO, FIM_PROCESSO, MENSAGEM)
VALUES (SEQ_CLASSIFICACOES_ESTUDANTES_LOG.NEXTVAL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
        V_PROCEDURE,V_PROCEDURE,0,
        P_LISTA_ESTUDANTE, P_ID_ITEM, V_INICIO_PROCESSO, CURRENT_TIMESTAMP, V_MENSAGEM);
END;