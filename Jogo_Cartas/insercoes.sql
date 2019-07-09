-- Inserindo cenario
select inserir('cenario','''shopping''');
select inserir('cenario','''w''');

-- Inserindo tipo
select inserir('','''campo''');
select inserir('tipo','''m''');

-- Inserindo jogador
select inserir('jogador','''Pedro''');
select inserir('jogador','''w''');

-- Inserindo elemento
select inserir('elemento','''terra''');
select inserir('elemento','''e''');
select inserir('elemento','''ar''');

drop trigger acionar_resticao_carta_monstro on carta;
ALTER TABLE carta
DISABLE TRIGGER acionar_restricao_carta_monstro;

select * from information_schema.triggers
-- Inserindo nivel
select inserir('nivel','''Lenda'',''201''');
select inserir('nivel','''I'',''50''');
select inserir('nivel','''In'',''-50''');
select * from carta;
select * from partida;
select * from duelo;
select * from nivel;
select * from jogador;
-- Inserindo carta
select * from nova_carta('''healer''','''magica''',50,'''Icaro''');
select nova_carta('''''','''monstro''',1,'''eletrico''','''Pedro''');

select * from nova_carta('''campo eletrico''','''campo''','''eletrico''','''icaro''');
select * from elemento;
-- Realizar duelo
select Duelar(null, null, null, null);

-- Rank dos jogadores 
create view rank_jogador as select nome,pontos from jogador order by pontos desc;
s

pikachu 1
squirtel 2

20 20
51-40 11
1 6 
1  11
51 11
1 51
select equipar_carta('''pikachu''', '''healer''');
select Duelar('''squirtel''','''pikachu''','''campo eletrico''','''ifpi''');

-- Consultar
select * from carta
select * from cenario
select * from duelo
select * from elemento
select * from jogador
select * from nivel
select * from partida
select * from tipo
select * from rank_jogador

update carta set elemento = 3 where cod_carta = 3;

