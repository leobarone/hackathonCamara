#mysql -uroot --local-infile=1 -p < /home/lasagna/hackatonCamara/scriptLoadRais11.sql 
LOAD DATA LOCAL INFILE '/home/lasagna/RAIS/rais_estabelecimento_ident_2011/rais11.txt'
INTO TABLE RAIS.rais11
FIELDS TERMINATED BY ';' ;
