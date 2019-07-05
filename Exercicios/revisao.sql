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
		
		insert into cliente values(1,'Pedro')
		insert into cliente values(2,'Maria')
		insert into cliente values(3,'Ana')
		insert into cliente values(4,'Paula')

		insert into funcionario values(1,'Mario')
		insert into funcionario values(2,'Joana')
		insert into funcionario values(3,'Francisca')
		insert into funcionario values(4,'Adriana')
		
		insert into categoria values(1,'Luxo',100)
		insert into categoria values(2,'Super-Luxo',150)
		insert into categoria values(3,'Simples',75)
		insert into categoria values(4,'Rik-Luxo',175)
		
		insert into apartamento values(100,3,'D')
		insert into apartamento values(101,1,'D')
		insert into apartamento values(102,2,'D')
		insert into apartamento values(200,1,'D')
		insert into apartamento values(201,1,'D')
		insert into apartamento values(202,2,'D')
		insert into apartamento values(203,3,'D')
		insert into apartamento values(300,2,'D')
		insert into apartamento values(301,1,'D')
		insert into apartamento values(302,3,'D')
		insert into apartamento values(303,4,'D')
		insert into apartamento values(400,4,'D')

					-- EXERCICIO REVISÃO --
			
		-- 1. Considerando uma situação hipotética, crie um trigger que não permita que exista mais de uma reserva do 
		-- mesmo cliente na mesma categoria no mesmo intervalo de tempo. 
		
		create or replace function permitir()
		returns trigger as $$
		declare 
		cod_cliente_temp int;
		cod_categoria_temp int;
		dt_prev_ent_temp date;
		dt_prev_sai_temp date;
		begin
			select cod_cliente into cod_cliente_temp from reserva;
			select cod_categoria into cod_categoria_temp from reserva;
			select dt_prev_ent into dt_prev_ent_temp from reserva;
			select dt_prev_sai into dt_prev_sai_temp from reserva;
		
			if new.cod_cliente = cod_cliente_temp and new.cod_categoria = cod_categoria_temp and new.dt_prev_ent >= dt_prev_ent_temp
			and new.dt_prev_sai <= dt_prev_sai_temp then
				raise exception 'Cliente já reservou categoria nesse intervalo de tempo';
			end if;
			return new;
		end;
		$$ language plpgsql;

		create trigger acionar_permitir
		before insert or update on reserva
		for each row
		execute procedure permitir();
		
	
		insert into reserva values(1,1,1,1,'2019-06-16','2019-06-20')
		insert into reserva values(2,1,1,1,'2019-06-01','2019-06-05')
		insert into reserva values(3,1,1,1,'2019-06-17','2019-06-19')
		insert into reserva values(4,1,1,1,'2019-06-16','2019-06-20')
		insert into reserva values(5,2,3,4,'2019-06-20','2019-06-25')
		insert into reserva values(6,2,3,1,'2019-06-20','2019-06-29')
		
		select * from reserva 
		
		
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
		
		
		create or replace function realiza_hospedagem(nome_cliente varchar(50),nome_funcionario varchar(50),
													  nome_categoria varchar(50),dt_prev_saida date)
		returns void as $$
		declare
		cod_cliente_temp int;
		cod_funcionario_temp int;
		cod_categoria_temp int;
		numero_temp int;
		registro reserva%rowtype;
		existe_reserva int;
		existe_reserva_cliente int;
		qtd_apart_disponiveis int;
		begin
			select cod_cliente into cod_cliente_temp from cliente where nome = nome_cliente;
			select cod_funcionario into cod_funcionario_temp from funcionario where nome = nome_funcionario;
			select cod_categoria into cod_categoria_temp from categoria where descricao = nome_categoria;
			select min(numero) into numero_temp from apartamento where cod_categoria = cod_categoria_temp and status = 'D';
			
			select count(*) into existe_reserva from reserva where cod_categoria = cod_categoria_temp and  
			current_date >= dt_prev_ent and	dt_prev_saida <= dt_prev_sai;
			
			select count(*) into existe_reserva_cliente from reserva where cod_cliente = cod_cliente_temp and
			cod_categoria = cod_categoria_temp and current_date >= dt_prev_ent and	dt_prev_saida <= dt_prev_sai;
			
			if existe_reserva > 0  then
				select count(*) into qtd_apart_disponiveis from categoria natural join apartamento where 
				cod_categoria = cod_categoria_temp and status = 'D';
				if existe_reserva_cliente > 0 or qtd_apart_disponiveis > 1 then
					insert into hospedagem values(default,cod_funcionario_temp,cod_cliente_temp,numero_temp,current_date,dt_prev_saida);
				else
					raise exception 'Não há apartamentos disponiveis';
				end if;
			else
				if numero_temp != null then
					insert into hospedagem values(default,cod_funcionario_temp,cod_cliente_temp,numero_temp,current_date,dt_prev_saida);
				else
					raise exception 'Não há apartamentos disponiveis';
				end if;
			end if;
			
			update apartamento set status = 'O' where numero = numero_temp;
			
		end;
		$$ language plpgsql;
		
		select realiza_hospedagem('Ana','Mario','Rik-Luxo','2019-06-25')
		select realiza_hospedagem('Pedro','Adriana','Rik-Luxo','2019-06-25')
		
		
		select * from reserva
		select * from hospedagem
		select * from apartamento
		select * from cliente
		select * from funcionario
		