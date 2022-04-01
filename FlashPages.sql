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
	(time_received - time) as delta
FROM
    public.data_atomic
where
    code = 5
	and device_uid = '0058001c3436511030343832'
-- 	and time > '2021-11-17' 
--     and time < '2021-11-24'  
ORDER BY
    time_received desc, time desc, id desc
LIMIT 100000 ) as foo
where
	foo.gr = '05'
-- 	and (foo.code = '06' and foo.val > '0') -- Errors on BSG
-- 	and (foo.code = '02' or foo.code = '07') -- read on IU and recv on BSG
-- 	and (foo.code = '01' or foo.code = '02') -- write and read on IU
ORDER BY
	device_uid