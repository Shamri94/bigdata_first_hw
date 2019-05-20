select t1.ticker,t2.incrementopercentuale,t1.minprice,t1.maxprice,t1.avgvolume
from generalinfo t1 join percentageincs t2
on t1.ticker=t2.ticker
order by t2.incrementopercentuale desc
limit 10;