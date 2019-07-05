create table assunto(
	cod_assunto serial primary key,
	descricao varchar(100)
);

create table editora(
	cod_editora serial primary key,
	CNPJ varchar(100),
	razaoSocial varchar(100)
);

create table nacionalidade(
	cod_nacional serial primary key,
	descricao varchar(100)
);

create table autor(
	cod_autor serial primary key,
	CPF varchar(100),
	nome varchar(100),
	dt_nasc date,
	cod_nacional int,
	foreign key (cod_nacional) references nacionalidade(cod_nacional)
);

create table livro(
	cod_livro serial primary key,
	ISBN varchar(100),
	titulo varchar(100),
	preco float,
	dataLancamento date,
	cod_assunto int,
	cod_editora int,
	foreign key (cod_assunto) references assunto(cod_assunto),
	foreign key (cod_editora) references editora(cod_editora)
);

create table autor_livro(
	cod_autor int,
	cod_livro int,
	foreign key (cod_autor) references autor(cod_autor),
	foreign key (cod_livro) references livro(cod_livro)
);


insert into assunto values(1,'Informatica')
insert into assunto values(2,'Matematica')
insert into assunto values(3,'Portugues')
insert into assunto values(4,'Historia')
insert into assunto values(5,'Geografia')
insert into assunto values(6,'Estrutura de Dados')

insert into editora values(1,'858567','Modernizar')
insert into editora values(2,'123445','Qualificar')
insert into editora values(3,'909844','Intensificar')
insert into editora values(4,'108965','Orientar')
insert into editora values(5,'787573','Atualizar')
insert into editora values(6,'987478','Melhorar')
insert into editora values(7,'435363','Books Editora')

insert into nacionalidade values(1,'Brasileiro')
insert into nacionalidade values(2,'Italiano')
insert into nacionalidade values(3,'Argentino')
insert into nacionalidade values(4,'Espanhol')
insert into nacionalidade values(5,'Ingles')

insert into autor values(1,'12346','Pedro','1995-12-02',1)
insert into autor values(2,'78488','Maria','1980-05-23',2)
insert into autor values(3,'53265','Joana','2000-11-21',3)
insert into autor values(4,'19208','Mario','1986-01-22',4)
insert into autor values(5,'84646','Francisco','1990-10-19',5)
insert into autor values(6,'24356','Clara','1980-09-29',1)
insert into autor values(7,'45637','Machado de Assis','1930-03-23',1)
insert into autor values(8,'34256','Luis','2000-10-01',4)
insert into autor values(9,'29876','João','1978-12-30',5)
insert into autor values(10,'99001','Inacio João','1950-02-03',2)
insert into autor values(11,'83727','Teresa','1910-11-23',3)
insert into autor values(12,'54638','Rosa Maria','1902-08-15',4)
insert into autor values(13,'87587','Angelo','1890-10-25',4)
insert into autor values(14,'12093','Rodrigo','1888-01-05',1)

insert into livro values(1,'718975','Banco de Dados',125.00,'2019-05-05',1,2)
insert into livro values(2,'777436','Algoritmos',200.00,'2018-09-15',1,3)
insert into livro values(3,'312432','Algebra linear',280.00,'2010-11-30',2,1)
insert into livro values(4,'656548','Probabilidade',250.00,'2019-05-05',2,3)
insert into livro values(5,'989066','Leitura textual',300.00,'2009-04-25',3,2)
insert into livro values(6,'343487','Globalização mundial',90.00,'2019-05-05',5,1)
insert into livro values(7,'454546','Regras gramaticais',340.00,'2019-05-05',3,2)
insert into livro values(8,'674376','Mapa Mundi',40.00,'2019-05-01',5,3)
insert into livro values(9,'563688','Interação de dados',50.50,'2019-01-19',1,4)
insert into livro values(10,'874903','Bancos de Dados',190.00,'2000-11-29',1,3)
insert into livro values(11,'564864','Uso matematico no Banco do Brasil',29.00,'1995-05-25',2,1)
insert into livro values(12,'768764','Arvore binária',170.00,null,6,5)

insert into autor_livro values(1,2)
insert into autor_livro values(2,1)
insert into autor_livro values(3,7)
insert into autor_livro values(6,3)
insert into autor_livro values(5,4)
insert into autor_livro values(4,5)



							-- LISTAR DE EXERCICIO 1 -- 
 
-- 1. Livros que possuam preços superiores a R$ 50,00.
	select titulo from livro where preco > 50
	
-- 2. Livros que possuam preços entre R$ 100,00 e R$ 200,00. 
	select titulo from livro where preco >= 100 and preco <=200
	
-- 3. Livros cujos títulos possuam a palavra ‘Banco’.
	select titulo from livro where titulo ilike '%Banco%'
	
-- 4. Livros cujos títulos iniciam com a palavra ‘Banco’. 
	select titulo from livro where titulo ilike 'Banco%'
	
-- 5. Livros cujos títulos terminam com a palavra ‘Dados’.
	select titulo from livro where titulo ilike '%Dados'
	
-- 6. Livros cujos títulos possuem a expressão ‘Banco de Dados’ ou ‘Bancos de Dados’. 
	select titulo from livro where titulo ilike '%Banco de Dados%' or titulo ilike '%Bancos de Dados%'
	
-- 7. Livros que foram lançados há mais de 5 anos.
	select titulo from livro where age(current_date,dataLancamento) > '5 year'
	
-- 8. Livros que ainda não foram lançados, ou seja, com a data de lançamento nula. 
	select titulo from livro where dataLancamento is null

-- 9. Livros cujo assunto seja ‘Estrutura de Dados’. 
	select titulo from livro natural join assunto where descricao='Estrutura de Dados'

-- 10. Livros cujo assunto tenha código 1, 2 ou 3. 
	select titulo from livro where cod_livro=1 or cod_livro=2 or cod_livro=3
	
-- 11. Quantidade de livros. 
	select count(cod_livro) from livro
	
-- 12. Quantidade de livros que ainda não foram lançados, ou seja, com a data de lançamento nula. 
	select count(cod_livro) from livro where dataLancamento is null
	
-- 13. Somatório dos preços dos livros. 
	select sum(preco) from livro
	
-- 14. Média de preços dos livros.
	select avg(preco) from livro
	
-- 15. Maior preço dos livros. 
	select max(preco) from livro
	
-- 16. Menor preço dos livros. 
	select min(preco) from livro
	
-- 17. O preço médio dos livros para cada assunto.
	select descricao,avg(preco) from livro natural join assunto group by descricao
	
-- 18. Quantidade de livros para cada assunto. 
	select descricao,count(cod_livro) from livro natural join assunto group by descricao
	
-- 19. O preço do livro mais caro de cada assunto, dentre aqueles que já foram lançados.
	select descricao,max(preco) from livro natural join assunto where cod_livro in
	(select cod_livro from livro where dataLancamento is not null)
	group by descricao
	
-- 20. Quantidade de livros lançados por editora. 
	select razaosocial,count(cod_livro) from livro natural join editora where cod_livro in
	(select cod_livro from livro where dataLancamento is not null)
	group by razaosocial
	
-- 21. Assuntos cujo preço médio dos livros ultrapassa R$ 50,00. 
	select descricao from assunto where cod_assunto in
	(select cod_assunto from assunto natural join livro
	 group by cod_assunto having avg(preco)>50)
	 
-- 22. Assuntos que possuem pelo menos 2 livros.
	select descricao from assunto where cod_assunto in
	(select cod_assunto from assunto natural join livro 
	group by cod_assunto having count(cod_livro)>=2)
	
-- 23. Assuntos que possuem pelo menos 2 livros já lançados. 
	select descricao from assunto where cod_assunto in
	(select cod_assunto from assunto natural join livro 
	where dataLancamento is not null
	group by cod_assunto having count(cod_livro)>=2)
	
-- 24. Quantidade de livros lançados por assunto.
	select descricao,count(cod_livro) from assunto natural join livro where dataLancamento is not null
	group by descricao
	
-- 25. Nome e CPF dos autores que possuem a palavra ‘João’ no nome.
	select nome,cpf from autor where nome ilike '%João%' 
	
-- 26. Nome e CPF dos autores que nasceram após 1° de janeiro de 1970.  
	select nome,cpf from autor where dt_nasc > '1970-01-01'
	
-- 27. Nome e CPF dos autores que não são brasileiros.
	select nome,cpf from autor natural join nacionalidade where descricao != 'Brasileiro'

-- 28. Quantidade de autores. 
	select count(cod_autor) from autor
	
-- 29. Quantidade média de autores dos livros. 	
-- 30. Livros que possuem ao menos 2 autores. 
-- 31. Preço médio dos livros por editora.
	select razaosocial,avg(preco) from livro natural join editora
	group by razaosocial

-- 32. Preço máximo, preço mínimo e o preço médio dos livros cujos códigos do assunto são 1, 2 ou 3, para cada editora.
	select razaosocial,max(preco),min(preco),avg(preco) from livro natural join editora
	where cod_assunto between 1 and 3
	group by razaosocial
	
-- 33. Quantidade de autores para cada nacionalidade.
	select descricao,count(cod_autor) from autor natural join nacionalidade group by descricao
	
-- 34. Quantidade de autores que nasceram antes de 1°de janeiro de 1920, para cada nacionalidade.
	select descricao,count(cod_autor) from autor natural join nacionalidade where dt_nasc < '1920-01-01'
	group by descricao
	
-- 35. A data de nascimento do autor mais velho. 
	select min(dt_nasc) from autor
	
-- 36. A data de nascimento do autor mais novo. 
	select max(dt_nasc) from autor
		
-- 37. Os novos preços dos livros se os valores fossem reajustados em 10%. 
-- 38. O dia da publicação do livro de código 1. 
	select dataLancamento from livro where cod_livro=1
	
-- 39. O mês e o ano da publicação dos livros cujo assunto tem código 1. 
	select extract(month from dataLancamento)as mes,extract(year from dataLancamento) as ano from livro
	where cod_assunto=1
	
-- 40. Quantidade de autores distintos que estão associados a livros na tabela AUTOR_LIVRO. 
	select count(distinct cod_autor) from autor_livro
	
-- 41. Listagem dos livros contendo título, assunto e preço, ordenada em ordem crescente por assunto e decrescente por preço. 
-- 42. Listagem contendo os nomes da editoras, ordenados alfabeticamente. A coluna de nomes deve ter a palavra ‘Editora’ como título. 
-- 43. Listagem contendo os preços e os títulos dos livros, ordenada em ordem decrescente de preço. 
-- 44. Editoras que já publicaram livros, sem repetições.
	select * from editora natural join livro

-- 45. Listagem dos nomes dos autores brasileiros com mês e ano de nascimento, por ordem decrescente de idade e por 
-- ordem crescente de nome do autor.
-- 46. Listagem com 3 colunas, editora (sigla da editora), assunto (código do assunto) e quantidade (livros publicados 
-- pela editora para cada assunto), em ordem decrescente de quantidade. 
-- 47. Títulos cujo título tenha comprimento superior a 15 caracteres. 
-- 48. Títulos dos livros já lançados e a descrição dos seus assuntos. 
	select titulo,descricao from livro natural join assunto where dataLancamento is not null
	
-- 49. Título do livro, nome da editora que o publicou e a descrição do assunto.
	select titulo,razaosocial,descricao from livro natural join assunto natural join editora
	where dataLancamento is not null
	
-- 50. Listagem das editoras e dos títulos dos livros lançados pela editora, ordenada por nome da editora e pelo título do livro. 
-- 51. Listagem das editoras cadastradas e para aquelas que possuem livros publicados, relacionar também o 
-- título do livro, ordenada pelo nome da editora e pelo título do livro. 
-- 52. Listagem de assuntos, contendo os títulos dos livros dos respectivos assuntos, ordenada pela descrição do assunto. 
-- 53. Listagem de todos os títulos e de todas as editoras, relacionando a obra com a editora que a publica, quando for o caso. 
-- 54. Listagem com a descrição de todos os assuntos e os títulos dos livros de cada um. Quando não existir um livro 
-- associado ao assunto, escrever o texto ‘Sem publicações’. 
-- 55. Listagem dos nomes dos autores e os livros de sua autoria, ordenada pelo nome do autor.
-- 56. Editoras que publicaram livros escritos pelo autor ‘Machado de Assis’. 
-- 57. Quantidade de livros lançados que foram escritos por um autor cujo nome possui a palavra ‘Luis’. 
-- 58. O preço do livro mais caro publicado pela editora ‘Books Editora’ sobre banco de dados. 
-- 59. Listagem das editoras que não publicaram livros.
	select * from editora where cod_editora not in
	(select cod_editora from editora natural join livro)
	
-- 60. Título do livro e o nome da editora que o publica para todos os livros que custam menos que R$ 50,00.
	select titulo,razaosocial from livro natural join editora where dataLancamento is not null and preco<50 
	
-- 61. Nome e CPF do autor brasileiro que tenha nascido antes de 1° de janeiro de 1950 e os títulos dos livros de
-- sua autoria, ordenado pelo nome do autor e pelo título do livro.
-- 62. Nome e CPF do autor e o preço máximo dos livros de sua autoria. 
	select nome,cpf,max(preco) from autor natural join autor_livro natural join livro
	group by nome,cpf

-- 63. Listagem do nome do autor e nome da editora que já lançaram pelo menos 2 livros. 
-- 64. Descrição do assunto referenciado em pelo menos 10 livros.
-- 65. Nomes das editoras que possuem livros lançados.
	select razaosocial from editora where cod_editora in
	(select cod_editora from editora natural join livro where dataLancamento is not null)
	
-- 66. Assuntos não foram lançados livros.	
-- 67. Excluir as editoras que não publicaram livros. 
-- 68. Descrição dos assuntos e quantidade de livros lançados de cada um. 
	select descricao,count(cod_livro) from assunto natural join livro where dataLancamento is not null
	group by descricao
	
-- 69. Nome das editoras e o preço médio dos livros de cada uma. 
	select razaosocial,avg(preco) from editora natural join livro
	group by razaosocial

-- 70. Nome das editoras e os livros das editoras que lançaram ao menos 2 livros, ordenados pelo nome da editora 
-- e pelo título da publicação.
-- 71. Títulos dos livros dos assuntos cujo preço médio do livro é superior a R$ 40,00, juntamente com os respectivos assuntos. 
-- 72. Títulos dos livros cujo assunto é ‘Banco de Dados’ ou que foram lançados por editoras que contenham ‘Books’ no nome. 
-- 73. Títulos dos livros cujo assunto é ‘Banco de Dados’ e que foram lançados por editoras que contenham ‘Books’ no nome. 
-- 74. Títulos dos livros cujo assunto é ‘Banco de Dados’ e que não foram lançados por editoras que contenham ‘Books’ no nome. 
-- 75. Títulos dos livros que não foram lançados por editoras que contenham ‘Books’ no nome cujo assunto é ‘Banco de Dados’. 
