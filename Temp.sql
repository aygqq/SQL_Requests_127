SELECT * 
FROM ( 
SELECT
	split_part(cast(time as text), ' ', 1) as fact_date,
	split_part(cast(time_received as text), ' ', 2) as rec_time,
	split_part(cast(time as text), ' ', 2) as fact_time,
    cast(split_part(value, ',', 2) as integer) as B_num,
    cast(split_part(value, ',', 1) as integer) as Temperature,
	(time_received - time) as delta
FROM
    public.data_atomic
where
    code = 3
    and right(value, 6) = ',0,102'
	and device_uid = '0058001c3436511030343832'
	and time > '2021-10-23 11:50'  
    and time < '2021-10-24 13:30'  
ORDER BY
    time_received desc, time desc, id desc
LIMIT 350000 ) as foo
-- where
-- 	B_num = 0