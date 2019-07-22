create or replace function verificar_produto()
returns trigger as $$
begin
	if new.e_combo ilike 's' then
		new.valor_venda = 0;
		return new;
	end if;
	return new;
end;
$$ language 'plpgsql';

create trigger acionar_verificar_produto
before insert on produto
for each row
execute procedure verificar_produto()


create or replace function atualizar_valor_produto()
returns trigger as $$
declare
eh_combo varchar(5);
valor_prod float;
prod int;

begin
	select cod_prod into prod from produto where new.cod_prod_combo = cod_prod;
	select valor_venda into valor_prod from produto where new.cod_prod = cod_prod;
	select e_combo into eh_combo from produto where prod = cod_prod and e_combo ilike 's';
	if eh_combo is not null then
		if prod is not null then
			update produto set valor_venda = (valor_prod*new.quant) where prod = cod_prod;
			return new;
		else 
			update produto set valor_venda = valor_venda - ((valor_venda*20)/100) where e_combo ilike 's';
		end if;
	else
		raise exception 'O produto não é combo';
	end if;
	return null;
end;
$$ language 'plpgsql';

create trigger acionar_atualizar_valor_produto
before insert on combo
for each row
execute procedure atualizar_valor_produto()



insert into produto values(1,'caneta e caderno','S',30.0)
insert into produto values(2,'lapis e borracha','S',30.0)
insert into produto values(3,'caderno','N',15.0)
insert into produto values(4,'lapis','N',2.0)
insert into produto values(5,'borracha','N',1.0)
insert into produto values(6,'caneta','N',3.0)
insert into produto values(7,'grafite','N',5.0)
insert into produto values(8,'lapis e grafite','S',12)

insert into combo values(1,6,1)
insert into combo values(1,3,1)
insert into combo values(2,4,1)
insert into combo values(2,5,1)
insert into combo values(8,7,1)
insert into combo values(8,4,1)
insert into combo values(2,6,1)

select * from produto
select * from combo


------------------------------------------------------------------


create or replace function realiza_pedido(nome_prod1 varchar,quant_prod1 int,
												   nome_prod2 varchar,quant_prod2 int)
returns void as $$
declare
cod_prod1 int;
cod_prod2 int;
valor_prod1 int; 
valor_prod2 int;
cod_forn1 int;
cod_forn2 int;
cod_forn1_pedido int;
cod_forn2_pedido int;
status1 varchar(10);
status2 varchar(10);
cod_pedido int ;

begin

	select cod_prod into cod_prod1 from produto where nome_prod1 = nome_prod;
	select cod_prod into cod_prod2 from produto where nome_prod2 = nome_prod;
	select min(valor_ofertado) into valor_prod1 from fornecedor inner join tab_preco on
	fornecedor.cod_forn = tab_preco.cod_forn and cod_prod1 = cod_prod ;
	select min(valor_ofertado) into valor_prod2 from fornecedor inner join tab_preco on
	fornecedor.cod_forn = tab_preco.cod_forn and cod_prod1 = cod_prod;
	select cod_forn into cod_forn1 from tab_preco where valor_prod1 = valor_ofertado;
	select cod_forn into cod_forn2 from tab_preco where valor_prod2 = valor_ofertado;
	select cod_forn,status into cod_forn1_exist,status1 from pedido where cod_forn1 = cod_forn;
	select cod_forn,status into cod_forn2_exist,status2 from pedido where cod_forn2 = cod_forn;
	if cod_forn1 = cod_forn2 then
		if status1 ilike 'aberto' then
			if cod_forn1_exist is not null then
				insert into item_pedido values(default,cod_prod1,quant_prod1);
			else
				insert into pedido values(cod_forn1,null,'aberto',0,);
				insert into item_pedido values(default,cod_prod1,quant_prod1);
			end if;
		end if;
	else
		if status1 ilike 'aberto'then
			if cod_forn1_exist is not null then
				insert into item_pedido values(default,cod_prod1,quant_prod1);
			else
				insert into pedido values(cod_forn1,null,'aberto',0,);
				insert into item_pedido values(default,cod_prod1,quant_prod1;
			end if;
		end if;
		if status2 ilike 'aberto'then
			if cod_forn2_exist is not null then
				insert into item_pedido values(default,cod_prod2,quant_prod2);
			else
				insert into pedido values(cod_forn2,null,'aberto',0,);
				insert into item_pedido values(default,cod_prod2,quant_prod2);
			end if;
		end if;
	end if;
	
	
end;
$$ language 'plpgsql';

create or replace function fechar_pedido()
returns void as $$
begin
	update pedido set status = 'fechado' where status ilike 'aberto';
end;
$$ language 'plpgsql';

insert into fornecedor values(1,'Al star')
insert into fornecedor values(2,'Estude bem')
insert into fornecedor values(3,'Caminho dos estudos')

insert into tab_preco values(4,1,2)
insert into tab_preco values(4,2,3)
insert into tab_preco values(4,3,1)



select * from fornecedor
select * from tab_preco
select * from pedido
select * from item_pedido