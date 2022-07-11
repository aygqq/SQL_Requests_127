SELECT * 
FROM ( 
SELECT
	id,
	device_uid,
	split_part(cast(time_received as text), ' ', 1) as rec_date,
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
	and device_uid = '0040001e3436511030343832'
	and time_received > '2022-07-01' 
-- 	and time_received < '2022-05-21' 
ORDER BY
    time_received desc, time desc, id desc
LIMIT 10000000 ) as foo
where
-- 	foo.gr = '04'
-- 	and (foo.code = '0d' or foo.code = '0e') -- RSSI all and filter counters
-- 	and (foo.code = '0f') -- Repeat telemetry
	foo.gr = '03'
-- 	and (foo.code = '01' or foo.code = '02') -- BKTE and PPRU fw versions
	and foo.code = '09' -- PPRU state and time
-- 	and foo.num = 23
	and foo.param > 5
-- 	and foo.cnt > 10
-- 	and foo.code = '0a' -- Speed changed