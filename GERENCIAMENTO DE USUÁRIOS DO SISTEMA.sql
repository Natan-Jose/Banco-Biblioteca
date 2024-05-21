SELECT user, host FROM mysql.user;

CREATE USER natan@localhost IDENTIFIED BY '1234';

CREATE USER ana IDENTIFIED BY ''; -- Acessar de qualquer lugar

CREATE USER marcos@localhost;

ALTER USER 'marcos'@'localhost' IDENTIFIED BY '1111';

RENAME USER ana TO monica;

DROP USER natan@localhost;

