CREATE DATABASE crane;
CREATE TABLE User (
    username VARCHAR(20) NOT NULL,
    email VARCHAR(60) NOT NULL UNIQUE,
    password VARCHAR(150) NOT NULL,
    PRIMARY KEY (username)
);

CREATE USER 'deleteRole'@'ip-máquina' IDENTIFIED BY 'pwd';
GRANT SELECT, DELETE ON crane.user TO 'deleteRole'@'ip-máquina';

CREATE USER 'insertRole'@'ip-máquina' IDENTIFIED BY 'pwd';
GRANT INSERT ON crane.user TO 'insertRole'@'ip-máquina';
