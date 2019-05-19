create table stockinfo(ticker string,borsa string,name string,sector string,industry string)
row format SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES(
	"separatorChar"= ",",
	"quoteChar" = "\"",
	"skip.header.line.count"="1"
)

STORED AS TEXTFILE;
