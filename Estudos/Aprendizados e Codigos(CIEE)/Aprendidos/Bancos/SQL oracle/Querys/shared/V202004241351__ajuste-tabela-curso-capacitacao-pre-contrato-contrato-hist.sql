-- Aumenta o tamanho dos campos descricao de sala de acordo com o tamanho na Secretaria
ALTER TABLE PRE_CONTRATOS_CURSOS_CAPACITACAO MODIFY SALA_REGULAR VARCHAR2(300);
ALTER TABLE PRE_CONTRATOS_CURSOS_CAPACITACAO MODIFY SALA_COMPLEMENTAR VARCHAR2(300);
ALTER TABLE CONTRATOS_CURSOS_CAPACITACAO MODIFY SALA_REGULAR VARCHAR2(300);
ALTER TABLE CONTRATOS_CURSOS_CAPACITACAO MODIFY SALA_COMPLEMENTAR VARCHAR2(300);
ALTER TABLE HIST_CONTRATOS_CURSOS_CAPACITACAO MODIFY SALA_REGULAR VARCHAR2(300);
ALTER TABLE HIST_CONTRATOS_CURSOS_CAPACITACAO MODIFY SALA_COMPLEMENTAR VARCHAR2(300);