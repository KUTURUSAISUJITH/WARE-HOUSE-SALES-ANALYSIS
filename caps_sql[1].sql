-- creat a database named sales of amazon
create database sales_of_amazon; 
USE sales_of_amazon;

-- feature engineering 
alter table amazon 
add column time_of_day varchar(255);

set sQL_safe_updates=0;

update amazon 
set time_of_day=case
when hour(time)>=0 and hour(time) <12 then 'Morning'
when hour(time)>=12 and hour(time)<18 then 'afternoon'
else 'evening'
end ;

alter table amazon 
add column day_name varchar(225);

update amazon 
set day_name=upper(date_format(date,'%a')); 


alter table amazon 
add column month_name varchar(255);

update amazon 
set month_name=upper(date_format(date,'%b')); 

alter table amazon 
add column vat_percentage int ;

update  amazon
set vat_percentage=((total-cogs)/cogs)*100 ;

-- Renaming the column name
alter table amazon
change `tax 5%` tax5 int ;



select * from amazon; -- checking the data avaliable in the amazon table;
SELECT COUNT(*) FROM amazon;
-- 1. What is the count of distinct cities in the dataset?;
select city from amazon;
select distinct city from amazon;
select count(distinct city ) as city_count from amazon;

-- 2. each branch, what is the corresponding city?;
SELECT branch,city from amazon group by branch,city;

ALTER TABLE amazon
CHANGE `Product line` Product_Line VARCHAR(100);

-- 3.What is the count of distinct product lines in the dataset;
SELECT COUNT(DISTINCT Product_Line) AS Distinct_Product_Lines_Count
FROM amazon;

select Product_Line from amazon;
select distinct Product_Line from amazon;
select count(distinct Product_Line) as product_line_count from amazon;

-- 4.Which payment method occurs most frequently?;

select payment from amazon;
select max(payment) from amazon;
select count(payment) from amazon;
select COUNT(distinct payment) as distinct_payment from amazon;
SELECT payment, COUNT(payment) AS payment_count
FROM amazon
GROUP BY payment;

-- 5.Which product line has the highest sales?;
select Product_Line ,sum(total) AS total_sales from amazon
 group by Product_Line
order by sum(total) desc;

select Product_Line ,sum(total) AS total_sales from amazon
 group by Product_Line
order by sum(total) desc
limit 1;

-- 6.How much revenue is generated each month?
select monthname(date),round(sum(total),2) as each_month_revenue from amazon
group by monthname(date);

-- 7.In which month did the cost of goods sold reach its peak?;
select monthname(date) as  month_name,round(sum(cogs),2) as cost_of_goods_sold from amazon
group by month_name
order by sum(cogs) desc ;

-- 8.Which product line generated the highest revenue?;

select product_line, sum(total) as highest_revenue from amazon
group by product_line
order by sum(total) desc;

select product_line, sum(total) as highest_revenue from amazon
group by product_line
order by sum(total) desc
limit 1;


-- 9.In which city was the highest revenue recorded?;
select city,round(sum(total),2) as highest_revenue from amazon 
group by city 
order by highest_revenue
limit 1;


-- 10.Which product line incurred the highest Value Added Tax?;

select product_line ,sum(tax5) as value_added_tax from amazon 
group by product_line 
order by sum(tax5) desc;	

select product_line ,sum(tax5) as value_added_tax from amazon 
group by product_line 
order by sum(tax5) desc
limit 1;



-- 11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."

select avg(total) from amazon;

select product_line,
case when total> (select avg(total) from amazon) then 'good'
else 'bad'
end as good_or_bad
from amazon
order by total desc;


select avg(cogs) from amazon;
alter table amazon 
drop column sales_status ;






-- 12.Identify the branch that exceeded the average number of products sold';

select branch,count(quantity)  from amazon 
group by branch;

select avg(product_count) from (select branch, count(quantity) as product_count from amazon
group by branch ) as branch_count;

select branch,count(quantity) as product_sold  from amazon 
group by branch
having count(quantity)>(select avg(product_count) from (select branch, count(quantity) as product_count from amazon group by branch ) as branch_count  );



-- 13.Which product line is most frequently associated with each gender?

select product_line,gender,
count(product_line) as count from amazon 
group by product_line,gender
order by product_line;



-- 14.Calculate the average rating for each product line.;
select product_line,round(avg(rating),2) as avg_rating from amazon
group by Product_Line
order by avg(rating) desc;



-- 15.Count the sales occurrences for each time of day on every weekday.;
select dayname(date) as week_day,hour(time) as hourly_time,count(quantity) as sales_occurences from amazon 
where dayofweek(date) between 2 and 6
 group by week_day,hourly_time
order by week_day,hourly_time ;


-- 16.Identify the customer type contributing the highest revenue.;
select `Customer type`,round(sum(total),2) as highest_revenue from amazon
group by `Customer type`;

-- 17.Determine the city with the highest VAT percentage.

select city,max(tax5) as vat_percentage from amazon 
group by city 
order by vat_percentage desc;
-- 17.Determine the city with the highest VAT percentage.

select city,avg(tax5) as avg_tax_pct  from amazon
group by city order by avg_tax_pct desc;

select * from amazon;

-- 18. Identify the customer type with the highest VAT payments.

select `Customer type`,count(tax5) as highest_vat_payments from amazon
group by `Customer type`;


-- 19.What is the count of distinct customer types in the dataset?;
 select count(distinct `Customer type` ) as no_of_types_of_customers from amazon;
 select * from amazon ;

-- 20.What is the count of distinct payment methods in the dataset?

select distinct payment as types_of_payment from amazon ;

select count(distinct payment) as types_of_payment from amazon ;



-- 21. Which customer type occurs most frequently?

select `Customer type`,count(`customer type`) as customer_count from amazon
group by `customer type` 
with rollup;

select `Customer type`,count(`customer type`) as customer_count from amazon
group by `customer type` 
order by customer_count desc 
limit 1 ;


-- 22.Identify the customer type with the highest purchase frequency.;

select `customer type`,count(quantity) from amazon
group by `customer type`
order by count(quantity);

select `customer type`,count(quantity) as highest_frequency from amazon
group by `customer type`
order by count(quantity)
limit 1;


-- 23.Determine the predominant gender among customers.;

select gender,count(gender) as gender_count from amazon 
group by gender ;

select gender,count(gender) as gender_count from amazon 
group by gender 
order by gender_count desc  
limit 1;

-- 24.Examine the distribution of genders within each branch.

select gender,branch,count(gender) as gender_count from amazon
group  by gender,branch
order by branch;

-- 25.Identify the time of day when customers provide the most ratings

SELECT * FROM AMAZON;







-- 25.Identify the time of day when customers provide the most ratings

select hour(time) as hour_of_day,count(rating) as rating_count
from amazon 
group by hour_of_day
order by rating_count desc;

select time_of_day ,count(rating) as rating_count from amazon 
group by time_of_day 
order by count(rating) desc;
  
 

select time,hour(time) from amazon
group by time,hour(time);

-- 
select  branch,rating,hour(time) from amazon
order by branch ,rating desc;
 
 
 -- 27.Identify the day of the week with the highest average ratings.;
 select dayname(date) as week_day,avg(rating) as avg_rating 
 from amazon group by dayname(date)
 order by avg_rating desc;
 
 
  select dayname(date) as week_day,round(avg(rating),2) as avg_rating 
 from amazon group by dayname(date)
 order by avg_rating desc 
 limit 1;
 
-- 26.Determine the time of day with the highest customer ratings for each branch;

select branch,hour(time) as time_day,max(rating) as max_rating  from amazon group by branch,hour(time) ;

select A.branch,hour(time) as hourly_time,time_of_day  as hour_of_day,A.rating as max_rating from  amazon A
inner join  (select branch,MAX(rating) as max_rating from  amazon group by  branch) B on  A.branch = B.branch and A.rating = B.max_rating;





--  11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."

select avg(total) from amazon;

select total,
case when total> (select avg(total) from amazon) then 'good'
else 'bad'
end as good_or_bad
from amazon
order by total desc;


-- 28.Determine the day of the week with the highest average ratings for each branch.

select day_name ,round(avg(rating),2) as highest_avg_rating from amazon group by day_name  order by highest_avg_rating ;
select day_name ,round(avg(rating),2) as highest_avg_rating from amazon group by day_name 
order by highest_avg_rating
limit 1 ;










