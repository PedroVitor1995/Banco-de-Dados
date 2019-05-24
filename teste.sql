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
	
	
	 -- Exercício 3 de 4:Agora crie uma tabela chamada Empregado com os atributos nome e salário. Crie também outra tabela chamada
	 -- Empregado_auditoria com os atributos: operação (char(1)), usuário (varchar), data (timestamp), nome (varchar), salário
	 -- (integer) . Agora crie um trigger que registre na tabela Empregado_auditoria a modificação que foi feita na tabela empregado
	 -- (E,A,I), quem fez a modificação, a data da modificação, o nome do empregado que foi alterado e o salário atual dele. 
	 -- Obs: variável especial TG_OP
	 
	  -- Exercício 2 de 4:Crie a tabela Empregado2 com os atributos código (serial e chave primária), nome (varchar) e salário (integer). 
	  -- Crie também a tabela Empregado2_audit com os seguintes atributos: usuário (varchar), data (timestamp), id (integer),  
	  -- coluna (text), valor_antigo (text), valor_novo(text).  Agora crie um trigger que não permita a alteração da chave primária 
	  -- e insira registros na tabela Empregado2_audit para refletir as alterações realizadas na tabela Empregado2. 