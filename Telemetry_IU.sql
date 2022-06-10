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
-- 	(cast(split_part(value, ',', 1) as integer) >> 24) as num,
-- 	(cast(split_part(value, ',', 1) as integer) % 16777216) as param,
	(time_received - time) as delta
FROM
    public.data_atomic
where
    code = 5
    and device_uid = '0040001e3436511030343832'

	and time_received > '2022-06-05' 
-- 	and time_received < '2022-06-09' 
ORDER BY
    time_received desc, time desc, id desc
LIMIT 500000 ) as foo
where
--     (foo.gr = '01' and (foo.code = '01')) -- BSG fw
-- 	or (foo.gr = '03' and (foo.code = '06')) -- IU fw
    
-- 	foo.gr = '03' and foo.code = '0a'
	foo.gr = '02' 
-- 	or foo.gr = '01'
	or (foo.gr = '01' and (foo.code != '07' and foo.code != '08')) -- BSG update
	or (foo.gr = '03' and (foo.code = '06' or foo.code = '07' or foo.code = '08')) -- IU update