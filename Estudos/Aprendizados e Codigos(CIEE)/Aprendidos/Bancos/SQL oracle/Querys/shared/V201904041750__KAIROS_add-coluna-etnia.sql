ALTER TABLE REP_INFORMACOES_ADICIONAIS
    ADD ID_ETNIA NUMBER;

ALTER TABLE REP_INFORMACOES_ADICIONAIS
    ADD CONSTRAINT KRS_INDICE_02372 FOREIGN KEY (ID_ETNIA) REFERENCES REP_ETNIAS (ID);


