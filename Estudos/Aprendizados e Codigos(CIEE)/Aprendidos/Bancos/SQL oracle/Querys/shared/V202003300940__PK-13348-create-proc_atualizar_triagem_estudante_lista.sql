create or replace PROCEDURE {{user}}.proc_atualizar_triagem_estudante_lista (
    V_IDS_ESTUDANTES IN IDS_TYP DEFAULT NULL
)
AS
    l_query  CLOB;
BEGIN

    l_query := 'MERGE INTO {{user}}.TRIAGENS_ESTUDANTES D
        USING
        (SELECT
        EST.ID "ID_ESTUDANTE",
        ENDER.GEO_POINT "ENDERECO",
        {{user}}.GEOHASH_ENCODE(
        SDO_GEOM.SDO_CENTROID(ENDER.GEO_POINT, 0.05).sdo_point.y,
        SDO_GEOM.SDO_CENTROID(ENDER.GEO_POINT, 0.05).sdo_point.x, 4
        ) as ENDERECO_GEOHASH,
        --A funcao nativa retorna nulo em alguns momentos
        --SDO_CS.TO_GEOHASH(ENDER.GEO_POINT, 4) as "ENDERECO_GEOHASH",

        ESCOL.GEO_POINT "ENDERECO_CAMPUS",

        {{user}}.GEOHASH_ENCODE(
        SDO_GEOM.SDO_CENTROID(ESCOL.GEO_POINT, 0.05).sdo_point.y,
        SDO_GEOM.SDO_CENTROID(ESCOL.GEO_POINT, 0.05).sdo_point.x, 4
        ) as ENDERECO_CAMPUS_GEOHASH,
        --A funcao nativa retorna nulo em alguns momentos
        --SDO_CS.TO_GEOHASH(ESCOL.GEO_POINT, 4) as "ENDERECO_CAMPUS_GEOHASH",

        EST.DATA_NASCIMENTO "DATA_NASCIMENTO",

        -- ### Estado Civil ###
        case
        when EST.ESTADO_CIVIL = ''SOLTEIRO'' then 1
        when EST.ESTADO_CIVIL = ''CASADO'' then 2
        when EST.ESTADO_CIVIL = ''SEPARADO'' then 3
        when EST.ESTADO_CIVIL = ''DIVORCIADO'' then 4
        when EST.ESTADO_CIVIL = ''VIUVO'' then 5
        end "ESTADO_CIVIL",
        case when EST.SEXO = ''FEMININO'' then ''F'' ELSE ''M'' end "SEXO",
        NVL(EST.USA_RECURSOS_ACESSIBILIDADE, 0) "USA_RECURSOS_ACESSIBILIDADE",
        NVL(EST.ELEGIVEL_PCD, 0) "ELEGIVEL_PCD",
        NVL(INFO.RESERVISTA, 0) "RESERVISTA",
        NVL(INFO.FUMANTE, 0) "FUMANTE",
        NVL(INFO.CNH, 0) "CNH",
        --2020-03-20
        NVL(INFO.ID_GENERO, 0) "GENERO",
        NVL(INFO.ID_ETNIA, 0) "ETNIA",
        ESCOL.TIPO_DURACAO_CURSO "TIPO_DURACAO_CURSO",

        -- ### Semestre ###
        NVL(CASE
        WHEN STATUS_ESCOLARIDADE = ''CURSANDO'' THEN CONVERSAO_SEMESTRE(PERIODO_ATUAL, TIPO_DURACAO_CURSO)
        WHEN STATUS_ESCOLARIDADE = ''INTERROMPIDO'' THEN CONVERSAO_SEMESTRE(ULTIMO_PERIODO_CURSADO, TIPO_DURACAO_CURSO)
        WHEN STATUS_ESCOLARIDADE = ''CONCLUIDO'' THEN CONVERSAO_SEMESTRE(DURACAO_CURSO, TIPO_DURACAO_CURSO, 1)
        END, -1) SEMESTRE,

        -- ### Data Conclusao ###
        LAST_DAY(TRUNC(CASE
        WHEN STATUS_ESCOLARIDADE = ''CURSANDO'' THEN ESCOL.DATA_CONCLUSAO_CALCULADA
        WHEN STATUS_ESCOLARIDADE = ''CONCLUIDO'' THEN ESCOL.DATA_CONCLUSAO
        ELSE NULL
        END, ''MON'')) "DATA_CONCLUSAO_CURSO",

        ESCOL.DURACAO_CURSO "DURACAO_CURSO",
        ESCOL.PERIODO_ATUAL "PERIODO_ATUAL",
        ESCOL.TIPO_PERIODO_CURSO "TIPO_PERIODO_CURSO",
        CURS.MODALIDADE "MODALIDADE",

        -- ### Horario Entrada ###
        case
        when CURS.MODALIDADE = ''P'' AND ESCOL.TIPO_PERIODO_CURSO = ''Manhã'' then TO_DATE(''19700101 08:00'', ''yyyymmdd hh24:mi'')
        when CURS.MODALIDADE = ''P'' AND ESCOL.TIPO_PERIODO_CURSO = ''Tarde'' then TO_DATE(''19700101 13:00'', ''yyyymmdd hh24:mi'')
        when CURS.MODALIDADE = ''P'' AND ESCOL.TIPO_PERIODO_CURSO = ''Noite'' then TO_DATE(''19700101 18:00'', ''yyyymmdd hh24:mi'')
        when CURS.MODALIDADE = ''P'' AND ESCOL.TIPO_PERIODO_CURSO = ''Integral'' then TO_DATE(''19700101 08:00'', ''yyyymmdd hh24:mi'')
        when CURS.MODALIDADE = ''P'' AND ESCOL.TIPO_PERIODO_CURSO = ''Vespertino'' then TO_DATE(''19700101 17:00'', ''yyyymmdd hh24:mi'')
        else null
        end "HORARIO_ENTRADA",

        -- ### Horario Saida ###
        case
        when CURS.MODALIDADE = ''P'' AND ESCOL.TIPO_PERIODO_CURSO = ''Manhã'' then TO_DATE(''19700101 12:00'', ''yyyymmdd hh24:mi'')
        when CURS.MODALIDADE = ''P'' AND ESCOL.TIPO_PERIODO_CURSO = ''Tarde'' then TO_DATE(''19700101 17:00'', ''yyyymmdd hh24:mi'')
        when CURS.MODALIDADE = ''P'' AND ESCOL.TIPO_PERIODO_CURSO = ''Noite'' then TO_DATE(''19700101 22:00'', ''yyyymmdd hh24:mi'')
        when CURS.MODALIDADE = ''P'' AND ESCOL.TIPO_PERIODO_CURSO = ''Integral'' then TO_DATE(''19700101 17:00'', ''yyyymmdd hh24:mi'')
        when CURS.MODALIDADE = ''P'' AND ESCOL.TIPO_PERIODO_CURSO = ''Vespertino'' then TO_DATE(''19700101 21:00'', ''yyyymmdd hh24:mi'')
        else null
        end "HORARIO_SAIDA",

        -- ### Escolas ###

        (
        SELECT
        cast(collect(ESC.ID_ESCOLA) as {{user}}.IDS_TYP)
        FROM
        {{user}}.REP_ESCOLARIDADES_ESTUDANTES ESC
        WHERE ESC.ID_ESTUDANTE = EST.ID AND ESC.DELETADO = ''0''
        ) "ESCOLAS",


        -- ### Cursos ###
        (
        SELECT
        cast(collect(CAST(ESC.ID_CURSO AS NUMBER(19,0))) as {{user}}.IDS_TYP)
        FROM
        {{user}}.REP_ESCOLARIDADES_ESTUDANTES ESC
        WHERE ESC.ID_ESTUDANTE = EST.ID AND ESC.DELETADO = ''0''
        ) "CURSOS",


        -- ### Vinculos ###
        (
        SELECT
        CAST(COLLECT(
        {{user}}.VINCULO_TYP(
        VV.CODIGO_VAGA,
        VV.SITUACAO_VINCULO)
        ) AS {{user}}.VINCULOS_TYP)
        from {{user}}.VINCULOS_VAGA VV
        LEFT JOIN {{user}}.VINCULOS_CONVOCACAO VC on VV.ID = VC.ID_VINCULO
        WHERE VV.ID_ESTUDANTE = EST.ID AND VV.DELETADO = ''0''
        AND VC.ID IS NULL OR (VC.DATA_LIBERACAO_CONVOCACAO IS NOT NULL AND VC.ID_RECUSA IS NULL)) VINCULOS,

        -- ### Idiomas ###

        (
        SELECT
        CAST(COLLECT(
        {{user}}.IDIOMA_TYP(
        RIN.ID,
        CASE RIN.IDIOMA
        WHEN ''ALEMÃO'' THEN ''ALEMAO''
        WHEN ''ESPANHOL'' THEN ''ESPANHOL''
        WHEN ''FRANCÊS'' THEN ''FRANCES''
        WHEN ''INGLÊS'' THEN ''INGLES''
        WHEN ''ITALIANO'' THEN ''ITALIANO''
        WHEN ''JAPONÊS'' THEN ''JAPONES''
        END,
        CASE WHEN NIVEL = ''BÁSICO'' THEN 10
        WHEN NIVEL = ''INTERMEDIÁRIO'' THEN 20
        ELSE 30
        END,
        CASE WHEN RIN.DOCUMENTO_ID IS NULL THEN 0 ELSE 1 END)
        ) AS {{user}}.IDIOMAS_TYP)
        from {{user}}.REP_IDIOMAS_NIVEIS RIN
        WHERE RIN.ESTUDANTE_ID = EST.ID AND RIN.DELETADO = ''0''
        ) "IDIOMAS",

        -- ### Conhecimentos ###
        (
        SELECT
        CAST(COLLECT(
        {{user}}.CONHECIMENTO_TYP(RCI.TIPO_CONHECIMENTO,
        CASE WHEN NIVEL_CONHECIMENTO = ''BASICO'' THEN 10
        WHEN NIVEL_CONHECIMENTO = ''INTERMEDIARIO'' THEN 20
        ELSE 30
        END,
        CASE WHEN RCI.ID_DOCUMENTO IS NULL THEN 0 ELSE 1 END)
        ) AS {{user}}.CONHECIMENTOS_TYP)
        from {{user}}.REP_CONHECIMENTOS_INFORMATICA RCI
        WHERE RCI.ID_ESTUDANTE = EST.ID AND RCI.DELETADO = ''0''
        ) "CONHECIMENTOS",

        -- ### Recursos Acessibilidade ###
        (SELECT
        CAST(COLLECT(REC.APARELHO_ID) AS {{user}}.IDS_TYP)
        from {{user}}.REP_RECURSOS_ACESSIBILIDADE REC
        WHERE REC.ESTUDANTE_ID = EST.ID AND REC.DELETADO = ''0'') RECURSOS_ACESSIBILIDADE,
        EST.USA_RECURSOS_ACESSIBILIDADE "USA_RECURSO_ACESSIBILIDADE",


        -- ### PCD ###
        (
        SELECT
        CAST(COLLECT(
        {{user}}.PCD_ESTUDANTE_TYP(
        LM.ID_CID_AGRUPADO,
        MAX(LMD.DATA_VENCIMENTO),
        CASE LMD.STATUS
        WHEN ''VALIDO'' THEN 1
        WHEN ''INVALIDO'' THEN 2
        WHEN ''VENCIDO'' THEN 3
        WHEN ''PENDENTE'' THEN 4
        END,
        LM.PRINCIPAL)
        ) AS {{user}}.PCDS_ESTUDANTE_TYP)
        from {{user}}.REP_LAUDOS_MEDICOS LM
        INNER JOIN {{user}}.REP_LAUDOS_MEDICOS_DOCUMENTOS LMD on LM.ID = LMD.LAUDO_MEDICO_ID
        WHERE LM.deletado = ''0'' and LMD.DELETADO = ''0'' AND LM.ESTUDANTE_ID = EST.ID
        GROUP BY LM.ID, LM.ID_CID_AGRUPADO, LMD.STATUS, LM.PRINCIPAL
        ) PCDs,


        -- ### Vencimento Laudo ###
        (
        SELECT MAX(DATA_VENCIMENTO)
        FROM {{user}}.REP_LAUDOS_MEDICOS_DOCUMENTOS LMD
        INNER JOIN {{user}}.REP_LAUDOS_MEDICOS RLM on LMD.LAUDO_MEDICO_ID = RLM.ID
        where RLM.ESTUDANTE_ID = EST.ID AND LMD.STATUS = ''VALIDO'' AND RLM.PRINCIPAL = 1
        AND RLM.DELETADO = ''0'' AND LMD.DELETADO = ''0''
        ) VENCIMENTO_LAUDO,

        -- ### Vulneravel ###
        CASE
        WHEN QE.ID IS NOT NULL THEN 1
        ELSE 0
        END "QUALIFICACAO_VULNERAVEL",

        -- ### Tipo Programa ###
        CASE
        WHEN EST.TIPO_PROGRAMA = ''ESTAGIO'' THEN 0
        WHEN EST.TIPO_PROGRAMA = ''APRENDIZ'' THEN 1
        WHEN EST.TIPO_PROGRAMA = ''ESTAGIO+APRENDIZ'' THEN 2
        ELSE 3
        END "TIPO_PROGRAMA",

        -- ### Situacao Escolaridade ###
        CASE WHEN ESCOL.STATUS_ESCOLARIDADE = ''CURSANDO'' THEN 0
        WHEN ESCOL.STATUS_ESCOLARIDADE = ''CONCLUIDO'' THEN 1
        ELSE 2
        END "STATUS_ESCOLARIDADE",

        -- ### Qualificacoes ###
        (
        SELECT
        CAST(COLLECT(
        {{user}}.QUALIFICACAO_TYP(
        QE.ID,
        QE.RESULTADO,
        QE.DATA_VALIDADE)
        ) AS {{user}}.QUALIFICACOES_TYP)
        from {{user}}.QUALIFICACOES_ESTUDANTE QE
        WHERE QE.ID_ESTUDANTE = EST.ID AND QE.DELETADO = ''0''
        ) QUALIFICACOES,
        ESCOL.SIGLA_NIVEL_EDUCACAO "NIVEL_CURSO",


        -- ### Contratos Estudante Empresa ###
        (
        select CAST(COLLECT({{user}}.CONTRATO_EMP_TYP(ID, ID_EMPRESA, SITUACAO, TIPO_CONTRATO)) AS {{user}}.CONTRATOS_EMP_TYP)
        from {{user}}.CONTRATOS_ESTUDANTES_EMPRESA
        where ID_ESTUDANTE = EST.ID
        ) "CONTRATOS_EMPRESA",

        CASE WHEN CURS.MODALIDADE = ''P'' THEN 0 ELSE 1 END "CURSO_EAD",
        (
        SELECT
        COUNT(1)
        from {{user}}.VINCULOS_VAGA VV
        LEFT JOIN {{user}}.VINCULOS_CONVOCACAO VC on VV.ID = VC.ID_VINCULO
        WHERE VV.ID_ESTUDANTE = EST.ID AND VV.DELETADO = ''0''
        AND VC.ID IS NULL OR (VC.DATA_LIBERACAO_CONVOCACAO IS NOT NULL AND VC.ID_RECUSA IS NULL)) QTD_CONVOCACOES
        ,
        case when EST.VIDEO_URL IS NULL THEN 0 ELSE 1 END POSSUI_VIDEO,
        CASE
        WHEN EST.SITUACAO = ''ATIVO'' THEN 0
        WHEN EST.SITUACAO = ''INATIVO'' THEN 1
        WHEN EST.SITUACAO = ''BLOQUEADO'' THEN 2
        END SITUACAO,
        EST.NOME,
        CODIGO_ESTUDANTE,
        CPF,
        CASE
        WHEN SITUACAO_ANALISE_PCD = ''PENDENTE'' THEN 0
        WHEN SITUACAO_ANALISE_PCD = ''ANALISANDO'' THEN 1
        WHEN SITUACAO_ANALISE_PCD = ''ANALISADO'' THEN 2
        WHEN SITUACAO_ANALISE_PCD = ''APROVADO'' THEN 3
        END SITUACAO_ANALISE_PCD,
        RESP.ID ID_RESPONSAVEL,
        RESP.NOME_MAE,
        (
        SELECT CAST(COLLECT({{user}}.ENDERECO_TYP(
        UF,
        CIDADE,
        ENDERECO,
        NUMERO,
        COMPLEMENTO,
        CEP,
        PRINCIPAL
        )) AS {{user}}.ENDERECOS_TYP) FROM REP_ENDERECOS_ESTUDANTES where ID_ESTUDANTE = EST.ID
        ) ENDERECOS,
        (
        SELECT CAST(COLLECT(email) AS {{user}}.EMAILS_TYP)
        FROM REP_EMAILS where ID_ESTUDANTE = EST.ID
        ) EMAILS,
        (
        SELECT CAST(COLLECT(telefone) AS {{user}}.TELEFONES_TYP)
        FROM REP_TELEFONES where ID_ESTUDANTE = EST.ID
        ) TELEFONES,
        (
        SELECT CAST(COLLECT(NOME_EMPRESA) AS {{user}}.EXPERIENCIAS_PROFISSIONAIS_TYP)
        FROM REP_EXPERIENCIAS_PROFISSIONAIS_STUDENT where ID_ESTUDANTE = EST.ID
        ) EXPERIENCIAS_PROFISSIONAIS,
        (
        SELECT CAST(COLLECT(NOME_CURSO) AS {{user}}.CONHECIMENTOS_DIVERSOS_TYP)
        FROM REP_CONHECIMENTOS_DIVERSOS_STUDENT where ID_ESTUDANTE = EST.ID
        ) CONHECIMENTOS_DIVERSOS,
        CASE
        WHEN EXISTS (SELECT 1 from REP_REDACOES_STUDENT RRS WHERE RRS.ID_ESTUDANTE = EST.ID AND CONTEUDO IS NOT NULL)
        THEN 1
        ELSE 0
        END POSSUI_REDACAO,
        (
        SELECT CAST(COLLECT({{user}}.AREA_PROFISSIONAL_TYP(
        AP.CODIGO_AREA_PROFISSIONAL,
        AP.DESCRICAO_AREA_PROFISSIONAL,
        AP.DESC_REDUZ_AREA_PROFISSIONAL,
        AP.CODIGO_ICONE
        )) AS {{user}}.AREAS_PROFISSIONAL_TYP)
        FROM (select DISTINCT RAPR.*
        FROM REP_AREAS_PROFISSIONAIS RAPR
        INNER JOIN REP_AREAS_PROFISSIONAL_ATUACAO RAPRA ON RAPR.CODIGO_AREA_PROFISSIONAL = RAPRA.CODIGO_AREA_PROFISSIONAL
        INNER JOIN REP_AREAS_ATUACAO_CURSOS RAAC ON RAAC.CODIGO_AREA_ATUACAO = RAPRA.CODIGO_AREA_ATUACAO
        where RAAC.CODIGO_CURSO = ESCOL.ID_CURSO) AP
        ) AREAS_PROFISSIONAIS,
        NVL(CEC.CLASSIFICACAO_OBTIDA, ''C'') CLASSIFICACAO_OBTIDA,
        NVL(CEC.PONTUACAO_OBTIDA, 0) PONTUACAO_OBTIDA,
        case when (EST.SITUACAO = ''ATIVO''
        AND ENDER.PRINCIPAL = 1
        AND ESCOL.PRINCIPAL = 1
        AND (Q.ID IS NULL OR Q.NOME = ''Vulnerável'')
        AND EST.DELETADO = ''0''
        AND ENDER.DELETADO = ''0''
        AND ESCOL.DELETADO = ''0''
        AND (INFO.DELETADO IS NULL OR INFO.DELETADO = ''0'')
        AND CURS.DELETADO = ''0''
        AND (QE.DELETADO IS NULL OR QE.DELETADO = ''0'')
        AND (Q.DELETADO IS NULL OR Q.DELETADO = ''0'')) then 1 else 0 end APTO_TRIAGEM
        FROM
        {{user}}.REP_ESTUDANTES EST
        INNER JOIN {{user}}.REP_ENDERECOS_ESTUDANTES ENDER on EST.ID = ENDER.ID_ESTUDANTE
        INNER JOIN {{user}}.REP_ESCOLARIDADES_ESTUDANTES ESCOL on EST.ID = ESCOL.ID_ESTUDANTE
        LEFT JOIN {{user}}.REP_INFORMACOES_ADICIONAIS INFO ON INFO.ID = EST.ID_INFORMACOES_ADICIONAIS
        INNER JOIN {{user}}.REP_CURSOS CURS ON ESCOL.ID_CURSO = CURS.CODIGO_CURSO
        LEFT JOIN {{user}}.QUALIFICACOES_ESTUDANTE QE on EST.ID = QE.ID_ESTUDANTE
        LEFT JOIN {{user}}.QUALIFICACAO Q on QE.ID_QUALIFICACAO = Q.ID
        LEFT JOIN {{user}}.REP_RESPONSAVEIS RESP ON EST.ID_RESPONSAVEL = RESP.ID
        LEFT JOIN {{user}}.CLASSIFICACOES_ESTUDANTES_CONSOLIDADO CEC ON CEC.ID_ESTUDANTE = EST.ID
        WHERE
        --Filtra pelos estudantes que devem ser atualizados
';

        if (V_IDS_ESTUDANTES IS EMPTY OR V_IDS_ESTUDANTES IS NULL) THEN
            l_query := l_query || ':V_IDS_ESTUDANTES IS NULL';
        else
            l_query := l_query || 'EST.ID IN (select COLUMN_VALUE from table(:V_IDS_ESTUDANTES))';
        end if;

        l_query := l_query || '
        AND ENDER.PRINCIPAL = 1
        AND ESCOL.PRINCIPAL = 1
        AND (Q.ID IS NULL OR Q.NOME = ''Vulnerável'')
        AND EST.DELETADO = ''0''
        AND ENDER.DELETADO = ''0''
        AND ESCOL.DELETADO = ''0''
        AND (INFO.DELETADO IS NULL OR INFO.DELETADO = ''0'')
        AND CURS.DELETADO = ''0''
        AND (QE.DELETADO IS NULL OR QE.DELETADO = ''0'')
        AND (Q.DELETADO IS NULL OR Q.DELETADO = ''0'')
        ) S
        ON (D.ID_ESTUDANTE = S.ID_ESTUDANTE)
    WHEN NOT MATCHED THEN
    INSERT
        (D.ID_ESTUDANTE
            ,D.ENDERECO
            ,D.ENDERECO_GEOHASH
            ,D.ENDERECO_CAMPUS
            ,D.ENDERECO_CAMPUS_GEOHASH
            ,D.DATA_NASCIMENTO
            ,D.ESTADO_CIVIL
            ,D.SEXO
            ,D.USA_RECURSOS_ACESSIBILIDADE
            ,D.ELEGIVEL_PCD
            ,D.RESERVISTA
            ,D.FUMANTE
            ,D.CNH
            ,D.GENERO
            ,D.ETNIA
            ,D.TIPO_DURACAO_CURSO
            ,D.SEMESTRE
            ,D.DATA_CONCLUSAO_CURSO
            ,D.DURACAO_CURSO
            ,D.PERIODO_ATUAL
            ,D.TIPO_PERIODO_CURSO
            ,D.MODALIDADE
            ,D.HORARIO_ENTRADA
            ,D.HORARIO_SAIDA
            ,D.ESCOLAS
            ,D.CURSOS
            ,D.VINCULOS
            ,D.IDIOMAS
            ,D.CONHECIMENTOS
            ,D.RECURSOS_ACESSIBILIDADE
            ,D.USA_RECURSO_ACESSIBILIDADE
            ,D.PCDS
            ,D.VENCIMENTO_LAUDO
            ,D.QUALIFICACAO_VULNERAVEL
            ,D.TIPO_PROGRAMA
            ,D.STATUS_ESCOLARIDADE
            ,D.QUALIFICACOES
            ,D.NIVEL_ENSINO
            ,D.CONTRATOS_EMPRESA
            ,D.QTD_CONVOCACOES
            ,D.DATA_ALTERACAO
            ,D.POSSUI_VIDEO
            ,D.SITUACAO
            ,D.NOME
            ,D.CODIGO_ESTUDANTE
            ,D.CPF
            ,D.SITUACAO_ANALISE_PCD
            ,D.ID_RESPONSAVEL
            ,D.NOME_MAE
            ,D.ENDERECOS
            ,D.EMAILS
            ,D.TELEFONES
            ,D.EXPERIENCIAS_PROFISSIONAIS
            ,D.CONHECIMENTOS_DIVERSOS
            ,D.POSSUI_REDACAO
            ,D.AREAS_PROFISSIONAL
            ,D.CLASSIFICACAO_OBTIDA
            ,D.PONTUACAO_OBTIDA
            ,D.APTO_TRIAGEM
        )
        VALUES
    (S.ID_ESTUDANTE
        ,S.ENDERECO
        ,S.ENDERECO_GEOHASH
        ,S.ENDERECO_CAMPUS
        ,S.ENDERECO_CAMPUS_GEOHASH
        ,S.DATA_NASCIMENTO
        ,S.ESTADO_CIVIL
        ,S.SEXO
        ,S.USA_RECURSOS_ACESSIBILIDADE
        ,S.ELEGIVEL_PCD
        ,S.RESERVISTA
        ,S.FUMANTE
        ,S.CNH
        ,S.GENERO
        ,S.ETNIA
        ,S.TIPO_DURACAO_CURSO
        ,S.SEMESTRE
        ,S.DATA_CONCLUSAO_CURSO
        ,S.DURACAO_CURSO
        ,S.PERIODO_ATUAL
        ,S.TIPO_PERIODO_CURSO
        ,S.MODALIDADE
        ,S.HORARIO_ENTRADA
        ,S.HORARIO_SAIDA
        ,S.ESCOLAS
        ,S.CURSOS
        ,S.VINCULOS
        ,S.IDIOMAS
        ,S.CONHECIMENTOS
        ,S.RECURSOS_ACESSIBILIDADE
        ,S.USA_RECURSO_ACESSIBILIDADE
        ,S.PCDS
        ,S.VENCIMENTO_LAUDO
        ,S.QUALIFICACAO_VULNERAVEL
        ,S.TIPO_PROGRAMA
        ,S.STATUS_ESCOLARIDADE
        ,S.QUALIFICACOES
        ,S.NIVEL_CURSO
        ,S.CONTRATOS_EMPRESA
        ,S.QTD_CONVOCACOES
        ,sysdate
        ,S.POSSUI_VIDEO
        ,S.SITUACAO
        ,S.NOME
        ,S.CODIGO_ESTUDANTE
        ,S.CPF
        ,S.SITUACAO_ANALISE_PCD
        ,S.ID_RESPONSAVEL
        ,S.NOME_MAE
        ,S.ENDERECOS
        ,S.EMAILS
        ,S.TELEFONES
        ,S.EXPERIENCIAS_PROFISSIONAIS
        ,S.CONHECIMENTOS_DIVERSOS
        ,S.POSSUI_REDACAO
        ,S.AREAS_PROFISSIONAIS
        ,S.CLASSIFICACAO_OBTIDA
        ,S.PONTUACAO_OBTIDA
        , S.APTO_TRIAGEM
        )
    WHEN MATCHED THEN
    UPDATE SET
        D.ENDERECO = S.ENDERECO
        , D.ENDERECO_GEOHASH = S.ENDERECO_GEOHASH
        , D.ENDERECO_CAMPUS = S.ENDERECO_CAMPUS
        , D.ENDERECO_CAMPUS_GEOHASH = S.ENDERECO_CAMPUS_GEOHASH
        , D.DATA_NASCIMENTO = S.DATA_NASCIMENTO
        , D.ESTADO_CIVIL = S.ESTADO_CIVIL
        , D.SEXO = S.SEXO
        , D.USA_RECURSOS_ACESSIBILIDADE = S.USA_RECURSOS_ACESSIBILIDADE
        , D.ELEGIVEL_PCD = S.ELEGIVEL_PCD
        , D.RESERVISTA = S.RESERVISTA
        , D.FUMANTE = S.FUMANTE
        , D.CNH = S.CNH
        , D.GENERO = S.GENERO
        , D.ETNIA = S.ETNIA
        , D.TIPO_DURACAO_CURSO = S.TIPO_DURACAO_CURSO
        , D.SEMESTRE = S.SEMESTRE
        , D.DATA_CONCLUSAO_CURSO = S.DATA_CONCLUSAO_CURSO
        , D.DURACAO_CURSO = S.DURACAO_CURSO
        , D.PERIODO_ATUAL = S.PERIODO_ATUAL
        , D.TIPO_PERIODO_CURSO = S.TIPO_PERIODO_CURSO
        , D.MODALIDADE = S.MODALIDADE
        , D.HORARIO_ENTRADA = S.HORARIO_ENTRADA
        , D.HORARIO_SAIDA = S.HORARIO_SAIDA
        , D.ESCOLAS = S.ESCOLAS
        , D.CURSOS = S.CURSOS
        , D.VINCULOS = S.VINCULOS
        , D.IDIOMAS = S.IDIOMAS
        , D.CONHECIMENTOS = S.CONHECIMENTOS
        , D.RECURSOS_ACESSIBILIDADE = S.RECURSOS_ACESSIBILIDADE
        , D.USA_RECURSO_ACESSIBILIDADE = S.USA_RECURSO_ACESSIBILIDADE
        , D.PCDS = S.PCDS
        , D.VENCIMENTO_LAUDO = S.VENCIMENTO_LAUDO
        , D.QUALIFICACAO_VULNERAVEL = S.QUALIFICACAO_VULNERAVEL
        , D.TIPO_PROGRAMA = S.TIPO_PROGRAMA
        , D.STATUS_ESCOLARIDADE = S.STATUS_ESCOLARIDADE
        , D.QUALIFICACOES = S.QUALIFICACOES
        , D.NIVEL_ENSINO = S.NIVEL_CURSO
        , D.CONTRATOS_EMPRESA = S.CONTRATOS_EMPRESA
        , D.QTD_CONVOCACOES = S.QTD_CONVOCACOES
        , D.DATA_ALTERACAO = sysdate
        , D.POSSUI_VIDEO = S.POSSUI_VIDEO
        , D.SITUACAO = S.SITUACAO
        , D.NOME = S.NOME
        , D.CODIGO_ESTUDANTE = S.CODIGO_ESTUDANTE
        , D.CPF = S.CPF
        , D.SITUACAO_ANALISE_PCD = S.SITUACAO_ANALISE_PCD
        , D.ID_RESPONSAVEL = S.ID_RESPONSAVEL
        , D.NOME_MAE = S.NOME_MAE
        , D.ENDERECOS = S.ENDERECOS
        , D.EMAILS = S.EMAILS
        , D.TELEFONES = S.TELEFONES
        , D.EXPERIENCIAS_PROFISSIONAIS = S.EXPERIENCIAS_PROFISSIONAIS
        , D.CONHECIMENTOS_DIVERSOS = S.CONHECIMENTOS_DIVERSOS
        , D.POSSUI_REDACAO = S.POSSUI_REDACAO
        , D.AREAS_PROFISSIONAL = S.AREAS_PROFISSIONAIS
        , D.CLASSIFICACAO_OBTIDA = S.CLASSIFICACAO_OBTIDA
        , D.PONTUACAO_OBTIDA = S.PONTUACAO_OBTIDA
        , D.APTO_TRIAGEM = S.APTO_TRIAGEM
    ';
    
    EXECUTE IMMEDIATE l_query USING V_IDS_ESTUDANTES;
END;
/