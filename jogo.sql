create table jogador(
	cod_jogador serial primary key not null,
	nome varchar(50) not null,
	pontos int not null default 0
);

create table nivel(
	cod_nivel serial primary key not null,
	descricao varchar(50) not null,
	valor int not null
);

create table tipo(
	cod_tipo serial primary key not null,
	nome varchar(50) not null
);

create table elemento(
	cod_elemento serial primary key not null,
	nome varchar(50) not null
);

create table partida(
	cod_partida serial primary key not null,
	data_partida date not null,
	valor int not null
);

create table local_partida(
	cod_local serial primary key not null,
	nome varchar(50) not null 
);

create table carta(
	cod_carta serial primary key not null,
	nome varchar(50) not null,
	atk int not null,
	def int not null,
	tipo int,
	nivel int,
	elemento int,
	equipamento int,
	pontuacao int not null default 0,
	foreign key (tipo) references tipo(cod_tipo),
	foreign key (nivel) references nivel(cod_nivel),
	foreign key (elemento) references elemento(cod_elemento),
	foreign key (equipamento) references carta(cod_carta)
);

create table duelo(
	partida int not null,
	carta int not null,
	local_duelo int, 
	vencedor text not null,
	primary key(partida, carta),
	foreign key (partida) references partida(cod_partida),
	foreign key (carta) references carta(cod_carta),
	foreign key (local_duelo) references local_partida(cod_local)
);
