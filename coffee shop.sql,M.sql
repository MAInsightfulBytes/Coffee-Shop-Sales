
SELECT * from `coffe_shop_sales_db`.`coffee shop sales`;

update `coffee shop sales`
SET transaction_date = STR_TO_DATE(transaction_date, '%m/%d/%Y');
alter table `coffee shop sales`
modify column transaction_date date ;

describe`coffee shop sales` ;

UPDATE `coffee shop sales`
SET transaction_time = (transaction_time, '%H:%i:%s');

alter table `coffee shop sales`
change column ï»¿transaction_id transaction_id INT ;

select sum(unit_price * transaction_qty) as total_sales 
from `coffee shop sales`
where month(transaction_date) = 5 ;
SELECT ROUND(SUM(unit_price * transaction_qty)) as Total_Sales 
FROM `coffee shop sales`
WHERE MONTH(transaction_date) = 5 ; 

ALTER TABLE `coffee shop sales`
MODIFY COLUMN transaction_time TIME;

SELECT month(transaction_date) as month  , round(sum(transaction_qty * unit_price )) as total_sales ,
(sum(transaction_qty * unit_price ) - lag(sum(transaction_qty * unit_price ),1) over (order by month(transaction_date)))/ 
lag(sum(transaction_qty * unit_price ),1) over (order by month(transaction_date)) * 100  as mom_increase_percentage
from `coffee shop sales`
 WHERE month(transaction_date) in ( 4,5)
 group by MONTH(transaction_date)
ORDER BY  MONTH(transaction_date);
    /* Total orders in month 5  */
   SELECT count(transaction_id) as total_orders
   FROM `coffee shop sales` 
   where month(transaction_date) = 5 ;
 /*   mom_increase_percentage of orders  */
 select month(transaction_date) month  ,count(transaction_id) as total_orders ,
( count(transaction_id) - lag(count(transaction_id) ) over (order by month(transaction_date)  )) /
 (lag(count(transaction_id)) over (order by month(transaction_date) )) *100 as  mom_increase_percentage
 from `coffee shop sales`
where month(transaction_date) in (4,5)
group by month(transaction_date)
order by month(transaction_date) ;
/* Quantity_total */
SELECT sum(transaction_qty) total_quantity 
from `coffee shop sales` 
where month(transaction_date) = 5  ;
/* mom_increase_percentage*/
SELECT month(transaction_date) as month , sum(transaction_qty) total_quantity ,
(sum(transaction_qty)  -  lag(sum(transaction_qty)) over (order by month(transaction_date) )) / 
(lag(sum(transaction_qty)) over (order by month(transaction_date))) * 100 as mom_increase_percentage
FROM `coffee shop sales`
where month(transaction_date) in (4,5)
group by month(transaction_date) 
order by month(transaction_date) ;

SELECT concat(round(sum(transaction_qty)/1000 ,1) ,'K') total_quantity ,concat(round(sum(unit_price * transaction_qty)/1000,1),'K') as total_sales ,

concat(round(count(transaction_id)/1000,1) ,'K') as total_orders 
from `coffee shop sales`
where transaction_date = ' 2023/05/18' ;

 -- - -
 SELECT concat(round(sum(transaction_qty)/1000 ,1) ,'K') total_quantity ,concat(round(sum(unit_price * transaction_qty)/1000,1),'K') as total_sales ,

concat(round(count(transaction_id)/1000,1) ,'K') as total_orders 
from `coffee shop sales`
where transaction_date = ' 2023/05/27' ;

  -- weekend sat ,sun 
  -- week_day mon = 1 ,sat = 7 
  SELECT case when dayofweek(transaction_date) in (1,7) then 'Weekends'
  ELSE 'Week_day' End as day_type , sum(unit_price * transaction_qty) as total_sales
  from `coffee shop sales`
  where month(transaction_date) = 5 
  group by 1 ;
  -- - - - - - - - sales by location 
  SELECT store_location as location  ,CONCAT(round(sum(unit_price * transaction_qty)/1000,2),'K') as total_sales
 from `coffee shop sales`
 where month(transaction_date) =5 
 group by 1
 order by 2 DESC ;
  -- - - - - - - - -SALES TREND OVER PERIOD, average 
  SELECT  concat(round(avg(t1.total_sales)/1000,1) ,'K')
   from (SELECT sum(unit_price * transaction_qty) as total_sales 
   from `coffee shop sales`
   where month(transaction_date) = 4
  group by transaction_date ) t1 ; -- - -  using group by to calculte the total to each date then get the average 
   -- -  -- -- - -daily sales
SELECT day(transaction_date) as day ,sum(unit_price * transaction_qty) as total_sales 
from `coffee shop sales`
   where month(transaction_date) = 5
   group by 1
   order by 1 ;
   
     -- ---------- compare 'Above Average' ,'Below Average'
     SELECT t1.day , case when t1.total_sales > t1.average_sales then 'Above Average' 
     when t1.total_sales < t1.average_sales then 'Below Average'
     else 'Average' end as sales_status ,t1.total_sales
     from 
    ( SELECT day(transaction_date) as day ,sum(unit_price * transaction_qty) as total_sales ,
    avg(sum( unit_price * transaction_qty)) over() as average_sales -- ----- using over() 
     from `coffee shop sales`
     where month(transaction_date) = 5
     group by 1 )t1
     order by 1;
 -- ------------------------------ sales by category 
 select sum(unit_price * transaction_qty) as total_sales ,product_category as category 
  from `coffee shop sales`
   where month(transaction_date) = 5
   group by 2 
   order by 1 desc ;
   -- ------ sales by product type 
    select sum(unit_price * transaction_qty)  as total_sales ,product_type type_product 
  from `coffee shop sales`
   where month(transaction_date) = 5
   group by 2 
   order by 1 desc 
   limit 10 ;
   -- -  --- - sales by hour and day of week 
   SELECT round(sum(unit_price * transaction_qty))  as total_sales , sum(transaction_qty) total_quantity ,count(*) number_order
     from `coffee shop sales`
   where month(transaction_date) = 5
   AND dayofweek(transaction_date)= 3
   AND hour(transaction_time) = 8 ;
   
   --  ------ sales by hours 
     SELECT round(sum(unit_price * transaction_qty))  as total_sales ,hour(transaction_time)  as hour 
        from `coffee shop sales`
   where month(transaction_date) = 5
   group by 2
   order by 2 ;
   --  -- -------- week of day by sales 
      SELECT round(sum(unit_price * transaction_qty))  as total_sales ,CASE 
      WHEN dayofweek(transaction_date) = 2 THEN 'Monday'
      WHEN  dayofweek(transaction_date) = 3 THEN 'Tuesday'
      WHEN  dayofweek(transaction_date) = 4 THEN 'Wensday'
      WHEN  dayofweek(transaction_date) = 5 THEN 'Thursday'
      WHEN  dayofweek(transaction_date) = 6 THEN 'Friday'
      WHEN dayofweek(transaction_date) = 7 THEN 'Saturday'
      else 'Sunday' end as week_days 
        from `coffee shop sales`
   where month(transaction_date) = 5
   group by 2 ;
  
   -- -------
  SELECT 
    CASE 
        WHEN dayofweek(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
   `coffee shop sales`
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END;
 
   
   

 
    







    
    
    
    

    
    
    
    
    
    

 






