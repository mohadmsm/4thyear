CREATE DATABASE myappdb;

CREATE USER 'myappdbuser'@'%' IDENTIFIED BY 'myappdbpass';

GRANT ALL PRIVILEGES ON myappdb.* TO 'myappdbuser'@'%';

FLUSH PRIVILEGES;

USE myappdb;

SHOW TABLES;

# to see a table’s structure
DESCRIBE auth_user;
