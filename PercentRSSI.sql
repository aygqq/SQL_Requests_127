SELECT 
    * ,
    abs(foo.ppru_from - foo.ppru_to) as distance
FROM ( 
SELECT
	device_uid,
	split_part(cast(time as text), ' ', 1) as fact_date,
	split_part(cast(time_received as text), ' ', 2) as rec_time,
	split_part(cast(time as text), ' ', 2) as fact_time,
    cast(split_part(value, ',', 8) as integer) as ppru_from,
    cast(split_part(value, ',', 7) as integer) as ppru_to,
    cast(split_part(value, ',', 6) as integer) as perfect,
    cast(split_part(value, ',', 5) as integer) as good,
    cast(split_part(value, ',', 4) as integer) as normal,
    cast(split_part(value, ',', 3) as integer) as bad,
    cast(split_part(value, ',', 2) as integer) as no_rssi,
    cast(split_part(value, ',', 1) as integer) as count, 
	(time_received-time) as delta
FROM
    public.data_atomic
where
    code = 8
	and device_uid = '0055001c3436511030343832'
	and time_received > '2022-04-29' 
--     and time < '2021-11-13' 
ORDER BY
--     time_received desc,
	time desc, id desc
LIMIT 100000 ) as foo
-- where
--     abs(foo.ppru_from - foo.ppru_to) = 1 -- Distance
-- 	foo.ppru_to = 13
-- 	and foo.ppru_from = '02'