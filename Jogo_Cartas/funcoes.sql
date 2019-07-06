--------------------------------------------------------------------------------------------------------------------------
create or replace function nova_carta(nome_carta varchar, tipo_carta varchar, nivel_carta int,
									  elemento_carta varchar, jogador_carta varchar) 
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
	if nome_carta is null or tipo_carta is null or nivel_carta is null or
		elemento_carta is null or jogador_carta is null then
		raise exception 'Não é permitido valores nulos';
	end if;

	if length(trim(both '''' from nome_carta)) < 3 then
		raise exception 'O nome da carta deve ter pelos menos dois caracteres';
	end if;

	select * into carta_recebida from Buscar(NULL::carta, 'nome', nome_carta);
	select cod_tipo into cod_tipo_temp from Buscar(NULL::tipo, 'nome', tipo_carta);
	select valor into valor_temp from Buscar(NULL::nivel, 'cod_nivel', ''||nivel_carta||'');
	select cod_elemento into cod_elemento_temp from Buscar(NULL::elemento, 'nome', ''||elemento_carta||'');
	select cod_jogador into cod_jogador_temp from Buscar(NULL::jogador, 'nome', jogador_carta);

	if carta_recebida.nome is not null then
		raise exception 'Já existe carta com o nome %', nome_carta; 
	end if; 

	if tipo_carta not ilike '''monstro''' then
		raise exception 'Carta % não pode ser cadastrada. Tipo incompativel com os valores passados', nome_carta;
	end if;

	if cod_tipo_temp is  null then
		raise exception 'Tipo % não existe',tipo_carta;
	end if;

	if valor_temp is null then
		raise exception 'Nivel % não existe',nivel_carta;
	end if;

	if cod_elemento_temp is null then
		raise exception 'Elemento % não existe',elemento_carta;
	end if;

	if cod_jogador_temp is null then
		raise exception 'Jogador % não existe',jogador_carta;
	end if;

	-- saber o ataque da carta dependendo do nivel que ele passar. Se a carta for tipo monstro ok. senao ''null''
	perform inserir('carta',''||nome_carta||','''||valor_temp||''','''||cod_tipo_temp||''','''||nivel_carta||''',
							'''||cod_elemento_temp||''',null,null,'''||cod_jogador_temp||'''');
	return query select * from carta where cod_carta in (select max(cod_carta) from carta);

end;
$$ language plpgsql;
--------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
-- BUSCAR UM REGISTRO NA TABELA;
create or replace function Buscar(tabela anyelement, chave varchar, valor varchar) returns setof anyelement as $$
declare
begin
	
	 return query EXECUTE format('
      SELECT *
      FROM  %s  -- pg_typeof returns regtype, quoted automatically
      WHERE '||chave||' = '||valor||'',pg_typeof(tabela));
	  
end;
$$ language plpgsql;
--------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
-- EQUIPAR UMA CARTA COM OUTRA
create or replace function equipar_carta(monstro varchar, magica varchar) 
returns setof carta as $$

declare
atk_final int;
monstro_existe boolean := Existe('carta', monstro);
magica_existe boolean := Existe('carta', magica);
monstro_recebido carta%rowtype;
magica_recebido carta%rowtype;
tipo_recebido_monstro tipo%rowtype;
tipo_recebido_magica tipo%rowtype;
begin
	if monstro is null or magica is null then
		raise exception 'Não é permitido valores nulos';
	end if;
	
	select * into monstro_recebido from Buscar(NULL::carta,'nome',monstro);
	select * into magica_recebido from Buscar(NULL::carta,'nome',magica);
	select * into tipo_recebido_monstro from Buscar(NULL::tipo,'cod_tipo',''||monstro_recebido.tipo||'');
	select * into tipo_recebido_magica from Buscar(NULL::tipo,'cod_tipo',''||magica_recebido.tipo||'');
		
	if monstro_recebido.cod_carta is null then
		raise exception 'Carta com o nome % não existe', monstro;
	end if;
	
	if magica_recebido.cod_carta is null then
		raise exception 'Carta com o nome % não existe', magica;
	end if;
	
	if tipo_recebido_monstro.nome not ilike 'monstro' or tipo_recebido_magica.nome not ilike 'magica' then
		raise exception 'Tipo incompativeis aos nomes passados';
	end if;
	
	if monstro_recebido.jogador <> magica_recebido.jogador then
		raise exception 'Equipamento invalido. Cartas de jogadores diferentes';
	end if;
	
	if(monstro_recebido.equipamento is not null)then 
		raise exception 'Carta ja equipada para duelar';
	end if;
	
	update carta set equipamento = magica_recebido.cod_carta where cod_carta = monstro_recebido.cod_carta;
	return query select * from carta where cod_carta = monstro_recebido.cod_carta;
	
end;
$$ language plpgsql;
--------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
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
cod_carta_vencedora int;
nivel_carta_vencedora int;
jogador_carta_vecedora int;
cod_part int;
teste int;
atk_total_monstro1 real;
atk_total_monstro2 real;
cenario_temp cenario%rowtype;
begin

	if monstro1 is null or monstro2 is null or campo is null or cenario is null then
		raise exception 'Não é permitido valores nulos';
	end if;
	
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
		raise exception 'Carta campo invalida';
	end if;
	
	if cenario_temp.cod_cenario is null then
		raise exception 'Cenario %s não existe', cenario_temp;
	end if;
	
	if monstro1_recebido.jogador = monstro2_recebido.jogador then
		raise exception 'Cartas de um mesmo jogador não são permitidas para o duelo';
	end if;
	
	if monstro1 = monstro2 then
		if monstro1 = ilike 'campo' then
			raise exception 'Não é permitido duelar com duas cartas %',monstro1;
		end if;
		
		if monstro1 = ilike 'magica' then
			raise exception 'Não é permitido duelar com duas cartas %',monstro1;
		end if;
	end if;
	
	atk_total_monstro1 := monstro1_recebido.atk;
	atk_total_monstro2 := monstro2_recebido.atk;
	
	if monstro1_recebido.equipamento is not null then 
		select * into monstro1_recebido_equipamento from Buscar(NULL::carta,'cod_carta',''||monstro1_recebido.equipamento||'');
		atk_total_monstro1 :=  atk_total_monstro1 + monstro1_recebido_equipamento.pontos_magia; 
		update carta set equipamento = null where cod_carta = monstro1_recebido.cod_carta;
	end if;
	
	if monstro2_recebido.equipamento is not null then 
		select * into monstro2_recebido_equipamento from Buscar(NULL::carta,'cod_carta',''||monstro2_recebido.equipamento||'');
		atk_total_monstro2 := atk_total_monstro2 + monstro2_recebido_equipamento.pontos_magia; 
		update carta set equipamento = null where cod_carta = monstro2_recebido.cod_carta;
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
		cod_carta_vencedora := monstro1_recebido.cod_carta;
		nivel_carta_vencedora := monstro1_recebido.nivel;
		jogador_carta_vecedora := monstro1_recebido.jogador;
	else
		vencedor := monstro2_recebido.nome;
		cod_carta_vencedora := monstro2_recebido.cod_carta;
		nivel_carta_vencedora := monstro2_recebido.nivel;
		jogador_carta_vecedora := monstro2_recebido.jogador;
	end if;

	perform(select inserir('partida','''now()'','||cenario_temp.cod_cenario||''));
	select max(cod_partida) into cod_part from partida;
	perform(select inserir('duelo',''''||cod_part||''','''||monstro1_recebido.cod_carta||''',
						   '''||vencedor||''','''||atk_total_monstro1||''''));
	perform(select inserir('duelo',''''||cod_part||''','''||monstro2_recebido.cod_carta||''',
						   '''||vencedor||''','''||atk_total_monstro2||''''));
	perform (select inserir('duelo',''''||cod_part||''','''||campo_recebido.cod_carta||''',
							'''||vencedor||''',''0'''));
	
	update carta set atk = atk + (6 - nivel_carta_vencedora) where cod_carta = cod_carta_vencedora;
	update jogador set pontos = pontos + 3 where cod_jogador = jogador_carta_vecedora;
	perform verifica_nivel(cod_carta_vencedora);
	
	return vencedor;
end;
$$ language plpgsql;
--------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
create or replace function verifica_nivel(carta_nivel int) returns void as $$
declare
carta_recebida carta%rowtype;
valor_prox_nivel int;
begin

	select * into carta_recebida from carta where cod_carta = carta_nivel;
	
	if(carta_recebida.nivel = 5)then
		return;
	end if;
	
	select valor into valor_prox_nivel from nivel where cod_nivel =(carta_recebida.nivel + 1);
	
	if carta_recebida.atk = valor_prox_nivel then
		update carta set nivel = carta_recebida.nivel + 1 where cod_carta = carta_recebida.cod_carta;
	end if;
	
end;
$$ language plpgsql;
--------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
create or replace function inserir(tabela text, valores text) returns void as $$
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
--------------------------------------------------------------------------------------------------------------------------