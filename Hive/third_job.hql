create view if not exists trend2016_17_18 as 
	select t1.name,t1.sector,t1.trend as trend2016,t2.trend as trend2017,t3.trend as trend2018
	from annualtrend2016_2018 t1 join annualtrend2016_2018 t2 on t1.name=t2.name join 
	annualtrend2016_2018 t3 on t2.name=t3.name where t1.anno=2016 and t2.anno=2017 and t3.anno=2018;
select t1.name as company1,t2.name as company2,t1.trend2016,t1.trend2017,t1.trend2018
	from trend2016_17_18 t1 join trend2016_17_18 t2 on
	t1.trend2016=t2.trend2016 and t1.trend2017=t2.trend2017 and t1.trend2018=t2.trend2018
	where t1.name !=t2.name and t1.sector !=t2.sector;