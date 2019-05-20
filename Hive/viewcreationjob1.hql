create view if not exists generalinfo  as 
	select ticker,min(lowthe) as minprice,max(highthe) as maxprice,avg(volume) as avgvolume
	from dailystock
	where year(data)>=1998 and year(data)<=2018
	group by ticker;
create view if not exists mindate1998 as
	select ticker,min(data) as mindate
	from dailystock
	where year(data)=1998
	group by ticker;
create view if not exists maxdate2018 as
	select ticker,max(data) as maxdate
	from dailystock
	where year(data)=2018
	group by ticker;
create view if not exists closeprice1998 as
	select t1.ticker,t2.close
	from mindate1998 t1 join dailystock t2 
	on t1.ticker=t2.ticker and t1.mindate=t2.data;
create view if not exists closeprice2018 as
	select t1.ticker,t2.close
	from maxdate2018 t1 join dailystock t2 
	on t1.ticker=t2.ticker and t1.maxdate=t2.data;
create view if not exists percentageincs as
	select t1.ticker, ((t1.close-t2.close)/t2.close) as incrementopercentuale
	from closeprice2018 t1 join closeprice1998 t2
	on t1.ticker=t2.ticker;