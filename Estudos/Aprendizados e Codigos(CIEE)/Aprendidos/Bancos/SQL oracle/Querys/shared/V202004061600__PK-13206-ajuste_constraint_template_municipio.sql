ALTER TABLE TEMPLATES_MUNICIPIOS DROP CONSTRAINT KRS_INDICE_07448;
ALTER TABLE TEMPLATES_MUNICIPIOS ADD CONSTRAINT KRS_INDICE_07500 UNIQUE ( ID_MUNICIPIO, TIPO_TEMPLATE );