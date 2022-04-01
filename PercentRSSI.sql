SELECT * 
FROM ( 
SELECT
	device_uid,
	split_part(cast(time as text), ' ', 1) as fact_date,
	split_part(cast(time_received as text), ' ', 2) as rec_time,
	split_part(cast(time as text), ' ', 2) as fact_time,
    split_part(value, ',', 8) as ppru_from,
    split_part(value, ',', 7) as ppru_to,
    split_part(value, ',', 6) as perfect,
    split_part(value, ',', 5) as good,
    split_part(value, ',', 4) as normal,
    split_part(value, ',', 3) as bad,
    split_part(value, ',', 2) as no_rssi,
    split_part(value, ',', 1) as count, 
	(time_received-time) as delta
FROM
    public.data_atomic
where
    code = 8
	and device_uid = '0057001c3436511030343832'
	and time_received > '2022-03-30' 
--     and time < '2021-11-13' 
ORDER BY
    time_received desc, time desc, id desc
LIMIT 100000 ) as foo
-- where
-- 	foo.ppru_from = '25'
-- 	and foo.ppru_from = '02'
ORDER BY
	device_uid