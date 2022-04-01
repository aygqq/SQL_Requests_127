-- SELECT 
-- 	order_num,
-- 	COUNT(order_num)
-- FROM (
	SELECT
	*
FROM
    public.data_atomic
where
	device_uid = '0057001c3436511030343832'
-- 	device_uid = '0072002b3436510f30343832'
	and time_received > '2022-03-29' 
--     and time < '2021-12-04'  
ORDER BY
    time_received desc, time desc
LIMIT 1000
-- ) as foo
-- GROUP BY order_num