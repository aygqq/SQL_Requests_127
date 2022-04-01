SELECT * 
FROM ( 
SELECT
	id,
	device_uid,
	split_part(cast(time as text), ' ', 1) as fact_date,
	split_part(cast(time_received as text), ' ', 2) as rec_time,
	split_part(cast(time as text), ' ', 2) as fact_time,
    cast(split_part(value, ',', 3) as text) as gr,
    cast(split_part(value, ',', 2) as text) as code,
    cast(split_part(value, ',', 1) as text) as val,
	(cast(split_part(value, ',', 1) as integer) >> 24) as num,
	(cast(split_part(value, ',', 1) as integer) % 65536) as param,
	(time_received - time) as delta
FROM
    public.data_atomic
where
    code = 5
	and device_uid = '0058001c3436511030343832'
	and time > '2022-02-19' 
--     and time < '2021-11-25' 
ORDER BY
    time_received desc, time desc, id desc
LIMIT 10000 ) as foo
where
-- 	foo.gr = '04'
-- 	and (foo.code = '0d' or foo.code = '0e') -- RSSI all and filter counters
-- 	and (foo.code = '0f') -- Repeat telemetry
	foo.gr = '03'
	and foo.code = '09' -- PPRU state and time
-- 	and foo.num = 7
-- 	and foo.param > 3
-- 	and foo.cnt > 10
-- 	and foo.code = '0a' -- Speed changed
ORDER BY
	device_uid