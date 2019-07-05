create or replace function nova_carta(nome_carta varchar, tipo_carta varchar, nivel_carta int, elemento_carta varchar, jogador_carta varchar) 
returns setof carta as $$
declare 
carta_recebida carta%rowtype;
cod_temp int;
cod_tipo_temp int;
cod_nivel_temp int;
cod_elemento_temp int;
cod_jogador_temp int;
valor_temp int;
begin

	select * into carta_recebida from Buscar(NULL::carta, 'nome', nome_carta);

	if(carta_recebida.nome is not null)then
		raise exception 'Já existe carta com o nome %', nome_carta; 
	end if;
	
	if tipo_carta not ilike '''monstro''' then
		raise exception 'carta % não pode ser cadastrada. Tipo incompativel com os valores passados', nome_carta;
	end if;
	
	select cod_tipo into cod_tipo_temp from Buscar(NULL::tipo, 'nome', tipo_carta);
	select valor into valor_temp from Buscar(NULL::nivel, 'cod_nivel', ''||nivel_carta||'');
	select cod_elemento into cod_elemento_temp from Buscar(NULL::elemento, 'nome', elemento_carta);
	select cod_jogador into cod_jogador_temp from Buscar(NULL::jogador, 'nome', jogador_carta);
	
	-- saber o ataque da carta dependendo do nivel que ele passar. Se a carta for tipo monstro ok. senao 	
	perform inserir('carta',''||nome_carta||','''||valor_temp||''','''||cod_tipo_temp||''','''||nivel_carta||''','''||cod_elemento_temp||''',null,null,'''||cod_jogador_temp||'''');
	return query select * from carta where cod_carta in (select max(cod_carta) from carta);
	
end;
$$ language plpgsql;
select * from carta;
select * from tipo;
select * from elemento;
select * from nivel;
select * from jogador;
select * from nova_carta('''campo magnetico''','''campo''','''eletrico''','''icaro''');
nivel 1		nivel 5
atk 16    	250
-- E quando a carta passar de nivel?;
-- o valor deve ser aumentado no atk.
select equipar();
duelar()
select * from carta;
select * from nivel;
-- deixar pontuação na tabela carta. 
pontuação começa com 10
pontuação: 10-20-30-40-50-60-70-80-90-100
5 pontos;
1-6-11-16-21-26-31-36-41-46-51;

51-54-58-62-66-70-74-78-82-86-90-94-98-102;

6-5 = 5
6-4 2
6-3 3
6-2 4 
6-1 5
create materialized view historico_partida as select partida, carta, equipamento, vencedor from duelo d inner join carta ca on d.carta = ca.cod_carta;
DROP MATERIALIZED VIEW carta_equipada;
select * from carta_equipada;
-- Função que verifica se existe o registro especificado.
create or replace function Existe(tabela text, valor varchar) returns boolean as $$
declare
existe_temp boolean;
begin
		
	execute 'select exists(SELECT * FROM ' || tabela || ' WHERE nome ilike '||valor||')'
	into existe_temp;
	return existe_temp;
end;

$$ language plpgsql;
select Existe('carta','''icaro''');
select * from carta;
delete from carta where cod_carta = 11; 
------------------------------------------------------------------------
-- BUSCAR UM REGISTRO NA TABELA;
create or replace function Buscar(tabela anyelement, chave text, valor text) returns setof anyelement as $$
declare
begin

	
	 return query EXECUTE format('
      SELECT *
      FROM  %s  -- pg_typeof returns regtype, quoted automatically
      WHERE '||chave||' = '||valor||'',pg_typeof(tabela));
	  
end;
$$ language plpgsql;
SELECT * FROM Buscar(null::carta, 'nome', '''teste''');
select * from carta;
'INSERT INTO DUELO()... triggers para verificacão;
duelar() função para definir as regras do jogo;
equipar(1,1,5) função para equipar; carta para equipar, e o equipamento;'


---------------------------------------------------------------------------

-- EQUIPAR UMA CARTA COM OUTRA
create or replace function equipar_carta(monstro varchar, magica varchar) 
returns setof carta as $$

declare
atk_final int;
monstro_existe boolean := Existe('carta', monstro);
magica_existe boolean := Existe('carta', magica);
monstro_recebido carta%rowtype;
magica_recebido carta%rowtype;
cod_part int;
tipo_recebido_monstro tipo%rowtype;
tipo_recebido_magica tipo%rowtype;
BEGIN

	select * into monstro_recebido from Buscar(NULL::carta,'nome',monstro);
	select * into magica_recebido from Buscar(NULL::carta,'nome',magica);
	select * into tipo_recebido_monstro from Buscar(NULL::tipo,'cod_tipo',''||monstro_recebido.tipo||'');
	select * into tipo_recebido_magica from Buscar(NULL::tipo,'cod_tipo',''||magica_recebido.tipo||'');

	if monstro_recebido.cod_carta is null then
		raise exception 'carta com o nome % não existe', monstro;
	end if;
	
	if magica_recebido.cod_carta is null then
		raise exception 'carta com o nome % não existe', magica;
	end if;
	
	if tipo_recebido_monstro.nome not ilike 'monstro' or tipo_recebido_magica.nome not ilike 'magica' then
		raise exception 'tipo incompativeis aos nomes passados';
	end if;
	
	if monstro_recebido.jogador <> magica_recebido.jogador then
		raise exception 'equipamento invalido. Cartas de jogadores diferentes';
	end if;
	
	if(monstro_recebido.equipamento is not null)then 
		raise exception 'Carta ja equipada para duelar';
	end if;
	
	update carta set equipamento = magica_recebido.cod_carta where cod_carta = monstro_recebido.cod_carta;
	return query select * from carta where cod_carta = monstro_recebido.cod_carta;
	
end;
$$ language plpgsql;
select * from carta;
select * from equipar_carta('''pikachu''','''ajuda''');
select * from duelo;
-------------------------------------------------------------------------------------
-- Função que faz o duelo
create or replace function Duelar(monstro1 varchar, monstro2 varchar, campo varchar, cenario varchar) returns varchar as $$
declare 
monstro1_recebido carta%rowtype;
monstro2_recebido carta%rowtype;
campo_recebido carta%rowtype;
monstro1_recebido_elemento elemento%rowtype;
monstro2_recebido_elemento elemento%rowtype;
campo_recebido_elemento elemento%rowtype;
monstro1_recebido_equipamento carta%rowtype;
monstro2_recebido_equipamento carta%rowtype;
vencedor varchar;
cod_part int;
teste int;
atk_total_monstro1 real;
atk_total_monstro2 real;
cenario_temp cenario%rowtype;
begin	
	select * into monstro1_recebido from Buscar(NULL::carta,'nome',monstro1);
	select * into monstro2_recebido from Buscar(NULL::carta,'nome',monstro2);
	select * into campo_recebido from Buscar(NULL::carta,'nome',campo);
	select * into cenario_temp from Buscar(NULL::cenario,'nome',cenario);
	

	if monstro1_recebido.cod_carta is null then 
		raise exception 'Carta % não existe', monstro1;
	end if;
	
	if monstro2_recebido.cod_carta is null then 
		raise exception 'Carta % não existe', monstro2;
	end if;
	
	if campo_recebido.cod_carta is null then
		raise exception 'carta campo invalida';
	end if;
	
	if cenario_temp.cod_cenario is null then
		raise exception 'Cenario %s não existe', cenario_temp;
	end if;
	
	if monstro1_recebido.jogador = monstro2_recebido.jogador then
		raise exception 'cartas de um mesmo jogador não são permitidas para o duelo';
	end if;
	
	atk_total_monstro1 := monstro1_recebido.atk;
	atk_total_monstro2 := monstro2_recebido.atk;
	
	if monstro1_recebido.equipamento is not null then 
		select * into monstro1_recebido_equipamento from Buscar(NULL::carta,'cod_carta',''||monstro1_recebido.equipamento||'');
		atk_total_monstro1 :=  atk_total_monstro1 + monstro1_recebido_equipamento.pontos_magia; 
	end if;
	if monstro2_recebido.equipamento is not null then 
		select * into monstro2_recebido_equipamento from Buscar(NULL::carta,'cod_carta',''||monstro2_recebido.equipamento||'');
		atk_total_monstro2 := atk_total_monstro2 + monstro2_recebido_equipamento.pontos_magia; 
	end if;

-- Regras da função.
	-- REGRA ELEMENTO --
	select * into monstro1_recebido_elemento from Buscar(NULL::elemento,'cod_elemento',''||monstro1_recebido.elemento||'');
	select * into monstro2_recebido_elemento from Buscar(NULL::elemento,'cod_elemento',''||monstro2_recebido.elemento||'');
	select * into campo_recebido_elemento from Buscar(NULL::elemento,'cod_elemento',''||campo_recebido.elemento||'');
	
	if verifica_elemento(monstro1_recebido_elemento.nome, monstro2_recebido_elemento.nome) = true then 
		atk_total_monstro2 := atk_total_monstro2 - monstro2_recebido.nivel * 10;
	
	else
		atk_total_monstro1 := atk_total_monstro1 - monstro1_recebido.nivel * 10;
	end if;
	
	-- REGRA CAMPO
	if verifica_elemento(campo_recebido_elemento.nome, monstro1_recebido_elemento.nome) = true then
		atk_total_monstro1 := atk_total_monstro1 -  monstro1_recebido.nivel * 10;
	end if;
		
	if verifica_elemento(campo_recebido_elemento.nome, monstro2_recebido_elemento.nome) = true then
		atk_total_monstro2 := atk_total_monstro2 -  monstro2_recebido.nivel * 10;
	end if;
	
	
	if (atk_total_monstro1 > atk_total_monstro2) then
		vencedor := monstro1_recebido.nome;
	else
		vencedor := monstro2_recebido.nome;
	end if;

	perform(select inserir('partida','''now()'','||cenario_temp.cod_cenario||''));
	select max(cod_partida) into cod_part from partida;
	perform(select inserir('duelo',''''||cod_part||''','''||monstro1_recebido.cod_carta||''','''||vencedor||''''));
	perform(select inserir('duelo',''''||cod_part||''','''||monstro2_recebido.cod_carta||''','''||vencedor||''''));
	perform (select inserir('duelo',''''||cod_part||''','''||campo_recebido.cod_carta||''','''||vencedor||''''));
	
	return vencedor;
	
end;
$$ language plpgsql;

eletrico 1 60 61
agua 4 151 71
eletrico 201

select * from Duelar('''pikachu''','''baleia''', '''campo magnetico''','''casa''');

select * from partida;		
select * from tipo;
select * from duelo;
select * from carta;
select * from Equipar_Carta('aaa','bbb');
-- equipar em duelo. Quando acabar o duelo retornar para nulo a carta aquipamento.

equipar(1,5); -- update; 
batalha(1,2); -- logica de pontos.

--------------------------------------------------------------------------------
create or replace function verifica_elemento(monstro_elem text, monstro2_elem text) returns boolean as $$
declare
begin
		if monstro_elem ilike monstro2_elem then
			return null;
		end if;
		
		if monstro_elem ilike 'agua' and monstro2_elem ilike 'fogo' or
		monstro_elem ilike 'agua' and monstro2_elem ilike 'terra' or
		monstro_elem ilike 'agua' and monstro2_elem ilike 'planta' or
		monstro_elem ilike 'fogo' and monstro2_elem ilike 'planta' or	
		monstro_elem ilike 'fogo' and monstro2_elem ilike 'eletrico' or	
		monstro_elem ilike 'eletrico' and monstro2_elem ilike 'agua' or
		monstro_elem ilike 'planta' and monstro2_elem ilike 'agua' or
		monstro_elem ilike 'planta' and monstro2_elem ilike 'eletrico' or
		monstro_elem ilike 'planta' and monstro2_elem ilike 'terra' or
		monstro_elem ilike 'terra' and monstro2_elem ilike 'fogo' or
		monstro_elem ilike 'terra' and monstro2_elem ilike 'eletrico' then
			return true;
		else
			return false;
		end if;	
		

end;
$$ language plpgsql;
--------------------------------------------------------------------------------
create or replace function verifica_nivel(nivel int) returns boolean as $$
declare
begin
	
end;
$$ language plpgsql;
---------------------------------------------------------------------------------
create or replace function inserir(tabela text, valores text) returns void as $$
declare

begin			   
	if tabela ilike 'duelo' then
		execute 'insert into ' || quote_ident(tabela) || ' values('||valores||')'
		using valores;
	
	else
		execute 'insert into ' || quote_ident(tabela) || ' values(default, '||valores||')'
		using valores;
		
	end if;
	
end;
$$ language plpgsql;
select * from tipo;
select inserir('carta','''teste'',''50'',''1''');
select * from carta;
select inserir('cenario','''casa''');
select * from elemento;
select * from partida;
select * from cenario;
ALTER TABLE duelo 
DROP COLUMN cenario;

update carta set equipamento = null where nivel = 1;

'amador,
profissional,
mestre,
lenda
anciao'