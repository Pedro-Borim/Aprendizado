create or replace FUNCTION FUNC_INTERPRETAR_EXPRESSAO 
(PARAM_EXPRESSAO IN VARCHAR2) RETURN NUMBER AS 
EXPRESSAO VARCHAR(255);
RES NUMBER(1);
BEGIN
    EXPRESSAO := 'BEGIN :OUT := CASE WHEN ' || PARAM_EXPRESSAO || ' THEN 1  ELSE 0 END; END;';
    EXECUTE IMMEDIATE EXPRESSAO USING OUT RES;
    RETURN RES;
END FUNC_INTERPRETAR_EXPRESSAO;