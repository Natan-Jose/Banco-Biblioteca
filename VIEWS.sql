CREATE OR REPLACE VIEW vw_Curso
AS 
SELECT * FROM TbCurso;

CREATE OR REPLACE VIEW vw_ListagemAluno
AS 
SELECT TbAluno.NuMatricula, TbAluno.NoAluno, vw_Curso.NoCurso, TbAluno.TxIngresso, TbEmail.TxEmail
FROM TbAluno
INNER JOIN vw_Curso
ON TbAluno.IdCurso = vw_Curso.IdCurso
INNER JOIN TbEmail
ON TbAluno.NuMatricula = TbEmail.NuMatricula;

SELECT * FROM vw_ListagemAluno
ORDER BY vw_ListagemAluno.NoCurso, TbAluno.NoAluno ASC;

-- EXERCÍCIOS VIEWS

CREATE OR REPLACE VIEW vw_Editora
AS 
SELECT * FROM TbEditora;

CREATE OR REPLACE VIEW vw_Idioma
AS
SELECT * FROM TbIdioma;    

CREATE OR REPLACE VIEW vw_Obra
AS 
SELECT TbObra.NoObra AS 'Título', TbObra.NuAno AS 'Publicação',
 TbObra.VaPreco AS 'R$', vw_Idioma.NoIdioma AS 'Idioma', vw_Editora.NoEditora AS 'Editora'
FROM TbObra
INNER JOIN vw_Idioma
ON TbObra.IdIdioma = vw_Idioma.IdIdioma 
INNER JOIN vw_Editora
ON TbObra.IdEditora = vw_Editora.IdEditora;

SELECT * FROM vw_Obra;

