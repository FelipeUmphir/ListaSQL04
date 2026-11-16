CREATE DATABASE Locadora
GO
USE Locadora

CREATE TABLE Estrela (
ID		INT			NOT NULL	IDENTITY(9901, 1),
Nome	VARCHAR(50)	NOT NULL

PRIMARY KEY(ID)
)

CREATE TABLE Filme (
ID		INT			NOT NULL	IDENTITY(1001, 1),
Titulo	VARCHAR(40)	NOT NULL,
Ano		INT			NULL		CHECK(Ano <= 2021)

PRIMARY KEY(ID)
)
GO
CREATE TABLE Filme_Estrela (
FilmeID		INT	NOT NULL,
EstrelaID	INT	NOT NULL

PRIMARY KEY(FilmeID, EstrelaID)
FOREIGN KEY(FilmeID) REFERENCES Filme,
FOREIGN KEY(EstrelaID) REFERENCES Estrela
)

CREATE TABLE DVD (
Num				INT		NOT NULL	IDENTITY(10001, 1),
Data_Fabricacao	DATE	NOT NULL	CHECK(Data_Fabricacao < GETDATE()),
FilmeID			INT		NOT NULL

PRIMARY KEY(Num)
FOREIGN	KEY(FilmeID) REFERENCES Filme
)

CREATE TABLE Cliente (
Num_Cadastro	INT				NOT NULL	IDENTITY(5501, 1),
Nome			VARCHAR(70)		NOT NULL,
Logradouro		VARCHAR(150)	NOT NULL,
Num				INT				NOT NULL	CHECK(Num > 0),
CEP				CHAR(8)			NULL		CHECK(LEN(CEP) = 8)

PRIMARY KEY(Num_Cadastro)
)
GO
CREATE TABLE Locacao (
DVDNum				INT				NOT NULL,
ClienteNum_Cadastro INT				NOT NULL,
Data_Locacao		DATE			NOT NULL	DEFAULT(GETDATE()),
Data_Devolucao		DATE			NOT NULL,
Valor				DECIMAL(7, 2)	NOT NULL	CHECK(Valor > 0),

CONSTRAINT chk_data CHECK(Data_Devolucao > Data_Locacao),
PRIMARY KEY(DVDNum, ClienteNum_Cadastro, Data_Locacao),
FOREIGN KEY(DVDNum) REFERENCES DVD(Num),
FOREIGN KEY(ClienteNum_Cadastro) REFERENCES Cliente(Num_Cadastro)
)

ALTER TABLE Estrela
ADD Nome_Real VARCHAR(50) NULL

ALTER TABLE Filme
ALTER COLUMN Titulo VARCHAR(80) NOT NULL

INSERT INTO Filme (Titulo, Ano) VALUES
('Whiplash', 2015),
('Birdman', 2015),
('Interestelar', 2014),
('A Culpa é das Estrelas', 2014),
('Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso', 2014),
('Sing', 2016)

INSERT INTO Estrela (Nome, Nome_Real) VALUES
('Michael Keaton', 'Michael John Douglas'),
('Emma Stone', 'Emily Jean Stone'),
('Miles Teller', NULL),
('Steve Carell', 'Steven John Carell'),
('Jennifer Garner', 'Jennifer Anne Garner')

INSERT INTO Filme_Estrela (FilmeID, EstrelaID) VALUES
(1002, 9901),
(1002, 9902),
(1001, 9903),
(1005, 9904),
(1005, 9905)

INSERT INTO DVD (Data_Fabricacao, FilmeID) VALUES
('20201202', 1001),
('20191018', 1002),
('20200403', 1003),
('20201202', 1001),
('20191018', 1004),
('20200403', 1002),
('20201202', 1005),
('20191018', 1002),
('20200403', 1003)

INSERT INTO Cliente (Nome, Logradouro, Num, CEP) VALUES
('Matilde Luz', 'Rua Síria', 150, '03086040'),
('Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110'),
('Daniel Ramalho', 'Rua Itajutiba', 169, NULL),
('Roberta Bento', 'Rua Jayme Von Rosenburg', 36, NULL),
('Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, '02917110')

INSERT INTO Locacao (DVDNum, ClienteNum_Cadastro, Data_Locacao, Data_Devolucao, Valor) VALUES
(10001, 5502, '20210218', '20210221', 3.50),
(10009, 5502, '20210218', '20210221', 3.50),
(10002, 5503, '20210218', '20210219', 3.50),
(10002, 5505, '20210220', '20210223', 3.00),
(10004, 5505, '20210220', '20210223', 3.00),
(10005, 5505, '20210220', '20210223', 3.00),
(10001, 5501, '20210224', '20210226', 3.50),
(10008, 5501, '20210224', '20210226', 3.50)

UPDATE Cliente
SET CEP = '08411150'
WHERE Num_Cadastro = 5503

UPDATE Cliente
SET CEP = '02918190'
WHERE Num_Cadastro = 5504

UPDATE Locacao
SET Valor = 3.25
WHERE ClienteNum_Cadastro = 5502
	AND Data_Locacao = '20210218'

UPDATE Locacao
SET Valor = 3.10
WHERE ClienteNum_Cadastro = 5501
	AND Data_Locacao = '20210224'

UPDATE DVD
SET Data_Fabricacao = '20190714'
WHERE Num = 10005

UPDATE Estrela
SET Nome_Real = 'Miles Alexander Teller'
WHERE Nome = 'Miles Teller'

DELETE Filme
WHERE Titulo = 'Sing'

/*Funções de Agregação
SUM(), AVG(), COUNT(), MAX(), MIN() 

GROUP BY - Cláusula de Agregação
HAVING - Filtro para Funções de Agregação
*/

SELECT Cliente.Num_Cadastro, Cliente.Nome,
	   Filme.Titulo, DVD.Data_Fabricacao, 
	   Locacao.Valor
FROM Cliente, Filme, DVD, Locacao
WHERE Filme.ID = DVD.FilmeID
	AND DVD.Num = Locacao.DVDNum
	AND Cliente.Num_Cadastro = Locacao.ClienteNum_Cadastro
	AND DVD.Data_Fabricacao = (SELECT MAX(Data_Fabricacao) FROM DVD)

SELECT Cliente.Num_Cadastro, Cliente.Nome, 
	   CONVERT(VARCHAR(10), Locacao.Data_Locacao, 103) AS Data_Locacao,
	   COUNT(Locacao.DVDNum) AS Qnt
FROM Cliente, Locacao, DVD
WHERE Cliente.Num_Cadastro = Locacao.ClienteNum_Cadastro
	AND DVD.Num = Locacao.DVDNum
GROUP BY Cliente.Num_Cadastro, Locacao.Data_Locacao, Cliente.Nome, Locacao.Data_Locacao

SELECT Cliente.Num_Cadastro, Cliente.Nome, 
	   CONVERT(VARCHAR(10), Locacao.Data_Locacao, 103) AS Data_Locacao,
	   SUM(Locacao.Valor) AS Valor_Total
FROM Cliente, Locacao
WHERE Cliente.Num_Cadastro = Locacao.ClienteNum_Cadastro
GROUP BY Locacao.Data_Locacao, Cliente.Num_Cadastro, Cliente.Nome

SELECT Cliente.Num_Cadastro,
       Cliente.Nome,
       Cliente.Logradouro + ', ' + CAST(Cliente.Num_Cadastro AS VARCHAR(10)) AS Endereco,
       CONVERT(VARCHAR(10), Locacao.Data_Locacao, 103) AS Data_Locacao
FROM Cliente, Locacao
WHERE Cliente.Num_Cadastro = Locacao.ClienteNum_Cadastro
GROUP BY Cliente.Num_Cadastro, Cliente.Nome,
         Cliente.Logradouro, Cliente.Num_Cadastro,
         Locacao.Data_Locacao
HAVING COUNT(Locacao.DVDNum) > 2