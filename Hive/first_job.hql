create view primaultimadata as select ticker,min(data) as mindate,max(data) as maxdate
from historical_stock_prices
group by ticker;

create view primadata as
	select t1.ticker,t1.close
	from historical_stock_prices t1 join primaultimadata t2
	on t1.ticker=t2.ticker and t1.data=t2.mindate;

create view ultimadata as
	select t1.ticker,t1.close
	from historical_stock_prices t1 join primaultimadata t2
	on t1.ticker=t2.ticker and t1.data=t2.maxdate;

create view dailyavgvolume as 
	select ticker,avg(volume) as avgdailyvol,min(lowthe) as minlowthe,max(lowthe)as maxlowthe
	from historical_stock_prices
	where year(data)>=1998 and year(data)<=2018
	group by ticker;
