ALTER TABLE {{user}}.CONTRATOS_ESTUDANTES_EMPRESA
    ADD (
        PCD NUMBER
    );

COMMENT ON COLUMN CONTRATOS_ESTUDANTES_EMPRESA.PCD IS
    'Flag 0 ou 1:

0 - Normal

1 - PCD
';
