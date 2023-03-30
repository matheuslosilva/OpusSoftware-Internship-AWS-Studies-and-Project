CREATE DATABASE mySQLDB;
USE mySQLDB;

CREATE TABLE registros
(
    id integer PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    descricao VARCHAR(255) NOT NULL
);

INSERT INTO registros (nome, descricao)
values
("Teste 1", "Deu tudo certo!!"),
("Teste 2", "Será que deu certo?"),
("Teste 3", "Felicidade e alegria, deu certo!");

/* rodando servidor node MYSQL_HOST="rdsmysql.cotblzgylx7o.us-west-2.rds.amazonaws.com" MYSQL_USER="admin" MYSQL_PASSWORD="admin123" MYSQL_DATABASE="mySQLDB" node index