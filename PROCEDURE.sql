DELIMITER $$
CREATE PROCEDURE sp_ListagemAluno(IN Curso VARCHAR(50))
BEGIN 
SELECT * FROM vw_ListagemAluno
WHERE NoCurso = Curso;
END $$
DELIMITER ;

CALL sp_ListagemAluno('Sistemas Para Internet');

DESCRIBE vw_ListagemAluno

/*IMPLEMENTANDO CRUDs*/
DELIMITER $$
CREATE PROCEDURE sp_CursoLista()
BEGIN 
SELECT * FROM TbCurso;
END $$
DELIMITER ; 

CALL sp_CursoLista();

DELIMITER $$
CREATE PROCEDURE sp_CursoExclui(IN id TINYINT)
BEGIN 
DELETE FROM TbCurso
WHERE IdCurso = Id;
END $$
DELIMITER ; 
 
CALL sp_CursoExclui(5);

DELIMITER $$
CREATE PROCEDURE sp_CursoIncluiAltera(IN id TINYINT, IN nome VARCHAR(50)) 
BEGIN
	DECLARE proximo TINYINT;
	IF id = 0 THEN
		SELECT MAX(IdCurso) INTO proximo FROM TbCurso;

	   INSERT INTO tbcurso(Idcurso, NoCurso)
	   VALUES (proximo + 1, nome);
	ELSE
	   UPDATE vw_curso
	   SET NoCurso = nome 
	   WHERE IdCurso = id;
	END IF;
  END $$
DELIMITER ;

CALL sp_CursoIncluiAltera(0, 'Eng. de Telecomunicações');
CALL sp_CursoIncluiAltera(5, 'Publicidade');


-- EXERCÍCIOS PROCEDURE

DELIMITER $$
CREATE PROCEDURE sp_EditoraExclui(IN id TINYINT)
BEGIN 
DELETE FROM TbEditora
WHERE IdEditora = Id;
END $$
DELIMITER ; 

CALL sp_EditoraExclui(5);

DELIMITER $$
CREATE PROCEDURE sp_EditoraIncluiAltera(IN id TINYINT, IN nome VARCHAR(50)) 
BEGIN
	DECLARE proximo TINYINT;
	IF id = 0 THEN
		SELECT MAX(IdEditora) INTO proximo FROM TbEditora;

	   INSERT INTO tbEditora(IdEditora, NoEditora)
	   VALUES (proximo + 1, nome);
	ELSE
	   UPDATE TbEditora
	   SET NoEditora = nome 
	   WHERE IdEditora = id;
	END IF;
  END $$
DELIMITER ;

CALL sp_EditoraIncluiAltera(0, 'Rede'); -- 0 ADICIONAR REGISTRO
CALL sp_EditoraIncluiAltera(5, 'Engenharia'); -- MAIOR QUE 0 ATUALIZAR REGISTRO

DELIMITER $$
CREATE PROCEDURE sp_EditoraLista()
BEGIN
SELECT * FROM TbEditora
ORDER BY IdEditora, NoEditora;
END $$
DELIMITER ;

CALL sp_EditoraLista();

DELIMITER $$
CREATE PROCEDURE sp_ListagemObra()
BEGIN 
SELECT TbObra.IdObra AS Id, TbObra.NoObra 'Nome Obra', TbObra.NuAno AS 'Publicação', TbObra.NuEdicao AS 'Edição', 
TbObra.VaPreco AS R$, TbEditora.NoEditora AS Editora, TbIdioma.NoIdioma AS Idioma
FROM TbObra
INNER JOIN TbEditora
ON TbObra.IdObra = TbEditora.IdEditora
INNER JOIN TbIdioma
ON TbObra.IdObra = TbIdioma.IdIdioma;  
END $$
DELIMITER ;

CALL sp_ListagemObra();