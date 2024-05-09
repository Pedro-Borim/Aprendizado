--A view estava fazendo join com um atributo errado do estudante

CREATE OR REPLACE VIEW SERVICE_VAGAS_DEV.V_DADOS_ESTUDANTES
(ID,NOME,NOME_SOCIAL,RG,CPF,DATA_NASCIMENTO,SEXO,ENDERECO,NUMERO,BAIRRO,CIDADE,UF,CEP,PCD,CONTATO_PCD)
AS
SELECT a.id,
    a.nome,
    a.nome_social,
    h.rg,
    a.cpf,
    a.data_nascimento,
    a.sexo,
    c.endereco,
    c.numero,
    c.bairro,
    c.cidade,
    c.uf,
    c.cep,
    a.pcd,
    CASE WHEN a.pcd = 1 THEN f.nome_responsavel_legal ELSE null END AS contato_pcd

FROM rep_estudantes a
    JOIN rep_enderecos_estudantes c ON c.id_estudante = a.id
    LEFT JOIN rep_responsaveis f ON f.id = a.id_responsavel
    LEFT JOIN rep_informacoes_nacionalidade g ON g.id = a.ID_INFORMACOES_ADICIONAIS
    LEFT JOIN rep_informacoes_brasileiros h ON h.id = g.informacoes_brasileiros_id

WHERE a.id=c.id_estudante and c.principal=1;
