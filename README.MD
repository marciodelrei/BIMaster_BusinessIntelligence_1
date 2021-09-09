# Business Intelligence 1 - BI_1 Master PUC-Rio
## Scripts desenvolvidos durante a disciplina de BI_1
<img width="924" alt="BI_MASTER_2021_1" src="https://user-images.githubusercontent.com/7377875/132598490-a41fe6b3-8e46-4bf9-ae2f-4b43ede0182a.PNG"></img>
### Índice
  
- [Projeto](#projeto)

<h2 id="projeto">
  
[Projeto_BI](https://github.com/marciodelrei/BIMaster_BusinessIntelligence/tree/main/Projeto)
  
</h2>

 - **Projeto final da disciplina de Business Intelligence 1: : [`Projeto`](https://github.com/marciodelrei/BIMaster_BusinessIntelligence/tree/main/Projeto).
     - Integrantes:
         - José Leonel Majewski
         - Laís Moureira dos Santos
         - Márcio Palma d’El-Rei Pinto

 01/08/2021

Passo a passo para execução do Projeto:

Colocar a pasta Projeto_BI no C:\.

É necessário ter instalado os softwares:
	- Postgres 12 ou superior com PgAdmin (Postgres 13.3 - https://www.enterprisedb.com/postgresql-tutorial-resources-training?cid=437);
	- Pentaho PDI 9.1 (https://sourceforge.net/projects/pentaho/files/latest/download);
	- Power BI Desktop Julho/2021 (https://www.microsoft.com/pt-br/download/confirmation.aspx?id=58494)

Desejável possui o software SQL Power Architect para visualização do modelo dimensional: "..\anexos\modelo_dimensional\Modelo_dimensional.architect"

1 - Criar o Database no Postgres com o nome projeto_covid19;

2 - Executar o script "..\anexos\script_bd\dw_covid19.sql"
	Criará o BD físico do DW e uma tabela para apoio do ETL, em schemas diferentes: "dw_covid19" e "pre_dw_covid19"
	
3 - A partir deste ponto, pode-se escolher 4 formas de se criar o DW:
	3.1 - Atualiza o DW em tempo de execução. Executar separadamente e na ordem as transformações abaixo, diretamente do Pentaho PDI
		- "..\ktr\00_Extracao_CSV_Github.ktr"
		- "..\ktr\01_ETL1_Pre_DW.ktr"
		- "..\ktr\02_Carga_DW.ktr"
	ou;
		
	3.2 - Atualiza o DW em tempo de execução. Executar o Job do Pentaho PDI "..\ktr\Covid19_job.kjb", onde já estão encadeadas as transformações
	do item 3.1 ou;
	
	3.3 - Atualiza o DW em tempo de execução. Executar o arquivo bat "..\ktr\job.bat" diretamente do prompt do DOS, externamente ao Pentaho PDI ou;
	
	3.4 - Atualiza o DW em dia e hora específicos. Criar agendamento no windows para executar o aquivo bat do item 3.3 em horário definido para
	que se faça	todo o processo automaticamente sem interação humana. Para facilitar este agendamento, pode-se importar o arquivo
	"..\anexos\schedule_windows\ProjetoBI_COVID19 (TaskWindows).xml", diretamente no agendador do Windows (talvez seja necessário atulizar o
	usuário proprietário da task). 
	
	Todas as etapas atualizam o DW de forma dinâmica atualizando o Dashboard desenvolvido no Power BI.
	
4 - Abrir o arquivo "..\bi\projeto_covid19.pbix" no Power BI Desktop e clicar em Atualizar para ver os gráficos atualizados de acordo com uma das
	opções do item 3.

5 - Estrutura dos arquivos do projeto:
C:\Projeto_BI
	|   
	+---anexos
	|   |   README.txt
	|   |   
	|   +---dicionario_dados_stage_owid
	|   |       dicionario_dados.pdf
	|   |       owid-covid-data_TEMPLATE.csv
	|   |       
	|   +---modelo_dimensional
	|   |       Modelo_dimensional.architect
	|   |       
	|   +---schedule_windows
	|   |       ProjetoBI_COVID19 (TaskWindows).xml
	|   |       
	|   \---script_bd
	|           dw_covid19.sql
	|           
	+---bi
	|       projeto_covid19.pbix
	|       
	+---ktr
	|       00_Extracao_CSV_Github.ktr
	|       01_ETL1_Pre_DW.ktr
	|       02_Carga_DW.ktr
	|       Covid19_job.kjb
	|       job.bat
	|       log.txt
	|       
	+---logs
	|       covid19.log
	|       
	\---stage
			owid-covid-data.csv
