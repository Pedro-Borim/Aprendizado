ALTER TABLE REP_INSTITUICOES_ENSINOS
    ADD tipo_escola NUMBER(20);

CREATE TABLE REP_TIPOS_ESCOLAS_UNIT
(
    id        NUMBER(19)         NOT NULL,
    descricao VARCHAR2(255 CHAR) NOT NULL,
    sigla     VARCHAR2(1 CHAR)   NOT NULL
);

ALTER TABLE REP_TIPOS_ESCOLAS_UNIT
    ADD CONSTRAINT krs_indice_04806 PRIMARY KEY (id);

ALTER TABLE REP_TIPOS_ESCOLAS_UNIT
    ADD CONSTRAINT krs_indice_04808 UNIQUE (sigla);

ALTER TABLE REP_INSTITUICOES_ENSINOS
    ADD CONSTRAINT krs_indice_04807 FOREIGN KEY (tipo_escola)
        REFERENCES REP_TIPOS_ESCOLAS_UNIT (id);
