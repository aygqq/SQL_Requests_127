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
	(cast(split_part(value, ',', 1) as integer) >> 24) as b1,
	((cast(split_part(value, ',', 1) as integer) >> 16) % 256) as b2,
	((cast(split_part(value, ',', 1) as integer) >> 8) % 256) as b3,
	(cast(split_part(value, ',', 1) as integer) % 256) as b4,
	(time_received - time) as delta
FROM
    public.data_atomic
where
    code = 5
-- 	and device_uid = '0057001c3436511030343832' -- 224-1
-- 	and device_uid = '0072002b3436510f30343832' -- 224-11
	
-- 	and device_uid = '006d002c3436510f30343832' -- 226-1
-- 	and device_uid = '006a002b3436510f30343832' -- 226-11
	
-- 	and device_uid = '005c001c3436511030343832' -- 232-1
-- 	and device_uid = '0065002c3436510f30343832' -- 232-11
	
-- 	and device_uid = '003c001d3436511030343832' -- 243-1
-- 	and device_uid = '0039001d3436511030343832' -- 243-11
	
-- 	and device_uid = '0058001c3436511030343832' -- 245-1
-- 	and device_uid = '005a001c3436511030343832' -- 245-11
	
-- 	and device_uid = '0065002b3436510f30343832' -- 250-1
-- 	and device_uid = '0036001d3436511030343832' -- 250-11
	
-- 	and device_uid = '0061001d3436511030343832' -- 251-1
-- 	and device_uid = '005b001c3436511030343832' -- 251-11
	
-- 	and device_uid = '0040001e3436511030343832' -- 261-1
-- 	and device_uid = '006a002c3436510f30343832' -- 261-11
	
-- 	and device_uid = '0074002b3436510f30343832' -- 272-1
-- 	and device_uid = '0034001d3436511030343832' -- 272-11
	and time_received > '2022-11-10' 
-- 	and time_received < '2022-06-09' 
ORDER BY
    time_received desc, time desc, id desc
LIMIT 100000 ) as foo
where
--     (foo.gr = '01' and (foo.code = '01')) -- BSG fw
-- 	or (foo.gr = '03' and (foo.code = '06')) -- IU fw
    
-- 	foo.gr = '03' and foo.code = '0a'
	foo.gr = '02' 
-- 	or foo.gr = '01'
	or (foo.gr = '01' and (foo.code != '07' and foo.code != '08')) -- BSG update
	or (foo.gr = '03' and (foo.code = '06' or foo.code = '07' or foo.code = '08')) -- IU update