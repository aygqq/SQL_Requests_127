SELECT * 
FROM ( 
SELECT
	device_uid,
	split_part(cast(time as text), ' ', 1) as fact_date,
	split_part(cast(time_received as text), ' ', 2) as rec_time,
	split_part(cast(time as text), ' ', 2) as fact_time,
    cast(split_part(value, ',', 3) as text) as gr,
    cast(split_part(value, ',', 2) as text) as code,
    cast(split_part(value, ',', 1) as text) as val,
-- 	value,
	(time_received - time) as delta
FROM
    public.data_atomic
where
    code = 5
	and device_uid = '0057001c3436511030343832'
-- 	and time > '2021-11-27' 
--     and time < '2021-11-30'  
ORDER BY
   time_received desc, time desc
LIMIT 1000) as foo
-- where
-- 	delta < '-00:00:10'
-- ORDER BY
-- 	fact_date desc, fact_time desc