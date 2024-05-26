-- INDEX 
CREATE INDEX idx_editora ON TbObra(NoObra); 

SHOW INDEX FROM TbObra;

SELECT * FROM TbObra;

-- EXPLAIN - Otimização de performance no banco

/* Custo da Transação - São as linhas que são lidas para se chegar ao resultado 
(processamento, mémoria e tempo) */

EXPLAIN SELECT IdObra, NoObra FROM TbObra
WHERE NoObra LIKE 'La Fortaleza Digital';

DROP INDEX idx_editora ON TbObra;

# NÃO INDICADO
EXPLAIN SELECT IdObra, NoObra
FROM TbObra USE INDEX (idx_editora)
WHERE NoObra LIKE '%Fortaleza Digital';