create table Pessoa
(
	cpf VARCHAR(100) primary key,
	nome VARCHAR(100),
	telefone VARCHAR(100),
	endereco VARCHAR(100),
	email VARCHAR(100)
);

create table Veiculo
(
	placa VARCHAR(100) primary key,
	marca VARCHAR(100),
	modelo VARCHAR(100),
	ano date,
	consumo_medio int
);

create table Motorista
(
	cat_cnh VARCHAR(100),
	tempo_experiencia VARCHAR(100),
	disponibilidade VARCHAR(100),
	cpf VARCHAR(100) primary key references Pessoa (cpf)
);

create table Tipo_manutencao
(
	preventiva VARCHAR (100),
	corretiva VARCHAR(100),
	id_tipo_manut VARCHAR(100) primary key
);

create table Manutencao
(
	descricao VARCHAR(100),
	data_entr date,
	data_saida VARCHAR(100),
	custo FLOAT,
	placa VARCHAR(100) references Veiculo (placa),
	cod_manut VARCHAR(100) primary key,
	tipo_manut VARCHAR(100) references Tipo_manutencao (id_tipo_manut)
);

create table Abastecimento
(
	data DATE,
	litros float,
	valor_pago float,
	tipo_combustivel VARCHAR(100),
	placa VARCHAR(100) references Veiculo (placa),
	cod_abastecimento INT primary key 
);

create table Viagem
(
	cod_viagem INT primary key,
	data date,
	origem VARCHAR(100),
	destino VARCHAR(100),
	distancia_pecorrida INT,
	veiculo VARCHAR(100) references Veiculo (placa),
	motorista VARCHAR(100) references Motorista (cpf)
);

create table Tipo_veiculo
(
	carro VARCHAR(100),
	moto VARCHAR(100),
	caminhonete VARCHAR(100),
	placa VARCHAR(100) references Veiculo (placa),
	cod_tipo_veiculo VARCHAR(100) primary key 
);

create table Status_veiculo
(
	ativo VARCHAR(100),
	inativo VARCHAR(100),
	manutencao VARCHAR(100),
	placa VARCHAR(100) references Veiculo (placa),
	cod_status VARCHAR(100) primary KEY
);

-- Etapa 3 - Projeto Final
-- Carga de dados (INSERTS)

INSERT into Pessoa (cpf, nome, telefone, endereco, email)
	values 
	('11122233325', 'Junior mota', '97894512', 'rua opala numero 111', 'marpaul@dmail.com'),
    ('22233344454', 'João Paulo Souza', '98745784', 'rua neon numero 150', 'jopaul@dmail.com'),
    ('33344455569', 'Isadora Santos', '99402512', 'rua capixaba numero 90', 'isasantos@dmail.com');

INSERT into veiculo (placa, marca, modelo, ano, consumo_medio)
	values 
	('HGF4174', 'chevrolet', 's10', '2010-02-01', 10),
    ('GIU8536', 'wolkswagen', 'fusca', '1984-03-02', 15),
    ('AOS8521', 'honda', 'civic', '2020-02-02', 8);

INSERT into motorista (cat_cnh, tempo_experiencia, disponibilidade, cpf)
	values 
	('b', '2 anos', 'sim', '11122233325'),
	('a', '1 ano', 'sim', '22233344454'),
	('c', '10 anos', 'sim', '33344455569');

INSERT into tipo_manutencao  (preventiva, corretiva, id_tipo_manut)
	values 
	('preventiva', 'xxxx', '1'),
	('xxxx', 'corretiva', '2');

INSERT into manutencao  (descricao, data_entr, data_saida , custo, placa, cod_manut, tipo_manut)
	values 
	('troca de biela', '2022-02-01', '2022-02-03', 125.00, 'HGF4174', '5248', '1'),
	('retifica de motor', '2022-03-02', '2022-03-04', 1000.00, 'GIU8536', '5249', '2'),
	('troca de oleo',  '2022-04-10', '2022-04-15', 1000.00, 'AOS8521', '5250', '1');
	
INSERT into abastecimento   (data, litros, valor_pago , tipo_combustivel, placa, cod_abastecimento)
	values 
	( '2022-02-01', 50.05, 725.00, 'alcool','HGF4174', '744'),
	( '2022-03-02', 80.80, 1000.00, 'gasolina', 'GIU8536', '745'),
	( '2022-04-10', 100, 1000.00, 'diesel', 'AOS8521',  '746');

INSERT into viagem (cod_viagem, data, origem, destino, distancia_pecorrida, veiculo, motorista)
	values 
	( 432, '2022-02-01', 'fortaleza', 'sobral', 400, 'HGF4174', '11122233325'),
	( 433, '2022-03-02', 'crato', 'fortaleza', 800, 'GIU8536', '22233344454'),
	( 434, '2022-04-10', 'paraipaba', 'russas', 300, 'AOS8521',  '33344455569');

INSERT into tipo_veiculo (carro, moto, caminhonete, placa, cod_tipo_veiculo)
	values 
	( 'xxxx', 'xxxx', 'caminhonete','HGF4174', '10'),
	( 'carro', 'xxxx', 'xxxx', 'GIU8536', '11'),
	( 'carro', 'xxxx', 'xxxx', 'AOS8521', '12');

INSERT into status_veiculo (ativo, inativo, manutencao, placa, cod_status)
	values 
	( 'ativo', 'xxxx', 'xxxx','HGF4174', '30'),
	( 'xxxx', 'inativo', 'xxxx', 'GIU8536', '31'),
	( 'xxxx', 'xxxx', 'manutencao', 'AOS8521', '32');

-- Consultas (SELECT)

-- Consulta 1: Consulta de pessoas que também são motoristas

SELECT 
    Pessoa.nome, 
    Motorista.cat_cnh
FROM Pessoa
INNER JOIN Motorista ON Pessoa.cpf = Motorista.cpf;

-- Consulta todos os modelos de carro e mmostrao valor gasto no abastecimento

SELECT 
    v.modelo AS "veiculo", 
    a.valor_pago AS "Valor Gasto"
FROM Veiculo AS v
LEFT JOIN Abastecimento AS a ON v.placa = a.placa

-- Consulta com where: diz quais são os carros da marca honda

SELECT 
    v.placa AS "Placa", 
    v.modelo AS "Modelo", 
    v.marca AS "Fabricante"
FROM Veiculo AS v
WHERE v.marca = 'honda';

-- Consulta Histórico de Manutenções Caras (INNER JOIN)
-- Cruza a manutenção com o tipo e o veículo.
-- Usa WHERE para filtrar gastos acima de 500 reais.

SELECT 
    m.cod_manut AS "Cód. Manutenção",
    v.modelo AS "Veículo",
    m.descricao AS "Serviço",
    m.custo AS "Valor"
FROM Manutencao AS m
INNER JOIN Veiculo AS v ON m.placa = v.placa
INNER JOIN Tipo_manutencao AS tm ON m.tipo_manut = tm.id_tipo_manut
WHERE m.custo > 500;

-- Inserindo contraint UNIQUE no campo cpf e email da tabela Pessoa

alter table pessoa 
ADD constraint unq_cpf UNIQUE (cpf);

alter table pessoa 
ADD constraint unq_email UNIQUE (email);
	
-- Inserindo contraint CHECK no campo ano da tabela veiculo e no campo litros da tabela abastecimento	

alter table veiculo  
ADD constraint chk_email check  (ano >= '1984-03-02');

-- correção do nome da constraint anterior

ALTER TABLE veiculo  DROP CONSTRAINT chk_email;

--inclusão da constraint com o nome correto

alter table veiculo  
ADD constraint chk_ano check  (ano >= '1984-03-02');
	
--Inserindo contraint CHECK no campo litros da tabela abastecimento

alter table abastecimento  
ADD constraint chk_litros check  (litros >= 0.00);

--DEFININO VALOR 0 COMO DEFAULT PARA A COLUNA DISTANCIA DA TABELA VIAGEM

ALTER TABLE viagem 
ALTER COLUMN distancia_pecorrida SET DEFAULT 0;

--  Remove a chave estrangeira antiga pois não achei meios para somente incluir o cascade

ALTER TABLE Motorista 
    DROP CONSTRAINT motorista_cpf_fkey,
    
    -- incluindo a nova chave já com o cascade
	
ALTER TABLE Motorista 
	ADD CONSTRAINT fk_motorista_pessoa
        FOREIGN KEY (cpf) 
        REFERENCES Pessoa (cpf) 
        ON DELETE CASCADE;

-- cria view que consulta os veículos com status ativo

CREATE VIEW vw_veiculos_ativos AS
SELECT 
    v.placa,
    v.marca,
    v.modelo,
    s.ativo AS status
FROM Veiculo v
INNER JOIN Status_veiculo s ON v.placa = s.placa
WHERE s.ativo = 'ativo';

-- cria view materializada onde será consulatado as despesas com abasteciemnto e manutenção dos veículos

create materialized view mv_despesas_manutencao_abastecimento as
select 
	v.placa,
	v.marca,
	v.modelo,
	m.custo as valor_manutencao,
	a.valor_pago as valor_abastecimento
from Veiculo v  
left join Manutencao m on v.placa = m.placa
left join Abastecimento a on v.placa = a.placa;
GROUP BY v.placa, v.marca, v.modelo;

--  Cria função para triger before que muda para caixa alta, antes da inserção, o nome das pessoas 

create function fn_nome_maiusculo()
returns trigger 
language plpgsql 
as $$ 
begin
	new.nome := UPPER(new.nome);
	return new;
end;
$$;
end

-- criando o trigger before

create trigger trg_nome_maiusculo 
before insert on Pessoa 
for each row 
execute function fn_nome_maiusculo();

--  Cria função para triger after que informa a mensagem de veiculo cadastrado
 
create function  fn_aviso_apos_insercao()
returns trigger 
language plpgsql 
as $$ 
begin
	raise notice ' Veículo de placa % foi inserido no banco de dados.', NEW.placa;
	return new;
end;
$$;



--criando o trigger after

 create trigger trg_aviso_cadastro_veiculo
 after insert on Veiculo 
 for each row 
 execute function fn_aviso_apos_insercao();

 --CRIAÇÃO DE PROCEDURE QUE ALTERA O STATUS DO VEÍCULO PARA INATIVO
 
CREATE PROCEDURE pr_desativar_veiculo(p_placa VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Atualiza o status na tabela Veiculo
    UPDATE Veiculo SET status = 'Inativo' WHERE placa = p_placa;
END;
$$;
