CREATE DATABASE UsuarioProjeto
GO
USE UsuarioProjeto

CREATE TABLE Users (
ID			INT			NOT NULL	IDENTITY(1, 1),
Nome		VARCHAR(45)	NOT NULL,
Username	VARCHAR(45)	NOT NULL	CONSTRAINT UQ_Users_Username UNIQUE,
Senha		VARCHAR(45)	NOT NULL	DEFAULT('123mudar'),
Email		VARCHAR(45)	NOT NULL

PRIMARY KEY(ID)
)

CREATE TABLE Projects (
ID					INT			NOT NULL	IDENTITY(10001, 1),
Nome				VARCHAR(45)	NOT NULL,
Descricao			VARCHAR(45)	NULL,
Data_Projeto		DATE		NOT NULL	CHECK(Data_Projeto > '20140901')

PRIMARY KEY(ID)
)
GO
CREATE TABLE Users_Has_Projects (
Users_ID		INT		NOT NULL,
Projects_ID		INT		NOT NULL

PRIMARY KEY(Users_ID, Projects_ID),
FOREIGN KEY(Users_ID) REFERENCES Users(ID),
FOREIGN KEY(Projects_ID) REFERENCES Projects(ID)
)

ALTER TABLE Users
DROP CONSTRAINT UQ_Users_Username
GO
ALTER TABLE Users
ALTER COLUMN Username VARCHAR(10) NOT NULL
GO
ALTER TABLE Users
ADD CONSTRAINT UQ_Users_Username UNIQUE (Username)

ALTER TABLE Users
ALTER COLUMN Senha VARCHAR(8) NOT NULL

INSERT INTO Users (Nome, Username, Senha, Email) VALUES
('Maria', 'Rh_maria', DEFAULT, 'maria@empresa.com'),
('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com'),
('Ana', 'Rh_ana', DEFAULT, 'ana@empresa.com'),
('Clara', 'Ti_clara', DEFAULT, 'clara@empresa.com'),
('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')

INSERT INTO Projects (Nome, Descricao, Data_Projeto) VALUES
('Re-folha', 'Refatoração das Folhas', '20140905'),
('Manutenção PCs', 'Manutenção PCs', '20140906'),
('Auditoria', NULL, '20140907')

INSERT INTO Users_Has_Projects (Users_ID, Projects_ID) VALUES
(1, 10001),
(5, 10001),
(3, 10003),
(4, 10002),
(2, 10002)

UPDATE Projects
SET Data_Projeto = '20140912'
WHERE ID = 10002

UPDATE Users
SET Username = 'Rh_cido'
WHERE Nome = 'Aparecido'

UPDATE Users
SET Senha = '888@*'
WHERE Username = 'Rh_maria'
	AND Senha = '123mudar'

DELETE Users_Has_Projects
WHERE Users_ID = 2

INSERT INTO Users (Nome, Username, Senha, Email) VALUES 
('Joao', 'Ti_joao', DEFAULT, 'joao@empresa.com')

INSERT INTO Projects (Nome, Descricao, Data_Projeto) VALUES 
('Atualização de Sistemas', 'Modificação de Sistemas Ooperacionais nos PCs', '20140912')

/*Funções de Agregação
SUM(), AVG(), COUNT(), MAX(), MIN() 

GROUP BY - Cláusula de Agregação
HAVING - Filtro para Funções de Agregação
*/

SELECT COUNT(Projects.Nome) AS qty_projects_no_users
FROM Projects LEFT OUTER JOIN Users_Has_Projects
ON Projects.ID = Users_Has_Projects.Projects_ID
WHERE Users_Has_Projects.Projects_ID IS NULL

SELECT Projects.ID, Projects.Nome, COUNT(Users_Has_Projects.Users_ID) AS Qty_Users_Project
FROM Projects LEFT JOIN Users_Has_Projects
ON Projects.ID = Users_Has_Projects.Projects_ID
GROUP BY Projects.ID, Projects.Nome
ORDER BY Projects.Nome ASC