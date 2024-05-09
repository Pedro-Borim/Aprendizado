ALTER TABLE SERVICE_VAGAS_DEV.REP_LAUDOS_MEDICOS_DOCUMENTOS DROP CONSTRAINT KRS_INDICE_01625;
ALTER TABLE SERVICE_VAGAS_DEV.REP_LAUDOS_MEDICOS_DOCUMENTOS ADD CONSTRAINT "KRS_INDICE_01625" PRIMARY KEY ("LAUDO_MEDICO_ID", "DOCUMENTO_ID");

begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.IDX_REP_LAUDOS_MEDICOS_DOCUMENTOS_DELETADO_STATUS_LAUDO_MEDICO_ID';
exception when others then null;
end;
/

begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.IDX_REP_INFORMACOES_SOCIAIS_ID_ESTUDANTE';
exception when others then null;
end;
/

begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.IDX_QUALIFICACOES_ESTUDANTE_ID_ESTUDANTE_ID_QUALIFICACAO';
exception when others then null;
end;
/

begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.IDX_REP_CONHECIMENTOS_DIVERSOS_STUDENT_ID_ESTUDANTE';
exception when others then null;
end;
/

begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.IDX_REP_EXPERIENCIAS_PROFISSIONAIS_STUDENT_ID_ESTUDANTE';
exception when others then null;
end;
/

begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.IDX_REP_REDACOES_STUDENT_ID_ESTUDANTE';
exception when others then null;
end;
/

begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.IDX_CLASSIFICACOES_ESTUDANTES_CONSOLIDADO_ID_ESTUDANTE';
exception when others then null;
end;
/

create index SERVICE_VAGAS_DEV.IDX_REP_LAUDOS_MEDICOS_DOCUMENTOS_DELETADO_STATUS_LAUDO_MEDICO_ID on SERVICE_VAGAS_DEV.REP_LAUDOS_MEDICOS_DOCUMENTOS("DELETADO","STATUS","LAUDO_MEDICO_ID");
create index SERVICE_VAGAS_DEV.IDX_REP_INFORMACOES_SOCIAIS_ID_ESTUDANTE on SERVICE_VAGAS_DEV.REP_INFORMACOES_SOCIAIS("ID_ESTUDANTE");
create index SERVICE_VAGAS_DEV.IDX_QUALIFICACOES_ESTUDANTE_ID_ESTUDANTE_ID_QUALIFICACAO on SERVICE_VAGAS_DEV.QUALIFICACOES_ESTUDANTE("ID_ESTUDANTE","ID_QUALIFICACAO");
create index SERVICE_VAGAS_DEV.IDX_REP_CONHECIMENTOS_DIVERSOS_STUDENT_ID_ESTUDANTE on SERVICE_VAGAS_DEV.REP_CONHECIMENTOS_DIVERSOS_STUDENT("ID_ESTUDANTE");
create index SERVICE_VAGAS_DEV.IDX_REP_EXPERIENCIAS_PROFISSIONAIS_STUDENT_ID_ESTUDANTE on SERVICE_VAGAS_DEV.REP_EXPERIENCIAS_PROFISSIONAIS_STUDENT("ID_ESTUDANTE");
create index SERVICE_VAGAS_DEV.IDX_REP_REDACOES_STUDENT_ID_ESTUDANTE on SERVICE_VAGAS_DEV.REP_REDACOES_STUDENT("ID_ESTUDANTE");
create index SERVICE_VAGAS_DEV.IDX_CLASSIFICACOES_ESTUDANTES_CONSOLIDADO_ID_ESTUDANTE on SERVICE_VAGAS_DEV.CLASSIFICACOES_ESTUDANTES_CONSOLIDADO("ID_ESTUDANTE");

-- 2


begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.KRS_INDICE_02235';
exception when others then null;
end;
/

begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.KRS_INDICE_01879';
exception when others then null;
end;
/

begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.KRS_INDICE_02254';
exception when others then null;
end;
/


begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.IDX_ESTADO_CIVIL_VAGA_ESTAGIO_ID_VAGA_ESTAGIO';
exception when others then null;
end;
/

begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.IDX_IDIOMAS_ESTAGIO_DELETADO_ID_VAGA_ESTAGIO_ID_IDIOMA';
exception when others then null;
end;
/

begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.IDX_IDIOMAS_DELETADO_ID';
exception when others then null;
end;
/

begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.IDX_VAGAS_INSTITUICOES_ENSINO_ID_VAGA_ESTAGIO_DELETADO';
exception when others then null;
end;
/

begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.IDX_VINCULO_QUALI_VAGA_ESTAGIO_ID_VAGA_ESTAGIO';
exception when others then null;
end;
/

begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.IDX_CONHECIMENTOS_INF_ESTAGIO_DELETADO_ID_VAGA_ESTAGIO_ID_CONHECIMENTO';
exception when others then null;
end;
/

begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.IDX_CURSOS_VAGAS_ESTAGIO_ID_VAGA_ESTAGIO';
exception when others then null;
end;
/


begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.IDX_AREAS_ATUACAO_VAGAS_ESTAGIO_ID_VAGA_ESTAGIO';
exception when others then null;
end;
/

begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.IDX_OCORRENCIAS_ESTAGIO_ID_VAGA_ESTAGIO_DELETADO';
exception when others then null;
end;
/

begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.IDX_VINCULOS_VAGA_CODIGO_VAGA_DELETADO';
exception when others then null;
end;
/


begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.IDX_REP_LOCAIS_ENDERECOS_ID_LOCAL_CONTRATO_DELETADO';
exception when others then null;
end;
/



begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.IDX_REP_INFO_CONTRATO_EMPRESAS_ID_CONTRATO';
exception when others then null;
end;
/



begin
    execute immediate 'drop index SERVICE_VAGAS_DEV.IDX_QUALIFICACOES_EMPRESAS_CONSOLIDADO_ID_EMPRESA';
exception when others then null;
end;
/


create index SERVICE_VAGAS_DEV.IDX_ESTADO_CIVIL_VAGA_ESTAGIO_ID_VAGA_ESTAGIO on SERVICE_VAGAS_DEV.ESTADO_CIVIL_VAGA_ESTAGIO("ID_VAGA_ESTAGIO");
create index SERVICE_VAGAS_DEV.IDX_IDIOMAS_ESTAGIO_DELETADO_ID_VAGA_ESTAGIO_ID_IDIOMA on SERVICE_VAGAS_DEV.IDIOMAS_ESTAGIO("DELETADO","ID_VAGA_ESTAGIO","ID_IDIOMA");
create index SERVICE_VAGAS_DEV.IDX_IDIOMAS_DELETADO_ID on SERVICE_VAGAS_DEV.IDIOMAS("DELETADO","ID");
create index SERVICE_VAGAS_DEV.IDX_VAGAS_INSTITUICOES_ENSINO_ID_VAGA_ESTAGIO_DELETADO on SERVICE_VAGAS_DEV.VAGAS_INSTITUICOES_ENSINO("ID_VAGA_ESTAGIO","DELETADO");
create index SERVICE_VAGAS_DEV.IDX_VINCULO_QUALI_VAGA_ESTAGIO_ID_VAGA_ESTAGIO on SERVICE_VAGAS_DEV.VINCULO_QUALI_VAGA_ESTAGIO("ID_VAGA_ESTAGIO");
create index SERVICE_VAGAS_DEV.IDX_CONHECIMENTOS_INF_ESTAGIO_DELETADO_ID_VAGA_ESTAGIO_ID_CONHECIMENTO on SERVICE_VAGAS_DEV.CONHECIMENTOS_INF_ESTAGIO("DELETADO","ID_VAGA_ESTAGIO","ID_CONHECIMENTO");
create index SERVICE_VAGAS_DEV.IDX_CURSOS_VAGAS_ESTAGIO_ID_VAGA_ESTAGIO on SERVICE_VAGAS_DEV.CURSOS_VAGAS_ESTAGIO("ID_VAGA_ESTAGIO");
create index SERVICE_VAGAS_DEV.IDX_AREAS_ATUACAO_VAGAS_ESTAGIO_ID_VAGA_ESTAGIO on SERVICE_VAGAS_DEV.AREAS_ATUACAO_VAGAS_ESTAGIO("ID_VAGA_ESTAGIO");
create index SERVICE_VAGAS_DEV.IDX_OCORRENCIAS_ESTAGIO_ID_VAGA_ESTAGIO_DELETADO on SERVICE_VAGAS_DEV.OCORRENCIAS_ESTAGIO("ID_VAGA_ESTAGIO","DELETADO");
create index SERVICE_VAGAS_DEV.IDX_VINCULOS_VAGA_CODIGO_VAGA_DELETADO on SERVICE_VAGAS_DEV.VINCULOS_VAGA("CODIGO_VAGA","DELETADO");
create index SERVICE_VAGAS_DEV.IDX_REP_LOCAIS_ENDERECOS_ID_LOCAL_CONTRATO_DELETADO on SERVICE_VAGAS_DEV.REP_LOCAIS_ENDERECOS("ID_LOCAL_CONTRATO","DELETADO");
create index SERVICE_VAGAS_DEV.IDX_REP_INFO_CONTRATO_EMPRESAS_ID_CONTRATO on SERVICE_VAGAS_DEV.REP_INFO_CONTRATO_EMPRESAS("ID_CONTRATO");
create index SERVICE_VAGAS_DEV.IDX_QUALIFICACOES_EMPRESAS_CONSOLIDADO_ID_EMPRESA on SERVICE_VAGAS_DEV.QUALIFICACOES_EMPRESAS_CONSOLIDADO("ID_EMPRESA");