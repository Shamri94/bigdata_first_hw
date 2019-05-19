create view if not exists fullstocktable as 
	select t1.ticker,t1.volume,t1.close,t1.data,t2.sector,t2.name
	from historical_stock_prices t1 join stockinfo t2
	on t1.ticker=t2.ticker;

create table if not exists firstday2016_2018 as 
	select t1.ticker,t1.name,min(t1.data) as firstday,year(t1.data) as anno
	from fullstocktable t1
	where year(t1.data)>=2016 and year(t1.data)<=2018
	group by t1.ticker,t1.name,year(t1.data);

create table if not exists lastday2016_2018 as 
	select t1.ticker,t1.name,max(t1.data) as lastday,year(t1.data) as anno
	from fullstocktable t1
	where year(t1.data)>=2016 and year(t1.data)<=2018
	group by t1.ticker,t1.name,year(t1.data);

create view if not exists firstdaycompanyquotation as
	select t1.name,t1.sector,sum(t1.close) as firstdayquotation,year(t1.data) as anno 
	from fullstocktable t1 join firstday2016_2018 t2 
	on t1.name=t2.name and t1.data=t2.firstday
	group by t1.name,t1.sector,year(t1.data);

create view if not exists lastdaycompanyquotation as
	select t1.name,t1.sector,sum(t1.close) as lastdayquotation,year(t1.data) as anno
	from fullstocktable t1 join lastday2016_2018 t2
	on t1.data=t2.lastday and t1.name=t2.name
	group by t1.name,t1.sector,year(t1.data);

create table if not exists annualtrend2016_2018 as
	select t1.name,t1.anno,t1.sector,round((t2.lastdayquotation-t1.firstdayquotation)*100/t1.firstdayquotation) as trend 
	from firstdaycompanyquotation t1 join lastdaycompanyquotation t2 on 
	t1.name=t2.name and t1.anno=t2.anno
	order by t1.name,t1.anno;