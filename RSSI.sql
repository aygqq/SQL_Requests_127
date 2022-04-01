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
	((cast(split_part(value, ',', 1) as integer) >> 24) % 256) as req,
	((cast(split_part(value, ',', 1) as integer) >> 16) % 256) as ppru_to,
	((cast(split_part(value, ',', 1) as integer) >> 8) % 256) as ppru_from,
	(cast(split_part(value, ',', 1) as integer) % 256) as rssi,
	(time_received - time) as delta
FROM
    public.data_atomic
where
    code = 5
	and device_uid = '003600453037511632373437'
	and time_received > '2022-02-25' 
--     and time < '2021-11-13'
ORDER BY
    time_received desc, time desc, id desc
LIMIT 10000000 ) as foo
where
	foo.gr = '03'
	and foo.code = '04'
-- 	and ppru_to = 1
-- 	and ppru_from = 3
-- 	and req = 2
	and rssi = 95
-- 	and rssi < 255