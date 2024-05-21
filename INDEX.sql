CREATE DATABASE Teste;

USE Teste;
SHOW DATABASES;
CREATE TABLE Pessoas (
    ID INT PRIMARY KEY,
    Nome VARCHAR(255),
    Idade INT,
    Genero VARCHAR(20)
);

EXPLAIN SELECT * FROM Pessoas; 

CREATE TEMPORARY TABLE teste(
id INT 
);


SELECT NomeLivro,ISBN13, PrecoLivro
FROM tbl_livros;

-- INDEX 

SHOW INDEX FROM TbCurso;

DROP INDEX idx_Curso ON TbCurso;

EXPLAIN SELECT IdCurso, NoCurso FROM TbCurso
WHERE NoCurso LIKE '%Redes de Computadores';

CREATE INDEX idx_Curso ON TbCurso(NoCurso); 
