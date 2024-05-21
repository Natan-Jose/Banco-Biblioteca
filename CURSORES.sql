SELECT * FROM vw_listagemaluno;

SHOW VARIABLES LIKE "secure_file_priv";

DELIMITER $$

CREATE PROCEDURE sp_GeraEmail()
BEGIN  
  DECLARE lista VARCHAR(2000) DEFAULT '';
  DECLARE email VARCHAR(150);
  DECLARE fim BOOLEAN DEFAULT FALSE;

  DECLARE crEmails CURSOR
  FOR SELECT TxEmail FROM TbEmail;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim = TRUE;
  OPEN crEmails;
  WHILE fim = FALSE DO
    FETCH crEmails INTO email;
           
    SET lista = CONCAT(lista, email);
    SET lista = CONCAT(lista, ";");
  END WHILE;
  CLOSE crEmails;
  
  SELECT lista INTO OUTFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\emails.csv';

END $$

DELIMITER ;

CALL sp_GeraEmail();


# Visualizar no MYSQL
SELECT CONVERT(LOAD_FILE('C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\emails.csv') USING utf8) AS csv_content;

DELIMITER $$
CREATE PROCEDURE sp_ExecCursor()
BEGIN
SET @csv_content := CONVERT(LOAD_FILE('C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\emails.csv') USING utf8);

IF @csv_content IS NULL THEN
    SELECT 'Erro: Falha ao carregar o arquivo ou arquivo não encontrado.' AS Erro;
ELSE
    SELECT @csv_content AS csv_content;
END IF;
END $$
DELIMITER ;

CALL sp_ExecCursor;

# EXERÇICIO
DELIMITER $$

CREATE PROCEDURE sp_ExportaDadosAutor()
BEGIN  
  DECLARE lista VARCHAR(2000) DEFAULT '';
  DECLARE autor VARCHAR(150);
  DECLARE fim BOOLEAN DEFAULT FALSE;

  DECLARE cr_autores CURSOR
  FOR SELECT NoAutor FROM TbAutor;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim = TRUE;
  OPEN cr_autores;
  WHILE fim = FALSE DO
    FETCH cr_autores INTO autor;
           
    SET lista = CONCAT(lista, autor);
    SET lista = CONCAT(lista, ";");
  END WHILE;
  CLOSE cr_autores;
  
  SELECT lista INTO OUTFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\autores.csv';

END $$

DELIMITER ;

CALL sp_ExportaDadosAutor();

# IMPORTAR E EXPORTAR ARQUIVOS .CSV

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/autores.csv'
INTO TABLE tbautor
FIELDS TERMINATED BY ',' -- DELIMITADOR
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(NoAutor);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/autores.csv'
INTO TABLE tbautor
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(NoAutor);
 
 