use clinica_medica;

CREATE TABLE paciente (
	cpf varchar (14) PRIMARY KEY,
	nome_paciente varchar(40), 
	telefone varchar (14),
	numero_plano int,
	nome_plano varchar (20),
	tipo_plano varchar (10)
);

CREATE TABLE medico(
	crm int PRIMARY KEY,
	nome_medico varchar (30),
	especialidade varchar (20),
);

CREATE TABLE consulta(
	numero_consulta int identity (22000,1) PRIMARY KEY,
	data_consulta date,
	horario_consulta time,
	fk_paciente_cpf varchar(14),
	fk_medico_crm int
);

CREATE TABLE pedido_exame(
	numero_pedido int identity (2200,1) PRIMARY KEY,
	resultado varchar(40),
	data_exame date,
	valor_pagar money,
	fk_consulta_numero_consulta int,
	fk_exame_codigo int
);

CREATE TABLE exame(
	codigo int PRIMARY KEY,
	especificacao varchar (20),
	preco money
);

ALTER TABLE pedido_exame ADD CONSTRAINT fk_pedido_exame_2
	FOREIGN KEY (fk_consulta_numero_consulta)
	REFERENCES consulta (numero_consulta)
	ON DELETE CASCADE;

ALTER TABLE pedido_exame ADD CONSTRAINT fk_pedido_exame_3
	FOREIGN KEY (fk_exame_codigo)
	REFERENCES exame (codigo);
--   ON DELETE RESTRICT;

ALTER TABLE consulta ADD CONSTRAINT fk_consulta_2
	FOREIGN KEY (fk_paciente_cpf)
	REFERENCES paciente (cpf)
	ON DELETE CASCADE;

ALTER TABLE consulta ADD CONSTRAINT fk_consulta_3
	FOREIGN KEY (fk_medico_crm)
	REFERENCES medico (crm)
	ON DELETE CASCADE;

--- Inclusão -----
--tabela paciente---
insert into paciente values ('012.345.678-90','Leonardo Ribeiro','(11)91234-5678', 123456,'Inovamed','Padrão');
insert into paciente values ('123.456.789-12','Bruna Alves','(15)92345-6789',234567,'Ultramed','Basico');
insert into paciente values ('234.567.890-23', 'Gilberto Barros','(11)94567-8901',345678,'Inovamed','Especial');
insert into paciente values	('345.678.901-45','Maria Pereira','(12)95678-9012',456789,'Ultramed','Padrão');
insert into paciente values ('456.789.012-34','Arnaldo Coelho','(19)96789-0123',567890,'Inovamed','Especial');
insert into paciente values ('456.457.234-43','Geovani Oliveira','(19)97889-0123',567860,'Inovamed','Especial');
SELECT * FROM paciente;

--tabela medico---
insert into medico values(102030,'Agildo Nunes','Cardiologia');
insert into medico values(203040,'Marcia Alves','Gastrologia');
insert into medico values(304050,'Roberto Gusmão','Neurologia');
insert into medico values(405060,'Edna Cardoso','Ortopedia');
insert into medico values(506070,'Ricardo Souza','Otorrinolaringologia');
insert into medico values(607080,'Lucia Marques','Pediatria');
insert into medico values(708090,'Beatriz Lucena','Oncologia');

SELECT * from medico;

--tebela exames---
insert into exame values(10020,'Hemograma',100.00);
insert into exame values(10030,'Tomografia',250.00);
insert into exame values(10040,'Ultrassonografia',550.00);
insert into exame values(10050,'Ressonancia',800.00);
insert into exame values(10060,'Radiografia',70.00);
insert into exame values(10070,'Mamografia',150.00);
insert into exame values(10080,'Endoscopia',300.00);
insert into exame values(10090,'Colonoscopia',300.00);
insert into exame values(10100,'Eletrocariograma',50.00);
insert into exame values(10110,'Ecocardiograma',120.00);
insert into exame values(10120,'Audiometria',65.00);

SELECT * from exame;

--tabela consulta--
insert into consulta values('2022/12/12','14:30','012.345.678-90',102030);
insert into consulta values('2022/12/13','15:00','123.456.789-12',203040);
insert into consulta values('2022/12/14','15:30','234.567.890-23',304050);
insert into consulta values('2022/12/15','16:00','345.678.901-45',405060);
insert into consulta values('2022/12/16','16:30','456.789.012-34',506070);
insert into consulta values('2022/12/17','17:00','012.345.678-90',607080);
insert into consulta values('2022/12/18','17:30','123.456.789-12',708090);
insert into consulta values('2022/12/19','08:00','234.567.890-23',405060);
insert into consulta values('2022/12/20','08:30','345.678.901-45',102030);
insert into consulta values('2022/12/21','09:00','456.789.012-34',506070);

SELECT * from consulta;

--tabela pedido exame--
insert into pedido_exame values('Normal','2022/12/15',0.00,22000,10040);
insert into pedido_exame values('','2022/12/19',0.00,22000,10100);
insert into pedido_exame values('','2022/12/16',0.00,22001,10080);
insert into pedido_exame values('Normal','2022/12/15',0.00,22002,10050);
insert into pedido_exame values('Inconsistente','2022/12/16',0.00,22003,10080);
insert into pedido_exame values('','2022/12/17',0.00,22004,10060);
insert into pedido_exame values('Normal','2022/12/21',0.00,22007,10020);
insert into pedido_exame values('','2022/12/22',0.00,22008,10030);
insert into pedido_exame values('','2022/12/22',0.00,22008,10050);

SELECT * from pedido_exame;

 delete from pedido_exame;
-- reinicia campo numero_pedido --> proximo 2200
 DBCC CHECKIDENT('pedido_exame', RESEED, 2199);


--Alteração de dados de tabelas -----------
select * from paciente;
update paciente set nome_paciente = 'Aguinaldo Coelho' where cpf = '456.789.012-34';
select * from paciente;

select * from medico;
update medico set especialidade = 'Ginecologia' where crm = 708090;
select * from medico;

select * from exame;
update exame set preco = 135.00 where codigo = 10110;
select * from exame;

--exclusão de registro de tabelas---------

select * from paciente;
delete from paciente where cpf = '456.789.012-34';
select * from paciente;

select * from medico;
delete from medico where crm = 708090;
select * from medico;

create trigger Atualiza_Pedido_Exame
on pedido_exame
after insert
as
begin
	SET NOCOUNT ON
	declare @num_ped as integer;
	select @num_ped = numero_pedido from inserted;
	declare @num_cons as integer;
	select @num_cons = fk_consulta_numero_consulta from inserted;
	declare @cod_ex as integer;
	select @cod_ex = fk_exame_codigo from inserted;
	declare @prc as money;

	select @prc = preco from exame where codigo = @cod_ex;
	declare @cpf_pac as varchar(20);
	select @cpf_pac = fk_paciente_cpf from consulta where numero_consulta = @num_cons;
	declare @tp_plan as varchar(20);
	select @tp_plan = tipo_plano from paciente where cpf = @cpf_pac;

	if @tp_plan = 'Especial'
	begin
	update pedido_exame set valor_pagar = @prc - @prc * 100 / 100 where
	numero_pedido = @num_ped;
	end
	if @tp_plan = 'Padrão'
	begin
	update pedido_exame set valor_pagar = @prc - @prc * 30 / 100 where
	numero_pedido = @num_ped;
	end
	if @tp_plan = 'Básico'
	begin
	update pedido_exame set valor_pagar = @prc - @prc * 10 / 100 where
	numero_pedido = @num_ped;
	end
	print 'Trigger (Atualiza Pedido de Exame) Encerrada';
end

create procedure Agenda_Medicos
as
begin
	select m.nome_medico, m.especialidade, m.crm, c.numero_consulta,
	c.data_consulta, c.horario_consulta, p.nome_paciente, p.cpf,
	p.nome_plano, p.tipo_plano from medico as m inner join consulta as c
	on m.crm = c.fk_medico_crm inner join paciente as p on
	c.fk_paciente_cpf = p.cpf
	order by m.nome_medico, c.data_consulta;
end
execute Agenda_Medicos;

create procedure Resumo_Pagamentos @nome_pac varchar(40)
as
Begin
	select pa.nome_paciente, sum(pe.valor_pagar) as total_pagar
	from paciente as pa inner join consulta as c
	on pa.cpf = c.fk_paciente_cpf inner join pedido_exame as pe
	on c.numero_consulta = pe.fk_consulta_numero_consulta
	where pa.nome_paciente = @nome_pac
	group by pa.nome_paciente;
end
execute Resumo_Pagamentos 'Maria Pereira';-- store procedure: exames solicitados em ordem de médico
create procedure Exames_Solicitados
as
begin
	select m.nome_medico, m.especialidade, m.crm, c.numero_consulta,
	p.numero_pedido, p.data_exame, e.codigo, e.especificacao
	from medico as m inner join consulta as c
	on m.crm = c.fk_medico_crm inner join pedido_exame as p
	on c.numero_consulta = p.fk_consulta_numero_consulta
	inner join exame as e on p.fk_exame_codigo = e.codigo
	order by m.nome_medico, p.data_exame;
end
execute Exames_Solicitados;
-- drop procedure Exames_Solicitados;-- store procedure: histórico pagamentos dos pacientes
create procedure Historico_Pagamentos
as
begin
	select pa.nome_paciente, pa.cpf, c.numero_consulta,
	c.data_consulta,
	pe.data_exame, pe.valor_pagar,
	e.codigo, e.especificacao from paciente as pa inner join
	consulta as c
	on pa.cpf = c.fk_paciente_cpf inner join pedido_exame as pe
	on c.numero_consulta = pe.fk_consulta_numero_consulta inner
	join exame as e
	on pe.fk_exame_codigo = e.codigo
	order by pa.nome_paciente, pe.data_exame;
end
execute Historico_Pagamentos;
-- drop procedure Historico_Pagamentos;create login aluno with password = 'Abc12345';

use clinica_medica;

create user usuario_consulta for login aluno;

 grant select to usuario_consulta;

 grant insert to usuario_consulta;

 revoke insert from usuario_consulta;

-- consultar permissões de um usuário de uma base de dados
-- utilizando a stored procedure do sistema sp_helprotect
EXEC clinica_medica.dbo.sp_helprotect @username = 'usuario_consulta';


-- Teste de login com controle de acesso - comandos DML do SQL ---------------

 use clinica_medica;

select * from paciente;

 insert into paciente values('567.890.123-45','Rogerio Ramos','(11)97890-1234',678901,'Inovamed','Básico');

 delete from paciente where cpf = '567.890.123-45';

-- insert into paciente values('789.012.345-67','Abílio Sanches','(11)99012-3456',901234,'Ultramed','Padrão');



-- Exclusão de usuário e login
-- drop user usuario_consulta;

-- drop login aluno;