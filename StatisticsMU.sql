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
	cast(cast((cast(split_part(value, ',', 1) as integer) >> 24) as bit(8)) as integer) as cnt,
	cast(cast((cast(split_part(value, ',', 1) as integer) % 16777216) as bit(24)) as integer) as req_time,
-- 	cast(cast(split_part(value, ',', 1) as integer) as bit(32)) as bits,
	(time_received - time) as delta
FROM
    public.data_atomic
where
    code = 5
	and device_uid = '0040001e3436511030343832'
	and time_received > '2022-06-17' 
	and time_received < '2022-06-18' 
-- 	and time < '2022-02-05' 
ORDER BY
--     time_received desc,
	time desc, id desc
LIMIT 1000000 ) as foo
where
	foo.gr = '08'

    -- Поле результата - param
    -- Все счетчики обнуляются после формирования телеметрии (раз в минуту)
	-- Кол-во запросов, подтверждений, всего ответов, пустых ответов. Счетчики обнуляются при отправке.
-- 	and (foo.code = '01' or foo.code = '06' or foo.code = '07' or foo.code = '08')

    -- Поля результата - cnt и req_time
    -- Все счетчики обнуляются после формирования телеметрии (раз в минуту)
    -- Количество пустых ответов подряд и время в мс, втечение которого не было ответа
    and foo.code = '09'
    -- Количество запросов к ГУ с временем меньше 100мс и среднее время одного запроса в этой категории
--     and foo.code = '0a'
    -- Количество запросов к ГУ с временем больше 100мс и меньше 200мс и среднее время одного запроса в этой категории
--     and foo.code = '0b'
    -- Количество запросов к ГУ с временем больше 200мс и меньше 300мс и среднее время одного запроса в этой категории
--     and foo.code = '0c'
    -- Количество запросов к ГУ с временем больше 300мс и среднее время одного запроса в этой категории
--     and foo.code = '0d'
    
    -- Все категории времени
-- 	and (foo.code = '0a' or foo.code = '0b' or foo.code = '0c' or foo.code = '0d')
    
ORDER BY
	fact_date desc, fact_time desc, foo.code