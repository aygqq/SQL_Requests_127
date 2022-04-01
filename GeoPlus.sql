SELECT
	device_uid,
	order_num,
	split_part(cast(time_received as text), ' ', 1) as rec_date,
	split_part(cast(time_received as text), ' ', 2) as rec_time,
	split_part(cast(time as text), ' ', 1) as fact_date,
	split_part(cast(time as text), ' ', 2) as fact_time,
-- 	(time_received - time) as delta,
    split_part(cast(value as text), ',', 7) as lon,
    split_part(cast(value as text), ',', 6) as lat,
    (cast(split_part(cast(value as text), ',', 5) as float) / 100) as altitude,
    split_part(cast(value as text), ',', 4) as angle,
    split_part(cast(value as text), ',', 3) as speed,
    cast(split_part(cast(value as text), ',', 2) as integer) as satellites,
    (cast(split_part(cast(value as text), ',', 1) as float) / 100) as hdop
-- 	value
FROM
    public.data_atomic
where
	code = 10
    and device_uid = '0058001c3436511030343832'
	and time < '2022-03-31' 
--     and time < '2021-12-01 23:00'  
ORDER BY
    time_received desc, time desc, id desc
LIMIT 15000
;