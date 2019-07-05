		-- Exercicio CHECK
		
	create table pessoa(
		nome varchar(100),
		dt_nasc date check (age(current_date,dt_nasc) >= '18 year')
	);

	select * from pessoa		
	insert into pessoa values('Pedro','1995-12-02')
	insert into pessoa values('Caio','2005-05-26')
	drop table pessoa



		-- Exercicio VISÕES
		
	create table venda(
		cod_venda serial primary key,
		nome_vendedor varchar(100),
		data_venda date,
		valor_vendido float
	);

-- 1) Povoe a tabela com 10 vendas,  considerando que existam apenas 4 vendedores na loja.
	insert into venda values(1,'Pedro','2019-05-22',200.00)
	insert into venda values(2,'Maria','2019-04-12',300.00)
	insert into venda values(3,'Pedro','2019-03-20',450.00)
	insert into venda values(4,'José','2019-05-01',1000.00)
	insert into venda values(5,'Catarina','2018-05-22',475.00)
	insert into venda values(6,'Catarina','2019-03-26',150.00)
	insert into venda values(7,'Catarina','2019-02-01',1200.00)
	insert into venda values(8,'José','2017-05-22',300.00)
	insert into venda values(9,'Pedro','2017-05-01',900.00)
	insert into venda values(10,'Pedro','2016-11-04',500.00)
	insert into venda values(11,'Pedro','2019-04-04',1100.00)
	insert into venda values(12,'José','2019-05-12',3000.00)
	insert into venda values(13,'Catarina','2019-05-20',2500.00)
	insert into venda values(14,'Maria','2019-05-20',200.00)
	insert into venda values(15,'Maria','2019-05-11',2800.00)
	insert into venda values(16,'José','2019-05-20',400.00)
	insert into venda values(17,'Catarina','2019-05-03',175.00)


-- 2.1) Mostre o nome dos vendedores que venderam mais de X reais no mês de março de 2014. 
	select nome_vendedor from venda where data_venda > '2019-05-01' and data_venda < '2019-05-31'
	group by nome_vendedor having sum(valor_vendido) > 200
	
-- 2.2) Mostre o nome de um dos vendedores que mais vendeu no mês de março de 2014
	select nome_vendedor from venda where data_venda > '2019-05-01' and data_venda < '2019-05-31'
	group by nome_vendedor order by count(cod_venda) desc
	limit 1
	
-- 3) Qual o nome do(s) vendedor(es) que mais vendeu no mês de março de 2014? 
	create or replace view rank_mes as
	select nome_vendedor,count(cod_venda) as qtd_vendas from venda where data_venda > '2019-05-01' and data_venda < '2019-05-31'
	group by nome_vendedor

	select nome_vendedor from rank_mes where qtd_vendas in
	(select max(qtd_vendas) from rank_mes)
	
	
	
			-- Exercicico TRIGGER
	
	
	-- 	Exercício 1 de 4: Crie uma tabela aluno com as colunas matrícula e nome. Depois crie um trigger que 
	-- não permita o cadastro de alunos cujo nome começa com a letra “a”.
	create table aluno(
		matricula serial primary key,
		nome varchar(50)
	);
	
	create or replace function funcao_aluno()
	returns trigger as $$
	begin
		if new.nome ilike 'a%' then
			raise exception 'Não é permitido aluno que o nome inicia com a letra A';
		end if;
		return new;
	end;
	$$ language plpgsql;
	
	create trigger gatilho_aluno
	before insert or update on aluno
	for each row
	execute procedure funcao_aluno();
	
	insert into aluno values(1,'Pedro')
	insert into aluno values(2,'Ana')
	
	update aluno set nome='Antonio' where matricula=1
	
	select * from aluno
	
	-- 	Exercício 2 de 4: Primeiro crie uma tabela chamada Funcionário com os seguintes campos: código (int), nome (varchar(30)), 
	-- salário (int), data_última_atualização (timestamp), usuário_que_atualizou (varchar(30)).  Na inserção desta tabela,
	-- você deve informar apenas o código, nome e salário do funcionário.  Agora crie um Trigger que não permita o nome nulo,  
	-- a salário nulo e nem negativo. Faça testes que comprovem o funcionamento do Trigger.  
	-- Obs: Raise Exception, ‘now’ e current_user
	create table funcionario(
		codigo serial primary key,
		nome varchar(30),
		salario integer,
		data_ultima_atualizacao timestamp,
		usuario_que_atualizou varchar(30)
	);
	
	create or replace function funcao_funcionario()
	returns trigger as $$
	begin
		if new.nome is null then
			raise exception 'Não é permitido nome nulo';
		end if;
		if new.salario is null then
			raise exception 'Não é permitido salario nulo';
		end if;
		if new.salario  <= 0 then
			raise exception 'Não é permitido salario negativo';
		end if;
		new.data_ultima_atualizacao = 'now';
		new.usuario_que_atualizou = current_user;
		return new;
	end;
	$$ language plpgsql;
	
	create trigger gatilho_funcionario
	before insert or update on funcionario
	for each row
	execute procedure funcao_funcionario();
	
	insert into funcionario values(1,'João',100);
	insert into funcionario values(2,null,100);
	insert into funcionario values(3,'João',-1);
	
	select * from funcionario

	 -- Exercício 3 de 4:Agora crie uma tabela chamada Empregado com os atributos nome e salário. Crie também outra tabela chamada
	 -- Empregado_auditoria com os atributos: operação (char(1)), usuário (varchar), data (timestamp), nome (varchar), salário
	 -- (integer) . Agora crie um trigger que registre na tabela Empregado_auditoria a modificação que foi feita na tabela empregado
	 -- (E,A,I), quem fez a modificação, a data da modificação, o nome do empregado que foi alterado e o salário atual dele. 
	 -- Obs: variável especial TG_OP
	 create table empregado(
		 nome varchar(50),
		 salario integer
	 );
	 
	 create table empregado_auditoria(
		 operacao char(1),
		 usuario varchar(50),
		 data timestamp,
		 nome varchar(50),
		 salario integer
	 );
	
	create or replace function funcao_empregado()
	returns trigger as $$
	begin
		if TG_OP = 'INSERT' then
			insert into empregado_auditoria values('I',current_user,'now',new.nome,new.salario);
			return new;
		end if;
		if TG_OP = 'UPDATE' then
			insert into empregado_auditoria values('A',current_user,'now',new.nome,new.salario);
			return new;
		end if;
		if TG_OP = 'DELETE' then
			insert into empregado_auditoria values('E',current_user,'now',old.nome,old.salario);
			return old;
		end if;
		return null;
	end;
	$$ language plpgsql;

	create trigger gatilho_empregado
	before insert or update or delete on empregado
	for each row
	execute procedure funcao_empregado();

	insert into empregado values('Mario',1000); 
	insert into empregado values('Ana',2000); 

	update empregado set nome = 'Pedro' where nome = 'Mario';

	delete from empregado where nome = 'Ana'

	select * from empregado
	select * from empregado_auditoria
		
  	-- Exercício 4 de 4:Crie a tabela Empregado2 com os atributos código (serial e chave primária), nome (varchar) e salário (integer). 
	  -- Crie também a tabela Empregado2_audit com os seguintes atributos: usuário (varchar), data (timestamp), id (integer),  
	  -- coluna (text), valor_antigo (text), valor_novo(text).  Agora crie um trigger que não permita a alteração da chave primária 
	  -- e insira registros na tabela Empregado2_audit para refletir as alterações realizadas na tabela Empregado2. 
	  create table empregado2(
		  codigo serial primary key,
		  nome varchar(50),
		  salario integer
	  );

	  create table empregado2_auditoria(
		  usuario varchar(50),
		  data timestamp,
		  id integer,
		  coluna text,
		  valor_antigo text,
		  valor_novo text
	  );

	  create or replace function funcao_empregado2()
	  returns trigger as $$
		 begin
		 	if new.codigo != old.codigo then
				raise exception 'Não é permitido atualizar chave primária';
			end if;
			if new.nome != old.nome then
				insert into empregado2_auditoria values (current_user,current_timestamp,old.codigo,'nome',old.nome,new.nome);
			end if;
			if new.salario != old.salario then
				insert into empregado2_auditoria values (current_user,current_timestamp,old.codigo,'salario',old.salario,new.salario);
			end if;
			return null;
		end;
	$$ language plpgsql;

	create trigger gatilho_empregado2
	after update on empregado2
	for each row
	execute procedure funcao_empregado2();

	insert into empregado2 values (1,'Pedro',3000)
	insert into empregado2 values (2,'Mario',3000)
	
	update empregado2 set nome = 'Paula' where codigo = 1
	update empregado2 set salario = 2500 where codigo = 2

	
	select * from empregado2
	select * from empregado2_auditoria
  	
			
			-- EXERCICIO FUNÇÂO --

	create table cliente(
		cod_cliente serial primary key not null,
		nome varchar(150),
		endereco varchar(100)
	);

	create table titulo(
		cod_titulo serial primary key not null,
		descricao_titulo varchar(100)
	);
	
	create table livro(
		cod_livro serial primary key not null,
		cod_titulo int not null references titulo(cod_titulo),
		valor_unitario real,
		quant_estoque int
	);

	create table venda1(
		cod_venda int,
		cod_cliente int,
		data_venda date,
		hora_venda timestamp,
		valor_total_venda real,
		quant_itens_vendidos int
	);
	
	create table item_venda(
		cod_livro int,
		cod_venda int,
		quantidade_item int,
		valor_total_item real
	);
	
	insert into cliente values(default,'FORNECEDOR LEGAL', 'ATRAS DE VOCE')
	insert into cliente values(default,'FORNECEDOR CHATO', 'SEU VIZINHO')
	insert into cliente values(default,'FORNECEDOR', 'ALI')
	
	insert into titulo values(default,'A VOLTA DOS QUE NÃO FORAM')
	insert into titulo values(default,'BRUXEIRO 3: A CAÇADA SELVAGEM')
	insert into titulo values(default,'BRUXEIRO 2: MATADOR DE REIS')

	insert into livro values(default,1,10,80)
	insert into livro values(default,2,5,50)
	insert into livro values(default,3,3,30)



	
	-- Crie uma função que realiza VENDA de um único livro que possui estoque suficiente. O ato de realizar
	-- VENDA consiste em inserir registros nas tabelas VENDA e Item_VENDA, além de decrementar a quantidade 
	-- em estoque. Essa função deve receber apenas os seguintes parâmetros: Código dA VENDA, código do livro,
	-- nome do CLIENTE (imagine que não existam dois CLIENTES com o mesmo nome) e quantidade vendida.
	
	create or replace function getcodigo_cliente(nome_cliente varchar(150))
	returns int as $$
	
	declare
	codigo int;
	
	begin
		select cod_cliente into codigo from cliente where nome = nome_cliente;
		return codigo;
	end;
	$$ language 'plpgsql';
	
	create or replace function quatidade_estoque(codigo_livro int)
	returns int as $$
	
	declare
	estoque int;
	
	begin
		select quant_estoque into estoque from livro where cod_livro = codigo_livro;
		return estoque;
	end;
	$$ language 'plpgsql';
	
	create or replace function valor_unitario_livro(codigo_livro int)
	returns int as $$
	
	declare
	valor int;
	
	begin
		select valor_unitario into valor from livro where cod_livro = codigo_livro;
		return valor;
	end;
	$$ language 'plpgsql';
	
	create or replace function realiza_venda(codigo_venda int,codigo_livro int,nome_cliente varchar(150),quatidade_vendida int)
	returns void as $$
	
	declare
	estoque_disponivel int := quatidade_estoque(codigo_livro);
	valor_livro real := valor_unitario_livro(codigo_livro);
	codigo_cliente int  := getcodigo_cliente(nome_cliente);
	atualizar_estoque int := estoque_disponivel - quatidade_vendida;
	
	begin
		if codigo_cliente is not null then
			if valor_livro is not null then
				if estoque_disponivel > quatidade_vendida then
					insert into venda1 values(codigo_venda, codigo_cliente, current_date,'now',quatidade_vendida*valor_livro, quatidade_vendida);
					insert into item_venda values(codigo_livro,codigo_venda,quatidade_vendida,quatidade_vendida*valor_livro);
					update livro set quant_estoque = atualizar_estoque where cod_livro = codigo_livro;
				else
					raise exception 'Estoque insuficiente';
				end if;
			else
				raise exception 'Livro não existe';
			end if;
		else
			raise exception 'Cliente não existe';
		end if;
			
	end;
	$$ language 'plpgsql';
	
	
	select realiza_venda(1,1,'FORNECEDOR',30);
	select realiza_venda(1,2,'FORNECEDOR LEGAL',20);
	select realiza_venda(1,3,'FORNECEDOR CHATO',15);
	select realiza_venda(2,3,'FORNECEDOR',10);
	select realiza_venda(2,2,'FORNECEDOR CHATO',10);
	
	
	select * from venda1
	select * from item_venda
	select * from cliente
	select * from livro

	
	-- Crie uma função que realiza VENDA como deve ser. Inserções nas tabelas VENDA e Item_VENDA, além
	-- da atualização da quantidade em estoque. No primeiro produto, devem haver inserções nas duas tabelas.
	-- A partir do segundo, apenas na tebela Item_VENDA. Não esqueça de decrementar a quantidade em estoque, 
	-- de atualizar o valor total da VENDA e a quantidade de itens da tabela VENDA.
	-- Os parâmetros passados para a função são os mesmos da questão anterior.
	
	create or replace function getcodigo_venda(codigo_venda int)
	returns int as $$
	
	declare
	codigo int;
	
	begin
		select cod_venda into codigo from venda1 where cod_venda = codigo_venda;
		return codigo;
	end;
	$$ language 'plpgsql';
	
	create or replace function contagem_item_venda(codigo_venda int ,codigo_livro int)
	returns int as $$
	
	declare
	contador int;
	
	begin
		select count(*) into contador from item_venda where cod_venda = codigo_venda and cod_livro = codigo_livro;
		return contador;
	end;
	$$ language 'plpgsql';
	
	
	create or replace function fazer_venda(codigo_venda int,codigo_livro int,nome_cliente varchar(150),quatidade_vendida int)
	returns void as $$
	
	declare
	estoque_disponivel int := quatidade_estoque(codigo_livro);
	valor_livro real := valor_unitario_livro(codigo_livro);
	codigo_cliente int  := getcodigo_cliente(nome_cliente);
	codigo_venda_temp int := getcodigo_venda(codigo_venda);
	atualizar_estoque int := estoque_disponivel - quatidade_vendida;
	contador_item_venda int := contagem_item_venda(codigo_venda,codigo_livro);

	begin
		if codigo_cliente is not null then
			if valor_livro is not null then
				if estoque_disponivel > quatidade_vendida then
					if codigo_venda_temp is null then
						insert into venda1 values(codigo_venda, codigo_cliente, current_date, 'now',quatidade_vendida*valor_livro, quatidade_vendida);
						insert into item_venda values(codigo_livro,codigo_venda,quatidade_vendida,quatidade_vendida*valor_livro);
						update livro set quant_estoque = atualizar_estoque where cod_livro = codigo_livro;
					else
						if contador_item_venda > 0 then
							update item_venda set quantidade_item = quantidade_item + quatidade_vendida where cod_venda = codigo_venda and cod_livro = codigo_livro;
							update item_venda set valor_total_item = valor_total_item + (quatidade_vendida*valor_livro) where cod_venda = codigo_venda and cod_livro = codigo_livro;

						else
							insert into item_venda values(codigo_livro,codigo_venda,quatidade_vendida,quatidade_vendida*valor_livro);
						end if;
						update venda1 set valor_total_venda = valor_total_venda + (quatidade_vendida*valor_livro) where cod_venda = codigo_venda;
						update venda1 set quant_itens_vendidos = quant_itens_vendidos + quatidade_vendida where cod_venda = codigo_venda;
						update livro set quant_estoque = atualizar_estoque where cod_livro = codigo_livro;
					end if;
				else
					raise exception 'Estoque insuficiente';
				end if;
			else
				raise exception 'Livro não existe';
			end if;
		else
			raise exception 'Cliente não existe';
		end if;
			
	end;
	$$ language 'plpgsql';

	select fazer_venda(4,1,'FORNECEDOR LEGAL',15);
	select fazer_venda(4,2,'FORNECEDOR LEGAL',5);
	select fazer_venda(4,1,'FORNECEDOR LEGAL',15);

	select * from venda1
	select * from item_venda
	select * from cliente
	select * from livro
	
	
	
				
		