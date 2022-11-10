SELECT 
fact_date,
rec_time,
fact_time,
-- delta,
-- gr,
-- code,
num,
v_left,
v_right,
((measure >> 10) & 1) as c1,
((measure >> 8) & 1) as c2,
((measure >> 6) & 1) as l1,
((measure >> 4) & 1) as l2,
((measure >> 2) & 1) as l3,
((measure >> 0) & 1) as l4,
((measure >> 11) & 1) as c1_b,
((measure >> 9) & 1) as c2_b,
((measure >> 7) & 1) as l1_b,
((measure >> 5) & 1) as l2_b,
((measure >> 3) & 1) as l3_b,
((measure >> 1) & 1) as l4_b
-- bits
FROM ( 
SELECT
	device_uid,
	split_part(cast(time_received as text), ' ', 1) as rec_date,
	split_part(cast(time_received as text), ' ', 2) as rec_time,
	split_part(cast(time as text), ' ', 1) as fact_date,
	split_part(cast(time as text), ' ', 2) as fact_time,
	(time_received - time) as delta,
    cast(split_part(value, ',', 3) as text) as gr,
    cast(split_part(value, ',', 2) as text) as code,
    cast(split_part(value, ',', 1) as text) as val,
	(cast(split_part(value, ',', 1) as integer) >> 24) as num,
	((((cast(split_part(value, ',', 1) as integer) >> 16) % 256) >> 4)  % 16) as v_left,
	(((cast(split_part(value, ',', 1) as integer) >> 16) % 256) % 16) as v_right,
	(cast(split_part(value, ',', 1) as integer) % 65536) as measure,
	cast((cast(split_part(value, ',', 1) as integer) % 65536) as bit(12)) as bits
FROM
    public.data_atomic
where
    code = 5
	and device_uid = '004f00244d4d50012036394e'
-- 	and time > '2022-02-21' 
-- 	and time < '2022-02-22' 
ORDER BY
    time_received desc, time desc, id desc
LIMIT 1000 ) as foo
where
	foo.gr = '03'
	and (foo.code = '03') -- new doors telemetry
-- 	and (num = 1)
ORDER BY
	device_uid
	
-- 7 - valid, ok, open
-- 6 - invalid, ok, open
-- 5 - valid, malfun, open
-- 4 - invalid, malfun, open
-- 3 - valid, ok, close
-- 2 - invalid, ok, close
-- 1 - valid, malfun, close
-- 0 - invalid, malfun, close