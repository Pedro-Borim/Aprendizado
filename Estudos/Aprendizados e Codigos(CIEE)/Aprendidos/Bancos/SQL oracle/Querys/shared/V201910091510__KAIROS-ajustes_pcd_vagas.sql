--Ajustando nome da tabela
ALTER TABLE PCD RENAME TO PCD_ESTAGIO;

-- Adicionando coluna PCD
ALTER TABLE VAGAS_ESTAGIO ADD PCD NUMBER(1) DEFAULT 0;
ALTER TABLE VAGAS_APRENDIZ ADD PCD NUMBER(1) DEFAULT 0;
ALTER TABLE PCD_APRENDIZ RENAME COLUMN ID_VAGA_APENDIZ TO ID_VAGA_APRENDIZ;

-- Criando TRIGGER que atualiza (true/false) coluna PCD em VAGA_ESTAGIO ao inserir/remover um registro em PCD_ESTAGIO
CREATE OR REPLACE TRIGGER SERVICE_VAGAS_DEV.TRIGGER_MARCA_PCD_INSERT
    AFTER
        INSERT on SERVICE_VAGAS_DEV.PCD_ESTAGIO
    for each row
begin
    UPDATE SERVICE_VAGAS_DEV.VAGAS_ESTAGIO SET PCD=1 WHERE ID=:NEW.ID_VAGA_ESTAGIO;
end;
/

CREATE OR REPLACE TRIGGER SERVICE_VAGAS_DEV.TRIGGER_MARCA_PCD_DELETE
    AFTER
        DELETE on SERVICE_VAGAS_DEV.PCD_ESTAGIO
    for each row
DECLARE
    vaga_pcd number;
begin
    SELECT COUNT(*) INTO vaga_pcd from SERVICE_VAGAS_DEV.PCD_ESTAGIO WHERE ID=:OLD.ID_VAGA_ESTAGIO;
    IF vaga_pcd=0 THEN
        UPDATE SERVICE_VAGAS_DEV.VAGAS_ESTAGIO SET PCD=0 WHERE ID=:OLD.ID_VAGA_ESTAGIO;
    END IF;
end;
/

-- Criando TRIGGER que atualiza (true/false) coluna PCD em VAGA_APRENDIZ ao inserir/remover um registro em PCD_APRENDIZ
CREATE OR REPLACE TRIGGER SERVICE_VAGAS_DEV.TRIGGER_MARCA_PCD_APRENDIZ_INSERT
    AFTER
        INSERT on SERVICE_VAGAS_DEV.PCD_APRENDIZ
    for each row
begin
    UPDATE SERVICE_VAGAS_DEV.VAGAS_APRENDIZ SET PCD = 1 WHERE ID=:NEW.ID_VAGA_APRENDIZ;
end;
/

CREATE OR REPLACE TRIGGER SERVICE_VAGAS_DEV.TRIGGER_MARCA_PCD_APRENDIZ_DELETE
    AFTER
        DELETE on SERVICE_VAGAS_DEV.PCD_APRENDIZ
    for each row
DECLARE
    vaga_pcd number;
begin
    SELECT COUNT(*) INTO vaga_pcd from SERVICE_VAGAS_DEV.PCD_APRENDIZ WHERE ID=:OLD.ID_VAGA_APRENDIZ;
    IF vaga_pcd=0 THEN
        UPDATE SERVICE_VAGAS_DEV.VAGAS_APRENDIZ SET PCD = 0 WHERE ID=:OLD.ID_VAGA_APRENDIZ;
    END IF;
end;
/
