CREATE TABLE REP_CONTATO_IE_TIPO_PROCESSO
(ACTIVE NUMBER(1),
 MAIN_CONTACT NUMBER(1),
 ID_CANAL_COMUNICACAO NUMBER(19) not null,
 ID_PESSOA  NUMBER(19) not null,
 ID_INSTITUICAO_ENSINO NUMBER(19) not null,
 DIRECTOR NUMBER(1),
 VICE_DIRECTOR NUMBER(1));

ALTER TABLE REP_CONTATO_IE_TIPO_PROCESSO ADD CONSTRAINT KRS_INDICE_03780 FOREIGN KEY (ID_CANAL_COMUNICACAO)
    REFERENCES REP_TIPOS_DE_PROCESSO (ID);

ALTER TABLE REP_CONTATO_IE_TIPO_PROCESSO ADD CONSTRAINT KRS_INDICE_03781 FOREIGN KEY (ID_PESSOA)
    REFERENCES REP_PESSOAS (ID);

ALTER TABLE REP_CONTATO_IE_TIPO_PROCESSO ADD CONSTRAINT KRS_INDICE_03782 FOREIGN KEY (ID_INSTITUICAO_ENSINO)
    REFERENCES REP_INSTITUICOES_ENSINOS (ID);

ALTER TABLE REP_CONTATO_IE_TIPO_PROCESSO ADD PRIMARY KEY (ID_CANAL_COMUNICACAO, ID_PESSOA, ID_INSTITUICAO_ENSINO);