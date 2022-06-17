-- select * from (
select 
  atomic_parameters.code,
  atomic_parameters.description,
  d.uid,
  cars.car_reg_number,
  device_type.name,
  max_recdate,
  split_part(cast(d.min_rectime as text), ' ', 2) as min_rectime,  
  split_part(cast(d.max_rectime as text), ' ', 2) as max_rectime,  
  max_date,
  split_part(cast(d.max_time as text), ' ', 2) as max_time,        
  d.amount
from  atomic_parameters ,    
     trains,
     cars,
     train_history,
     car_history,
     device_new,
  device_type,
 (select  
   data_atomic.code,   
  data_atomic.device_uid as uid, 
     date(data_atomic.time_received) as max_recdate,
     min(data_atomic.time_received) as min_rectime,
     max(data_atomic.time_received) as max_rectime,
     max(date(data_atomic.time)) as max_date,  
     max(data_atomic.time) as max_time,
   count(id) as amount
 from data_atomic
 where 
    time_received > '2022-06-17'  
    and time_received < '2022-06-18'  
 group by max_recdate, uid, data_atomic.code
  ) as d
where  atomic_parameters.code = d.code
      and trains.reg_number = train_history.train_reg_number
   and cars.car_reg_number = train_history.car_reg_number
   and car_history.car_id = cars.id
   and car_history.device_id = device_new.id
   and device_type.id = device_new.device_type_id
   and d.uid = device_new.device_uid
order by max_recdate desc,
  cars.car_reg_number,
  d.uid,
     device_type.name, 
  atomic_parameters.code
-- ) as foo
-- where
-- 	uid = '003c001d3436511030343832'