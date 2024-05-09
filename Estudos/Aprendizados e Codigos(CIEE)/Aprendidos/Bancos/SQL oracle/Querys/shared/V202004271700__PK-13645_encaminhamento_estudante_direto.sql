--
-- Criação da coluna 'ENCAMINHAMENTO_DIRETO' responsável por permitir que um contrato encaminhe diretamente um estudante ao uma vaga.
--

ALTER TABLE REP_CONFIGURACAO_CONTRATOS ADD ENCAMINHAMENTO_DIRETO NUMBER(1) DEFAULT 1;
COMMENT ON COLUMN REP_CONFIGURACAO_CONTRATOS.ENCAMINHAMENTO_DIRETO IS
    '0 - NAO
1 - SIM  - DEFAULT';