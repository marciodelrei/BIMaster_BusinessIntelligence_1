--- Aponta para o BD projeto_covid19
SET search_path TO projeto_covid19;

---cria schema dw_covid19
CREATE SCHEMA dw_covid19
    AUTHORIZATION postgres;

---script dim_tempo versão:20201217
---prof. anderson nascimento
create table dw_covid19.dim_data (
sk_data BIGINT not null,
nk_data date not null,
desc_data_completa varchar(60) not null,
nr_ano BIGINT not null,
nm_trimestre varchar(20) not null,
nr_ano_trimestre varchar(20) not null,
nr_mes BIGINT not null,
nm_mes varchar(20) not null,
ano_mes varchar(20) not null,
nr_semana BIGINT not null,
ano_semana varchar(20) not null,
nr_dia BIGINT not null,
nr_dia_ano BIGINT not null,
nm_dia_semana varchar(20) not null,
flag_final_semana char(3) not null,
flag_feriado char(3) not null,
nm_feriado varchar(60) not null,
dt_final timestamp not null,
dt_carga timestamp not null,
constraint sk_data_pk primary key (sk_data)
);

insert into dw_covid19.dim_data
select to_number(to_char(datum,'yyyymmdd'), '99999999') as sk_tempo,
datum as nk_data,
to_char(datum,'dd/mm/yyyy') as data_completa_formatada,
extract (year from datum) as nr_ano,
'T' || to_char(datum, 'q') as nm_trimestre,
to_char(datum, '"T"q/yyyy') as nr_ano_trimenstre,
extract(month from datum) as nr_mes,
to_char(datum, 'tmMonth') as nm_mes,
to_char(datum, 'yyyy/mm') as nr_ano_nr_mes,
extract(week from datum) as nr_semana,
to_char(datum, 'iyyy/iw') as nr_ano_nr_semana,
extract(day from datum) as nr_dia,
extract(doy from datum) as nr_dia_ano,
to_char(datum, 'tmDay') as nm_dia_semana,
case when extract(isodow from datum) in (6, 7) then 'Sim' else 'Não'
end as flag_final_semana,
case when to_char(datum, 'mmdd') in ('0101','0421','0501','0907','1012','1102','1115','1120','1225') then 'Sim' else 'Não'
end as flag_feriado,
case 
---incluir aqui os feriados
when to_char(datum, 'mmdd') = '0101' then 'Ano Novo' 
when to_char(datum, 'mmdd') = '0421' then 'Tiradentes'
when to_char(datum, 'mmdd') = '0501' then 'Dia do Trabalhador'
when to_char(datum, 'mmdd') = '0907' then 'Dia da Pátria' 
when to_char(datum, 'mmdd') = '1012' then 'Nossa Senhora Aparecida' 
when to_char(datum, 'mmdd') = '1102' then 'Finados' 
when to_char(datum, 'mmdd') = '1115' then 'Proclamação da República'
when to_char(datum, 'mmdd') = '1120' then 'Dia da Consciência Negra'
when to_char(datum, 'mmdd') = '1225' then 'Natal' 
else 'Não é Feriado'

end as nm_feriado,
'2199-12-31',
current_date as data_carga
from (
--- O levantamento iniciou no dia 24/02/2020.
select '2020-02-24'::date + sequence.day as datum
from generate_series(0,5479) as sequence(day)
group by sequence.day
) dq
order by 1;


CREATE SEQUENCE dw_covid19.dim_local_sk_local_seq;

CREATE TABLE dw_covid19.dim_local (
                sk_local BIGINT NOT NULL DEFAULT nextval('dw_covid19.dim_local_sk_local_seq'),
                nk_local VARCHAR(3) NOT NULL,  --- Corrigida a quantidade de caracteres
                nm_pais VARCHAR(50) NOT NULL,
                nm_continente VARCHAR(50) NOT NULL,
                nr_populacao BIGINT NOT NULL,
                CONSTRAINT sk_local PRIMARY KEY (sk_local)
);
COMMENT ON COLUMN dw_covid19.dim_local.sk_local IS 'Chave artificial';
COMMENT ON COLUMN dw_covid19.dim_local.nk_local IS 'Chave natural';


ALTER SEQUENCE dw_covid19.dim_local_sk_local_seq OWNED BY dw_covid19.dim_local.sk_local;

CREATE TABLE dw_covid19.ft_obito (
                sk_local BIGINT NOT NULL,
                sk_data BIGINT NOT NULL,
                med_novas_mortes BIGINT NOT NULL,
                med_total_mortes BIGINT NOT NULL,
                med_novas_mortes_por_milhao REAL NOT NULL,
                med_total_mortes_por_milhao REAL NOT NULL
);


CREATE TABLE dw_covid19.ft_vacinacao (
                sk_data BIGINT NOT NULL,
                sk_local BIGINT NOT NULL,
                med_pessoas_vacinadas_por_100 REAL NOT NULL,
                med_pessoas_totalmente_vacinadas_por_cem REAL NOT NULL,
                med_pessoas_vacinadas BIGINT NOT NULL,
                med_pessoas_totalmente_vacinadas BIGINT NOT NULL
);
COMMENT ON COLUMN dw_covid19.ft_vacinacao.sk_data IS 'Chave artificial';
COMMENT ON COLUMN dw_covid19.ft_vacinacao.sk_local IS 'Chave artificial';


ALTER TABLE dw_covid19.ft_vacinacao ADD CONSTRAINT dim_tempo_ft_vacinacao_fk
FOREIGN KEY (sk_data)
REFERENCES dw_covid19.dim_data (sk_data)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE dw_covid19.ft_obito ADD CONSTRAINT dim_tempo_ft_internacao_obito_fk
FOREIGN KEY (sk_data)
REFERENCES dw_covid19.dim_data (sk_data)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE dw_covid19.ft_vacinacao ADD CONSTRAINT dim_local_ft_vacinacao_fk
FOREIGN KEY (sk_local)
REFERENCES dw_covid19.dim_local (sk_local)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE dw_covid19.ft_obito ADD CONSTRAINT dim_local_ft_internacao_obito_fk
FOREIGN KEY (sk_local)
REFERENCES dw_covid19.dim_local (sk_local)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

---cria schema pre_dw
CREATE SCHEMA pre_dw_covid19
    AUTHORIZATION postgres;


CREATE TABLE pre_dw_covid19.fatos (
                nk_local VARCHAR(3) NOT NULL,
                nk_data DATE NOT NULL,
                med_novas_mortes BIGINT NOT NULL,
                med_total_mortes BIGINT NOT NULL,
                med_novas_mortes_por_milhao REAL NOT NULL,
                med_total_mortes_por_milhao REAL NOT NULL,
                med_pessoas_vacinadas_por_100 REAL NOT NULL,
                med_pessoas_totalmente_vacinadas_por_cem REAL NOT NULL,
                med_pessoas_vacinadas BIGINT NOT NULL,
                med_pessoas_totalmente_vacinadas BIGINT NOT NULL
);