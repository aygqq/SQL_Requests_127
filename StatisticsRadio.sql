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
	(cast(split_part(value, ',', 1) as integer) >> 24) as num,
	(cast(split_part(value, ',', 1) as integer) % 16777216) as cnt,
	(time_received - time) as delta
FROM
    public.data_atomic
where
    code = 5
	and device_uid = '006d002c3436510f30343832'
	and time_received > '2022-07-26' 
-- 	and time_received < '2022-06-24' 
-- 	and time < '2022-02-05' 
ORDER BY
--     time_received desc,
	time desc, id desc
LIMIT 1000000 ) as foo
where
	foo.gr = '07'
	-- Кол-во отправленых, полученных дверей. А также наполнение пакетов с дверьми. Счетчики обнуляются при отправке.
-- 	and (foo.code = '01' or foo.code = '02' or foo.code = '04') 
	and (foo.code = '01' or foo.code = '02') 
-- 	and (foo.code = '02') 
--  and (foo.code = '04') 
	
	-- Ошибки по дверям, счетчики не обнуляются при отправке.
-- 	and (foo.code = '03') 

	-- Кол-во отправленных и полученных пакетов RSSI по каждому ППРУ. Счетчики обнуляются при отправке.
-- 	and (foo.code = '05') 
-- 	and foo.num = 3
ORDER BY
	fact_date desc, fact_time desc, num desc