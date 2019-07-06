-- Inserindo cenario
select inserir('cenario','''casa''');

-- Inserindo tipo
select inserir('tipo','''monstro''');

-- Inserindo jogador
select inserir('jogador','''Pedro''');

-- Inserindo elemento
select inserir('elemento','''eletrico''');

-- Inserindo nivel
select inserir('nivel','''Iniciante'',''50''');

-- Inserindo carta
select nova_carta('''campo magnetico''','''monstro''',1,'''eletrico''','''Pedro''');

-- Realizar duelo



-- Consultar
select * from carta
select * from cenario
select * from duelo
select * from elemento
select * from jogador
select * from nivel
select * from partida
select * from tipo



