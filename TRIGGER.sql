CREATE DATABASE dbVendas;

USE dbVendas; 

CREATE TABLE TbProduto(
	CoProduto SMALLINT NOT NULL PRIMARY KEY,
	NoProduto VARCHAR(50) NOT NULL,
	VaProduto DECIMAL(7, 2) NOT NULL,
	DescontoProduto DECIMAL(7, 2) NULL,
    QtEstoque SMALLINT DEFAULT 0
    );

CREATE TABLE TbPedido(
	CoPedido INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	DaAbertura DATETIME NOT NULL,
	DaEncerramento DATETIME,
	VaPedido DECIMAL(8, 2) NOT NULL);

CREATE TABLE TbPedidoItem(
    IdPedidoItem INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	VaItem DECIMAL(7, 2) NOT NULL,
	QtItem SMALLINT NOT NULL,
	VaTotalItem DECIMAL(8, 2) DEFAULT 0,
	CoPedido INT NOT NULL,
	CoProduto SMALLINT NOT NULL);
	
INSERT INTO TbProduto (CoProduto, NoProduto, VaProduto, QtEstoque)
VALUES (1, 'Mouse wireless', 25, 100),
       (2, 'Teclado wireless', 150, 50),
	   (3, 'Resma de papel A4', 500, 20),
	   (4, 'Monitor portátil', 2500, 10),
	   (5, 'Impressora wireless', 350, 30);
	   
ALTER TABLE tbpedidoitem ADD CONSTRAINT FK_produto 
FOREIGN KEY (CoProduto) REFERENCES tbproduto(CoProduto);

ALTER TABLE tbpedidoitem ADD CONSTRAINT FK_pedido 
FOREIGN KEY (CoPedido) REFERENCES tbpedido(CoPedido);

# TRIGGER UPDATE
DELIMITER $$
CREATE TRIGGER tg_ControlaEstoqueAlteracao
BEFORE UPDATE
ON TbProduto FOR EACH ROW
BEGIN
	DECLARE msg_erro VARCHAR(150);
    
    IF NEW.QtEstoque < 0 THEN
    SET msg_erro = 'ERRO: Não é permitido estoque negativo.';
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg_erro;
END IF;
END $$
DELIMITER ;

UPDATE TbProduto
SET QtEstoque = -1
WHERE CoProduto = 1;

# TRIGGER INSERT 
DELIMITER $$
CREATE TRIGGER tg_ControlaEstoqueInclusao
BEFORE INSERT
ON TbProduto FOR EACH ROW
BEGIN
	DECLARE msg_erro VARCHAR(150);
    
    IF NEW.QtEstoque < 0 THEN
    SET msg_erro = 'ERRO: Não é permitido estoque negativo.';
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg_erro;
END IF;
END $$
DELIMITER ;

INSERT INTO TbProduto(CoProduto, NoProduto, QtEstoque, VaProduto)
VALUES
(100, 'Teste', -1, 10);

# TRIGGER DELETE
DELIMITER $$

CREATE TRIGGER tg_ExclusaoProduto
BEFORE DELETE
ON tbproduto FOR EACH ROW

BEGIN
DECLARE msg_erro VARCHAR(100);
SET msg_erro = 'ERRO: Não é permitido a exclusão de produtos';
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = msg_erro;
END; $$
 
DELIMITER ;

DROP TRIGGER tg_ExclusaoProduto;

DELETE FROM TbProduto 
WHERE CoProduto >= 100;

SELECT * FROM TbProduto;

# DESCONTO EM PRODUTO
DELIMITER $$
CREATE TRIGGER tg_DescontoProduto
BEFORE INSERT 
ON Tbproduto FOR EACH ROW 
BEGIN
SET NEW.DescontoProduto = (NEW.VaProduto * 0.90);
END $$
DELIMITER ;

INSERT INTO TbProduto(CoProduto, NoProduto, VaProduto)
VALUES
(6, 'Monitor', 350.00),
(7, 'DVD', 1.00),
(8, 'Pendrive', 18.00);

DELIMITER $$

CREATE TRIGGER tg_IncluiItem
BEFORE INSERT
ON TbPedidoItem FOR EACH ROW
BEGIN
  DECLARE preco DECIMAL(7, 2);
 
  SELECT VaProduto INTO preco
    FROM TbProduto
   WHERE CoProduto = NEW.CoProduto;
   
  SET NEW.VaItem = preco;
  SET NEW.VaTotalItem = NEW.QtItem * preco;
  
  UPDATE TbPedido /*Cálculo do valor do pedido*/
     SET VaPedido = VaPedido + NEW.VaTotalItem
   WHERE CoPedido = NEW.CoPedido;
   
  UPDATE TbProduto /*Baixa no estoque*/
     SET QtEstoque = QtEstoque - NEW.QtItem
   WHERE CoProduto = NEW.CoProduto;  
END $$

DELIMITER ;

INSERT INTO TbPedido(CoPedido, DaAbertura, VaPedido)
VALUES (1, NOW(), 2);


INSERT INTO TbPedidoItem(IdPedidoItem, CoProduto, QtItem)
VALUES
(3, 4, 11);

INSERT INTO TbPedidoItem(IdPedidoItem, CoPedido, CoProduto, QtItem)
VALUES
(3, 11);

SELECT * FROM tbproduto;
SELECT * FROM tbpedido;
SELECT * FROM tbpedidoitem;

SHOW TABLE STATUS;
SELECT DATABASE();
SHOW PROCEDURE STATUS;
SHOW FUNCTION STATUS;
SHOW TRIGGERS;