
SELECT
	*,
	cast(v_left as bit(4)) as b_left,
	cast(v_right as bit(4)) as b_right
-- 	fact_date,
-- 	fact_hhmm,
-- 	COUNT(fact_hhmm)
FROM ( 
SELECT
	device_uid,
	split_part(cast(time_received as text), ' ', 1) as rec_date,
	split_part(cast(time_received as text), ' ', 2) as rec_time,
	split_part(cast(time as text), ' ', 1) as fact_date,
	split_part(cast(time as text), ' ', 2) as fact_time,
	cast(split_part(value, ',', 2) as integer) as addr,
-- 	cast(split_part(value, ',', 1) as integer) as val,
	((cast(split_part(value, ',', 1) as integer) >> 4)  % 16) as v_left,
	((cast(split_part(value, ',', 1) as integer))  % 16) as v_right,
	cast(cast(split_part(value, ',', 1) as integer) as bit(8)) as bits
-- 	((cast(split_part(value, ',', 1) as integer) >> 2)  % 2) as answ_485,
-- 	((cast(split_part(value, ',', 1) as integer) >> 1)  % 2) as bounce,
-- 	(cast(split_part(value, ',', 1) as integer)  % 2) as door,
-- 	SUBSTRING(cast(split_part(cast(time as text), ' ', 2) as text), 1, 4) as fact_hhmm,
-- 	(time_received - time) as delta
FROM
    public.data_atomic
where
    code = 9
	and device_uid = '0058001c3436511030343832'
-- 	and time > '2022-03-16' 
-- 	and time < '2022-03-17' 
ORDER BY
    time_received desc, time desc, id desc
LIMIT 15000 ) as foo
where
	addr = 1
-- 7 - valid, ok, open
-- 6 - invalid, ok, open
-- 5 - valid, malfun, open
-- 4 - invalid, malfun, open
-- 3 - valid, ok, close
-- 2 - invalid, ok, close
-- 1 - valid, malfun, close
-- GROUP BY fact_date, fact_hhmm