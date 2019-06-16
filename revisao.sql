		create table cliente(
			cod_cliente int not null primary key,
			nome varchar(50)
		);
		
		create table funcionario(
			cod_funcionario int not null primary key,
			nome varchar(50)
		);
		
		create table categoria(
			cod_categoria int not null primary key,
			descricao varchar(50),
			valor_dia float
		);
		
		create table apartamento(
			numero int not null primary key,
			cod_categoria int not null references categoria(cod_categoria),
			status varchar(1) not null
		);
		
		create table reserva(
			cod_reserva serial not null primary key,
			cod_funcionario int not null references funcionario(cod_funcionario),
			cod_cliente int not null references cliente(cod_cliente),
			cod_categoria int not null references categoria(cod_categoria),
			dt_prev_ent date not null,
			dt_prev_sai date not null
		);

 		create table hospedagem(
			cod_hospedagem serial not null primary key,
			cod_funcionario int not null references funcionario(cod_funcionario),
			cod_cliente int not null references cliente(cod_cliente),
			numero int not null references apartamento(numero),
			dt_ent date not null,
			dt_prev_sai date not null,
			dt_sai date,
			valor_total float
		);
		

						-- EXERCICIO REVISÃO --
			
		-- 1. Considerando uma situação hipotética, crie um trigger que não permita que exista mais de uma reserva do 
		-- mesmo cliente na mesma categoria no mesmo intervalo de tempo. 
 
		-- 2.  Crie uma função que realiza hospedagens. A função deve receber apenas os seguintes parâmetros: nome do cliente,
		-- nome do funcionário, nome da categoria do apartamento e data prevista de saída. Considere que não existam dois nomes 
		-- iguais em uma mesma tabela. No caso do usuário repassar o nome da categoria, a função deve escolher o apartamento de 
		-- menor número DISPONÍVEL daquela categoria para efetivar a hospedagem. Ao efetivar a hospedagem, a função deve alterar 
		-- de “D” para “O” o status do apartamento a fim de indicar que ele está ocupado. Antes de efetivar a hospedagem, algumas 
		-- verificações devem ser realizadas. No caso de haver reserva para a categoria do apartamento que se deseja hospedar, 
		-- verifica-se se o período da reserva possui interseção com o período da hospedagem pretendida. Se sim, a hospedagem só poderá 
		-- ser efetivada se a reserva for do mesmo cliente que está pleiteando a hospedagem ou se existir mais de um apartamento 
		-- DISPONÍVEL (status “D”) daquela mesma categoria.  OBS: Sabe-se que outras verificações de consistência deveriam ser realizadas 
		-- para que o sistema do hotel funcione corretamente. Porém, preocupe-se apenas com as restrições descritas na questão. 
		
		
		
		
		