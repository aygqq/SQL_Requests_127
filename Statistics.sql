SELECT * 
FROM ( 
SELECT
	device_uid,
	split_part(cast(time_received as text), ' ', 1) as rec_date,
	split_part(cast(time_received as text), ' ', 2) as rec_time,
	split_part(cast(time as text), ' ', 1) as fact_date,
	split_part(cast(time as text), ' ', 2) as fact_time,
    cast(split_part(value, ',', 3) as text) as gr,
    cast(split_part(value, ',', 2) as text) as code,
    cast(split_part(value, ',', 1) as text) as val,
	(cast(split_part(value, ',', 1) as integer) >> 24) as num,
	(cast(split_part(value, ',', 1) as integer) % 16777216) as cnt,
	(time_received - time) as delta
FROM
    public.data_atomic
where
    code = 5
	and device_uid = '0040001e3436511030343832'
	and time_received > '2022-06-02' 
	and time_received < '2022-06-03' 
-- 	and time < '2022-02-05' 
ORDER BY
    time_received desc, time desc, id desc
LIMIT 100000 ) as foo
where
	foo.gr = '04'
-- 	and (foo.code = '01' or foo.code = '02' or foo.code = '03' or foo.code = '0b') -- BSG err, MU err, MU strange, IU err
	and (foo.code = '04' or foo.code = '0c' or foo.code = '05') -- Send, recv and err by type
-- 	and num = 20
-- and (foo.code = '06' or foo.code = '07') -- Err req and missed doors
-- 	and (foo.code = '08' or foo.code = '09') -- Empty answers, rssi parse err
-- 	and (foo.code = '0d' or foo.code = '0e') -- RSSI all and filter counters

-- 	foo.gr = '03'
-- 	and (foo.code = '03' or foo.code = '0b') -- new doors telemetry
-- 	and (foo.code = '09') -- PPRU state and time
-- 	and (foo.code = '06' or foo.code = '07' or foo.code = '08') -- IU boot
-- 	and foo.code = '0c'
ORDER BY
	device_uid