CREATE OR REPLACE VIEW V_APOLICES_CIEE AS 
  SELECT
        AC.ID,
        AC.NUMERO AS CODIGO_APOLICE,
        SEG.NOME AS SEGURADORA,
        AC.DATA_INICIO,
        AC.DATA_TERMINO,
        VAC.MORTE AS VALOR_MORTE,
        VAC.INVALIDEZ AS VALOR_INVALIDEZ
  FROM REP_APOLICES_CIEE AC
  LEFT JOIN REP_SEGURADORAS SEG ON AC.ID_SEGURADORA = SEG.ID
  LEFT JOIN REP_APOLICES_VALORES AV ON AV.ID_APOLICE = AC.ID
  LEFT JOIN REP_VALORES_APOLICES_CIEE VAC ON VAC.ID = AV.ID_VALORES_APOLICE;