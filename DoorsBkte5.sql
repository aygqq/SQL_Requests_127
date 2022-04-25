SELECT
	rec_date,
	rec_time,
	fact_date,
	fact_time,
	addr,
	((conv_val >> 4)  % 8) as v_left,
	(conv_val  % 8) as v_right,
	((conv_val >> 7) & 1) as "10D",
	((conv_val >> 3) & 1) as "10D2",
	bits
FROM (SELECT
	*,
	cast(bits as integer) as conv_val
-- 	cast(v_left as bit(4)) as b_left,
-- 	cast(v_right as bit(4)) as b_right
-- 	fact_date,
-- 	fact_hhmm,
-- 	COUNT(fact_hhmm)
FROM (SELECT
	split_part(cast(time_received as text), ' ', 1) as rec_date,
	split_part(cast(time_received as text), ' ', 2) as rec_time,
	split_part(cast(time as text), ' ', 1) as fact_date,
	split_part(cast(time as text), ' ', 2) as fact_time,
	cast(split_part(value, ',', 2) as integer) as addr,
-- 	cast(split_part(value, ',', 1) as integer) as val,
	cast(cast(split_part(value, ',', 1) as integer) as bit(8)) as bits
-- 	SUBSTRING(cast(split_part(cast(time as text), ' ', 2) as text), 1, 4) as fact_hhmm,
-- 	(time_received - time) as delta
FROM
    public.data_atomic
where
    code = 9
	and device_uid = '0057001c3436511030343832'
	and time_received > '2022-04-25' 
-- 	and time < '2022-03-17' 
ORDER BY
--     time_received desc,
	time desc, id desc
LIMIT 15000 ) as foo
where
	addr = 20
) as foo2
-- 7 - valid, ok, open
-- 6 - invalid, ok, open
-- 5 - valid, malfun, open
-- 4 - invalid, malfun, open
-- 3 - valid, ok, close
-- 2 - invalid, ok, close
-- 1 - valid, malfun, close
-- GROUP BY fact_date, fact_hhmm