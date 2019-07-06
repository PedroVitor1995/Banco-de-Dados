------------------------------------------------------------------------------------------------
create or replace function restricao_nome()
returns trigger as $$
begin

	if length(trim(both '''' from new.nome)) < 2 then
		raise exception 'O nome dever ter pelos dois caracteres';
	end if;
	
	return new;
end;
$$ language plpgsql;
------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------
create trigger acionar_restricao_nome_cenario
before insert or update on cenario
for each row
execute procedure restricao_nome();
------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------
create trigger acionar_restricao_nome_elemento
before insert or update on elemento
for each row
execute procedure restricao_nome();
------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------
create trigger acionar_restricao_nome_carta
before insert or update on carta
for each row
execute procedure restricao_nome();
------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------
create trigger acionar_restricao_nome_jogador
before insert or update on jogador
for each row
execute procedure restricao_nome();
------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------
create trigger acionar_restricao_nome_tipo
before insert or update on tipo
for each row
execute procedure restricao_nome();
------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------
create or replace function restricao_nivel()
returns trigger as $$
begin

	if length(trim(both '''' from new.descricao)) < 2 then
		raise exception 'O nome dever ter pelos dois caracteres';
	end if;
	if new.valor < 0 then
		raise exception 'O valor do nivel não pode ser nulo';
	end if;
	
	return new;
end;
$$ language plpgsql;

create trigger acionar_restricao_nivel
before insert or update on nivel
for each row
execute procedure restricao_nivel();
------------------------------------------------------------------------------------------------
