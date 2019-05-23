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

-- 2.1) Mostre o nome dos vendedores que venderam mais de X reais no mês de março de 2014. 
	select nome_vendedor from venda where data_venda > '2019-05-01' and data_venda < '2019-05-31'
	group by nome_vendedor having sum(valor_vendido) > 200
	
-- 2.2) Mostre o nome de um dos vendedores que mais vendeu no mês de março de 2014
	select nome_vendedor from venda where data_venda > '2019-05-01' and data_venda < '2019-05-31'
	group by nome_vendedor order by sum(valor_vendido) desc
	limit 1
	
-- 3) Qual o nome do(s) vendedor(es) que mais vendeu no mês de março de 2014? 
	create or replace view rank_mes as
	select nome_vendedor,sum(valor_vendido) as valor from venda where data_venda > '2019-05-01' and data_venda < '2019-05-31'
	group by nome_vendedor
		
	select nome_vendedor from rank_mes where valor in
	(select max(valor) from rank_mes)
	