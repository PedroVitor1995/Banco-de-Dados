-- Inserindo cenario
select inserir('cenario','''casa''');
select inserir('cenario','''w''');

-- Inserindo tipo
select inserir('tipo','''monstro''');
select inserir('tipo','''m''');

-- Inserindo jogador
select inserir('jogador','''Pedro''');
select inserir('jogador','''w''');

-- Inserindo elemento
select inserir('elemento','''eletrico''');
select inserir('elemento','''e''');
select inserir('elemento','''ar''');


-- Inserindo nivel
select inserir('nivel','''Iniciante'',''50''');
select inserir('nivel','''I'',''50''');
select inserir('nivel','''In'',''-50''');

-- Inserindo carta
select nova_carta('''campo magnetico''','''monstro''',1,'''eletrico''','''Pedro''');
select nova_carta('''''','''monstro''',1,'''eletrico''','''Pedro''');

-- Realizar duelo
select Duelar(null, null, null, null);

-- Rank dos jogadores 
create view rank_jogador as select nome,pontos from jogador order by pontos desc;


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



