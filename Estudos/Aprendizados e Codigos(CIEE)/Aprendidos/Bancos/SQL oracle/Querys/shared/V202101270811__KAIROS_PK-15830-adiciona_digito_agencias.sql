-- Coloca o digito X em duas agências do Banco do Brasil
update agencias set digito_agencia = 'X' where id_agencia in (4038, 0636) and id_banco in (select id_banco from bancos where nome_banco='BANCO DO BRASIL S/A');