set names 'utf8';
DROP DATABASE IF EXISTS trackvisits;
create database trackvisits character set utf8 collate utf8_general_ci;
grant all on trackvisits.* to 'observer'@'%' identified by 'Password1';
use trackvisits;
create table visits (id int primary key auto_increment, ts timestamp DEFAULT CURRENT_TIMESTAMP, dummy int);