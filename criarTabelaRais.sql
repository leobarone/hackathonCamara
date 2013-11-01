create database RAIS;
use RAIS;

DROP TABLE IF EXISTS `rais11`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rais11` (
`BairrosSP` varchar(60) DEFAULT NULL,
`BairrosCE` varchar(60) DEFAULT NULL,
`BairrosRJ` varchar(60) DEFAULT NULL,
`CNAE20Classe` bigint(10) DEFAULT NULL,
`CNAE95Classe` bigint(10) DEFAULT NULL,
`DistritosSP` varchar(60) DEFAULT NULL,
`QtdVínculosCLT` bigint(10) DEFAULT NULL,
`QtdVínculosAtivos` bigint(10) DEFAULT NULL,
`QtdVínculosEstatutários` bigint(10) DEFAULT NULL,
`IndAtividadeAno` bigint(10) DEFAULT NULL,
`IndCEIVinculado` bigint(10) DEFAULT NULL,
`IndEstabParticipaPAT` bigint(10) DEFAULT NULL,
`IndRaisNegativa` bigint(10) DEFAULT NULL,
`IndSimples` bigint(10) DEFAULT NULL,
`munic` bigint(10) DEFAULT NULL,
`NaturezaJuridica` bigint(10) DEFAULT NULL,
`RegioesAdmDF` bigint(10) DEFAULT NULL,
`CNAE20Subclasse` bigint(10) DEFAULT NULL,
`TamanhoEstabelecimento` bigint(10) DEFAULT NULL,
`TipoEstab` varchar(60) DEFAULT NULL,
`TipoEstab1` varchar(60) DEFAULT NULL,
`cep` bigint(20) DEFAULT NULL,
`cnpj` bigint(20) DEFAULT NULL,
`CEIVinculado` bigint(10) DEFAULT NULL,
`NomeBairro` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOAD DATA LOCAL INFILE '/home/lasagna/RAIS/rais_estabelecimento_ident_2011/rais11txt'
INTO TABLE RAISrais11
FIELDS TERMINATED BY ':' 
IGNORE 1 LINES;

CREATE TABLE `empresas` AS
	SELECT munic, cnpj, cep FROM RAIS.rais11
;

CREATE INDEX cnpjIndex
ON empresas(cnpj);