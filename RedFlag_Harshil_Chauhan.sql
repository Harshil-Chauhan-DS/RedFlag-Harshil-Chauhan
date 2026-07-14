/* RedFlag Project {Minor Project 3} - Harshil Chauhan
Database: redflag - Provided by The Unlox Academy
*/

-- P1: High volume of txns
select user_id, date(txn_time) as d, count(*) as c 
from transactions
group by user_id, date(txn_time) 
having count(*) >= 30 
order by c desc;

-- P2: Round numbers
SELECT user_id, count(*) as c 
from transactions 
where amount in (100, 200, 500, 1000, 2000, 5000, 10000)
group by user_id 
having c >= 15 
order by c desc;

-- P3: Micro-transactions under $10
select user_id, date(txn_time) as d, count(*) as c 
from transactions 
where amount < 10
group by user_id, date(txn_time) 
having c >= 30;

-- P4: high failure rates
select user_id, count(*) as c 
from transactions 
where status = 'FAILED' 
group by user_id 
having count(*) >= 20 
order by c desc;

-- P5: Odd hours (2 AM to 4 AM)
select user_id, count(*) as total, 
sum(case when hour(txn_time) between 2 and 4 then 1 else 0 end) as oh
from transactions 
group by user_id 
having total >= 30 and (oh * 1.0 / total) >= 0.8 
order by oh desc;

-- P6: Quick flip (credit then debit within 30 mins)
-- swapped out the sqlite strftime stuff for native timestampdiff
select c.user_id, count(*) as cnt 
from transactions c 
join transactions d 
  on c.user_id = d.user_id 
  and c.txn_type = 'CREDIT' 
  and d.txn_type = 'DEBIT'
  and timestampdiff(MINUTE, c.txn_time, d.txn_time) between 0 and 30
  and d.amount >= 0.7 * c.amount
group by c.user_id 
having cnt >= 5;

-- P7: High refund ratio
select user_id, count(*) as total, 
sum(case when txn_type = 'REFUND' then 1 else 0 end) as rf
from transactions 
group by user_id 
having total >= 20 and (rf * 1.0 / total) > 0.4;

-- P8: Merchant collusion 
-- (couldn't fully figure out the complex math for this one, so just pulling top 15 suspicious merchants)
select merchant_id, count(distinct user_id) as unique_users, count(*) as total_txns
from transactions
group by merchant_id
order by total_txns desc 
limit 15;

-- P9: Evasion thresholds (exactly 9999)
SELECT user_id, count(*) as c 
from transactions 
where amount = 9999.00 
group by user_id 
having c >= 10;

-- P10: Dormant account waking up
-- using native DATEDIFF for mysql instead of julianday
with gaps as (
    select user_id, txn_time,
           lag(txn_time) over (partition by user_id order by txn_time) as prev_time
    from transactions
),
dormant as (
    select user_id, txn_time as gap_end_time
    from gaps
    where prev_time is not null and datediff(txn_time, prev_time) >= 90
)
select d.user_id, count(*) as post 
from dormant d
join transactions t on t.user_id = d.user_id and t.txn_time >= d.gap_end_time
group by d.user_id 
having post >= 15 
order by post desc;

-- P11: Velocity spike
with monthly as (
    select user_id, date_format(txn_time, '%Y-%m') as ym, count(*) as txn_count
    from transactions 
    group by user_id, date_format(txn_time, '%Y-%m')
),
user_stats as (
    select user_id, avg(txn_count) as avg_count, max(txn_count) as peak_count
    from monthly 
    group by user_id
)
select user_id, avg_count, peak_count 
from user_stats 
where peak_count >= 20 and peak_count >= 5 * avg_count;

-- P12: Geographic impossibility 
-- (diff city within 1 hour)
with ordered as (
    select user_id, city, txn_time,
    lag(city) over (partition by user_id order by txn_time) as prev_city,
    lag(txn_time) over (partition by user_id order by txn_time) as prev_time
    from transactions
)
select user_id, prev_city, city, prev_time, txn_time
from ordered
where prev_city is not null 
and city != prev_city 
and timestampdiff(HOUR, prev_time, txn_time) <= 1
order by user_id;