create view if not exists fullstocktable as 
	select t1.ticker,t1.volume,t1.close,t1.data,t2.sector
	from historical_stock_prices t1 join stockinfo t2
	on t1.ticker=t2.ticker;
create view if not exists firstday2004_2018 as 
	select t1.sector,min(t1.data) as firstday
	from fullstocktable t1
	where year(t1.data)>=2004 and year(t1.data)<=2018
	group by t1.sector,year(t1.data);

create view if not exists lastday2004_2018 as 
	select t1.sector,max(t1.data) as lastday
	from fullstocktable t1
	where year(t1.data)>=2004 and year(t1.data)<=2018
	group by t1.sector,year(t1.data);

create view if not exists volumebysector as 
	select t1.sector,sum(t1.volume) as annualvolume,year(t1.data) as anno
	from fullstocktable t1
	where year(t1.data)>=2004 and year(t1.data)<=2018
	group by t1.sector,year(t1.data);

create view if not exists firstdaysectorquotation as
	select t1.sector,sum(t1.close) as firstdayquotation,year(t1.data) as anno 
	from fullstocktable t1 join firstday2004_2018 t2
	on t1.sector=t2.sector and t1.data=t2.firstday
	group by t1.sector,year(t1.data);

create view if not exists lastdaysectorquotation as
	select t1.sector,sum(t1.close) as lastdayquotation,year(t1.data) as anno
	from fullstocktable t1 join lastday2004_2018 t2
	on t1.sector=t2.sector and t1.data=t2.lastday
	group by t1.sector,year(t1.data);

create view if not exists dailyavgquotationbysector as 
	select t2.sector,avg(t2.dailyquotation) as avgdailyquotation,year(t2.data) as anno 
	from(
		select t1.sector,sum(t1.close) as dailyquotation,t1.data
		from fullstocktable t1
		where year(t1.data)>=2004 and year(t1.data)<=2018
		group by t1.sector,t1.data) t2
	group by t2.sector,year(t2.data);
create table secondjob as 
select t1.sector,t1.annualvolume,t1.avgdailyquotation,t2.quotationincrease,t1.anno
	from (select * from volumebysector a join dailyavgquotationbysector b on a.sector=b.sector and a.anno=b.anno) t1 
	join (select c.sector,round((c.lastdayquotation-d.firstdayquotation)/d.firstdayquotation) as quotationincrease, c.anno
	from lastdaysectorquotation c join firstdaysectorquotation d on c.sector=d.sector and c.anno=d.anno) t2 
	on t1.sector=t2.sector and t1.anno=t2.anno
	order by t1.sector,t1.anno;