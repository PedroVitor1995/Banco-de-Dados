create or replace function realiza_emprestimo(nome_leitor varchar,livro int)
returns void as $$
	declare
	cod_leitor_temp int;
	cod_reserva int;
	leitor_reserva int;
	begin
		select cod_leitor into cod_leitor_temp from leitor where nome_leitor = nome;
		select cod_res into cod_reserva from reserva where livro = cod_livro and status = 'ativo';

		if cod_reserva is null then
			insert into emprestimo values(default,cod_leitor_temp,livro,current_date);
		else
			select cod_res into leitor_reserva from reserva where cod_leitor_temp = cod_leitor;
			if leitor_reserva is not null and cod_reserva is null then
				insert into emprestimo values(default,cod_leitor_temp,livro,current_date);
				update reserva set status='inativo' where leitor_reserva = cod_res;
			else
				raise exception 'O livro já estar reservado';
			end if;
		end if;
		
	end;
$$ language 'plpgsql';


insert into leitor values(1,'Pedro')
insert into leitor values(2,'Maria')
insert into leitor values(3,'Paula')
insert into leitor values(4,'João')

insert into livro values(1,'Historia')
insert into livro values(2,'Português')
insert into livro values(3,'Matematica')
insert into livro values(4,'Artea')

insert into reserva values(1,2,3,'inativo')
insert into reserva values(2,1,4,'ativo')
insert into reserva values(3,2,1,'ativo')

select realiza_emprestimo('Pedro',1)


select * from leitor
select * from livro
select * from reserva
select * from emprestimo

