CREATE DATABASE exer_ddl_dml02
GO
USE exer_ddl_dml02
GO
CREATE TABLE projetos (
id				INT			 NOT NULL	  IDENTITY(10001,1),
nome			VARCHAR(45)  NOT NULL,
descricao		VARCHAR(45)  NULL,
data_proj       DATE         NOT NULL     CHECK(data_proj > '2014-09-01')
PRIMARY KEY(id)
)
GO
CREATE TABLE usuario (
id				INT		     NOT NULL     IDENTITY,
nome			VARCHAR(45)  NOT NULL,
username        VARCHAR(45)  NOT NULL,
password        VARCHAR(45)  NOT NULL     DEFAULT('123mudar'),
email			VARCHAR(45)  NOT NULL
PRIMARY KEY(id) 
)
GO 
CREATE TABLE usuario_projetos (
usuario_id		INT        NOT NULL,
projetos_id      INT        NOT NULL
PRIMARY KEY(usuario_id, projetos_id)
FOREIGN KEY(usuario_id) REFERENCES usuario(id),
FOREIGN KEY(projetos_id) REFERENCES projetos(id)
)

ALTER TABLE usuario
ALTER COLUMN username   VARCHAR(10)  NOT NULL -- Erro Constraint
GO
EXEC sp_help usuario 

DROP TABLE usuario
DROP TABLE projetos
DROP TABLE usuario_projetos

ALTER TABLE usuario
ALTER COLUMN username   VARCHAR(10)  NOT NULL
GO
ALTER TABLE usuario
ADD UNIQUE(username)

ALTER TABLE usuario
ALTER COLUMN password   VARCHAR(8)   NOT NULL
GO
INSERT INTO usuario (nome, username, email) VALUES ('Maria', 'Rh_maria', 'maria@empresa.com')
INSERT INTO usuario (nome, username, password, email) VALUES 
                    ('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com')
INSERT INTO usuario (nome, username, email) VALUES ('Ana', 'Rh_ana', 'ana@empresa.com')
INSERT INTO usuario (nome, username, email) VALUES ('Clara', 'Ti_clara', 'clara@empresa.com')
INSERT INTO usuario (nome, username, password, email) VALUES
                    ('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')
INSERT INTO projetos (nome, descricao, data_proj) VALUES
('Re-folha','Refatoração das Folhas','2014-09-05'),
('Manutenção PC´s','Manutenção PC´s','2014-09-06'),
('Auditoria',NULL,'2014-09-07')
GO
INSERT INTO usuario_projetos VALUES
(1,10001),
(5,10001),
(3,10003),
(4,10002),
(2,10002)
GO
UPDATE projetos
SET data_proj = '2014-09-12'
WHERE nome = 'Manutenção PC´s'
GO
UPDATE usuario
SET username = 'Rh_cido'
WHERE nome = 'Aparecido'
GO
UPDATE usuario
SET password = '888@*'
WHERE username = 'Rh_maria' AND password = '123mudar'
GO
DELETE usuario_projetos
WHERE usuario_id = 2 AND projetos_id = 10002

SELECT * FROM usuario
SELECT * FROM projetos
SELECT * FROM usuario_projetos

SELECT id, nome, email, username,
    CASE WHEN (password != '123mudar')
	   THEN
	          '********'
		ELSE
		      password
		END AS password_usuario
FROM usuario

SELECT nome, descricao, CONVERT(CHAR(10), data_proj, 103) AS data_inicio,
      CONVERT(CHAR(10), DATEADD(DAY, 15, data_proj), 103) AS data_final
FROM projetos
WHERE id IN
(
     SELECT projetos_id
	 FROM usuario_projetos
	 WHERE usuario_id IN
	 (
	     SELECT id
		 FROM usuario
		 WHERE email = 'aparecido@empresa.com'
	  )
)

SELECT nome, email
FROM usuario
WHERE id IN
(
    SELECT usuario_id
	FROM usuario_projetos
	WHERE projetos_id IN
	  (
	     SELECT id
		 FROM projetos
		 WHERE nome = 'Auditoria'
	   )
)

SELECT nome, descricao, CONVERT(CHAR(10), data_proj, 103) AS data_inicio,
      CONVERT(CHAR(10), DATEADD(DAY, 4, data_proj), 103) AS data_final,
	  CAST(DATEDIFF(DAY, data_proj, '2014-09-16') * 79.85 AS DECIMAL(7,2)) AS custo_total
FROM projetos
WHERE nome LIKE '%Manute%'