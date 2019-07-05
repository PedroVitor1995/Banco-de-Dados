----------------------------------------------------------------------------------
create or replace function restricao_carta()
returns trigger as $$
begin
	return new;
end;
$$ language plpgsql;

create trigger acionar_restricao_carta
before insert or update on reserva
for each row
execute procedure restricao_carta();
----------------------------------------------------------------------------------