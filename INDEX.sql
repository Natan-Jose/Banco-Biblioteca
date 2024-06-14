-- INDEX 

SHOW INDEX FROM TbObra;

# EXPLAIN - Otimização de performance no banco

/* Custo da Transação - Refere-se às linhas que são lidas para se 
alcançar o resultado, abrangendo processamento, memória e tempo.*/

# CERTA
EXPLAIN SELECT IdObra, NoObra FROM TbObra
WHERE NoObra LIKE 'La Fortaleza Digital';

CREATE INDEX idx_editora ON TbObra(NoObra); 

DROP INDEX idx_editora ON TbObra;

# ERRADO
EXPLAIN SELECT IdObra, NoObra FROM TbObra
WHERE NoObra = 'La Fortaleza Digital';