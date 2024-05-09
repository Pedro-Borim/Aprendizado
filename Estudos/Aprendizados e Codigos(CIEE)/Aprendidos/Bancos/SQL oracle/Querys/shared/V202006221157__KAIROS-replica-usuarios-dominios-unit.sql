ALTER TABLE REP_DOMINIOS_UNIT ADD CONSTRAINT KRS_INDICE_07942 PRIMARY KEY (ID) ENABLE;

CREATE TABLE REP_USUARIOS_DOMINIOS_UNIT (
    ID_USUARIO  NUMBER(19) NOT NULL,
    ID_DOMINIO  NUMBER(19) NOT NULL
);
COMMENT ON TABLE REP_USUARIOS_DOMINIOS_UNIT IS
    'UNIT_DEV:SERVICE_UNIT_DEV:USUARIOS_DOMINIOS:ID_USUARIO, ID_DOMINIO';
ALTER TABLE REP_USUARIOS_DOMINIOS_UNIT ADD CONSTRAINT KRS_INDICE_07923 PRIMARY KEY ( ID_USUARIO,
                                                                                     ID_DOMINIO );
ALTER TABLE REP_USUARIOS_DOMINIOS_UNIT
    ADD CONSTRAINT KRS_INDICE_07924 FOREIGN KEY ( ID_DOMINIO )
        REFERENCES REP_DOMINIOS_UNIT ( ID );
--
ALTER TABLE REP_INSTITUICOES_ENSINOS ADD ID_DOMINIO NUMBER (19);
ALTER TABLE REP_INSTITUICOES_ENSINOS
    ADD CONSTRAINT KRS_INDICE_07925 FOREIGN KEY ( ID_DOMINIO )
        REFERENCES REP_DOMINIOS_UNIT ( ID );