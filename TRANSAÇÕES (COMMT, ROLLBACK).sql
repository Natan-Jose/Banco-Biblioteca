SHOW VARIABLES LIKE 'autocommit';
SET autocommit = 0;
SELECT @@autocommit;

INSERT INTO TbOperador(IdOperador, NoOperador)
VALUES(12, 'Chefão');

DELETE FROM TbOperador
WHERE IdOperador = 12;

DELETE FROM TbOperador
WHERE IdOperador = 800;

/*Caso não for especificado nenhum comando 
permanece temporariamente na transação,
mas as alterações não serão confirmadas nem revertidas. */
START TRANSACTION;
DELETE FROM TbOperador
WHERE IdOperador = 12;
INSERT INTO TbOperador(IdOperador, NoOperador)
VALUES(800, 'Chefão');

SELECT * FROM TbOperador;

SHOW VARIABLES LIKE 'autocommit';
SET autocommit = 0;
SELECT @@autocommit;

# Transação com rollback
START TRANSACTION;
DELETE FROM TbOperador
WHERE IdOperador = 12;
INSERT INTO TbOperador(IdOperador, NoOperador)
VALUES(800, 'Chefão');
SELECT * FROM TbOperador;
ROLLBACK;

# Transação com commit
START TRANSACTION;
DELETE FROM TbOperador
WHERE IdOperador = 12;
INSERT INTO TbOperador(IdOperador, NoOperador)
VALUES(800, 'Chefão');
SELECT * FROM TbOperador;
COMMIT;

SELECT * FROM TbOperador;

-- ----------------------------------
DELIMITER $$

CREATE PROCEDURE sp_teste() 
BEGIN
    DECLARE erro_sql TINYINT DEFAULT FALSE;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET erro_sql = TRUE;

    START TRANSACTION;
   DELETE FROM TbOperador
	WHERE IdOperador = 12;
	INSERT INTO TbOperador(IdOperador, NoOperador)
	VALUES(800, 'Chefão');
	SELECT * FROM TbOperador;

    IF erro_sql = FALSE THEN
       COMMIT;
			SELECT 'Transação bem-sucedida.' AS Resultado;
    ELSE
       ROLLBACK;
			SELECT 'Transação falhou.' AS Resultado;
    END IF;
    SET autocommit = 1;
END $$
DELIMITER ; 

CALL sp_teste();

-- ----------------------------------

# COMMIT, ROLLBACK, SAVEPOINT

CREATE TABLE CONTA(
 nro_conta INT AUTO_INCREMENT,
 nome_titular VARCHAR(30) NOT NULL,
 saldo REAL DEFAULT 0,
 PRIMARY KEY(nro_conta)
);

INSERT INTO conta( nome_titular, saldo) 
VALUES
( 'Marta', 25400.00),
( 'Lucas', 1281.34),
('Ana', 85.12),
('Fábio', 172191.23),
('Bruna', -125);


SHOW VARIABLES LIKE 'autocommit';
SET autocommit = 0;
SELECT @@autocommit;
SELECT @@global.transaction_isolation;

DELIMITER $$

CREATE PROCEDURE sp_transferencia()
BEGIN
    DECLARE erro_sql TINYINT DEFAULT FALSE;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET erro_sql = TRUE;

    START TRANSACTION;

    UPDATE conta SET saldo = saldo - 100 WHERE nro_conta = 1;
	
    SAVEPOINT debitoEmConta; 
    
    UPDATE conta SET saldo = saldo + 100 WHERE nro_conta = 4;
	
    ROLLBACK TO debitoEmConta;
   # RELEASE SAVEPOINT debitoEmConta;
    
    UPDATE conta SET saldo = saldo + 100 WHERE nro_conta = 5;
    
    IF erro_sql = FALSE THEN
       COMMIT;
        SELECT 'Transação bem-sucedida.' AS Resultado;
    ELSE
       ROLLBACK;
        SELECT 'Transação falhou.' AS Resultado;
    END IF;
     SET autocommit = 1;
END $$
DELIMITER ; 

CALL sp_transferencia();

