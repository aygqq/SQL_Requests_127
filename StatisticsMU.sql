SELECT * 
FROM ( 
SELECT
	id,
	device_uid,
	split_part(cast(time_received as text), ' ', 1) as rec_date,
	split_part(cast(time_received as text), ' ', 2) as rec_time,
	split_part(cast(time as text), ' ', 1) as fact_date,
	split_part(cast(time as text), ' ', 2) as fact_time,
    cast(split_part(value, ',', 3) as text) as gr,
    cast(split_part(value, ',', 2) as text) as code,
    cast(split_part(value, ',', 1) as integer) as param,
-- 	(cast(split_part(value, ',', 1) as integer) >> 24) as num,
-- 	(cast(split_part(value, ',', 1) as integer) % 16777216) as cnt,
	(time_received - time) as delta
FROM
    public.data_atomic
where
    code = 5
	and device_uid = '0040001e3436511030343832'
	and time_received > '2022-06-16' 
	and time_received < '2022-06-17' 
-- 	and time < '2022-02-05' 
ORDER BY
--     time_received desc,
	time desc, id desc
LIMIT 1000000 ) as foo
where
	foo.gr = '08'
	-- Кол-во запросов, подтверждений, всего ответов, пустых ответов. Счетчики обнуляются при отправке.
	and (foo.code = '01' or foo.code = '06' or foo.code = '07' or foo.code = '08')
ORDER BY
	fact_date desc, fact_time desc, foo.code