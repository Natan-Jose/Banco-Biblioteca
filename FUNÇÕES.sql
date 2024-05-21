-- Retorna o gênero com base em um valor numérico.
DELIMITER $$
CREATE FUNCTION fn_GetGenero(genero TINYINT)
RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
IF genero = 1 THEN
RETURN 'Masculino';
ELSEIF genero = 2 THEN
RETURN 'Feminino';
END IF;
RETURN '(Não Informado)';
END $$
DELIMITER ;

SELECT NuCPF, NuMatricula, NoAluno, fn_GetGenero(InGenero) AS Genero FROM TbAluno;

-- Formatação CPF
DELIMITER $$
CREATE FUNCTION fn_FormataCPF(cpf VARCHAR(11))
RETURNS VARCHAR (14) DETERMINISTIC
BEGIN
   DECLARE formatado VARCHAR(14);
 
   SET formatado = SUBSTRING(cpf, 1, 3); 
   SET formatado = CONCAT(formatado, '.', SUBSTRING(cpf, 4, 3));
   SET formatado = CONCAT(formatado, '.', SUBSTRING(cpf, 7, 3));
   SET formatado = CONCAT(formatado, '-', SUBSTRING(cpf, 10, 2));

   RETURN formatado;
END $$
DELIMITER ;

SELECT fn_FormatarCPF(NuCPF) AS CPF FROM TbAluno;

-- EXERCÍCIOS FUNÇÕES

DELIMITER $$
CREATE FUNCTION fn_CalcularIdade(data_nascimento DATE)
RETURNS TINYINT DETERMINISTIC
BEGIN 
DECLARE Idade TINYINT;

SELECT TRUNCATE(DATEDIFF(NOW(), data_nascimento) / 365, 0)
INTO idade;
RETURN Idade;
END $$
DELIMITER ;

SELECT NoAluno, fn_CalcularIdade(DaNascimento) AS Idade FROM TbAluno;

DELIMITER $$
CREATE FUNCTION fn_CalculaTempoPublicao(id INT)
RETURNS TINYINT DETERMINISTIC
   BEGIN
     DECLARE anos TINYINT;

     SELECT YEAR(NOW()) - NuAno INTO anos
	   FROM TbObra
	  WHERE IdObra = id;
	  
     RETURN anos;
   END $$
DELIMITER ;
