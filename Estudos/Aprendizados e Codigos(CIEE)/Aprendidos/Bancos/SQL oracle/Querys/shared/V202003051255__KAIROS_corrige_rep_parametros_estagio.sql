--PK-12686 - Gerenciar pendencias de vias de TA - Estágio
-- --Service_Vagas
ALTER TABLE REP_PARAMETROS_PROGRAMA_EST
    DROP COLUMN DIAS_CANCELAR_TA_PADRAO;
ALTER TABLE REP_PARAMETROS_PROGRAMA_EST
    DROP COLUMN DIAS_CANCELAR_TA_ESPECIAL;
ALTER TABLE REP_PARAMETROS_PROGRAMA_EST
    DROP COLUMN DIAS_CANCELAR_TA_ADMIN;

--Service_Vagas
ALTER TABLE REP_PARAMETROS_PROGRAMA_EST
    ADD DIAS_CANCELAR_TA_PADRAO NUMBER(3);
ALTER TABLE REP_PARAMETROS_PROGRAMA_EST
    ADD DIAS_CANCELAR_TA_ESPECIAL NUMBER(3);
ALTER TABLE REP_PARAMETROS_PROGRAMA_EST
    ADD DIAS_CANCELAR_TA_ADMIN NUMBER(3);