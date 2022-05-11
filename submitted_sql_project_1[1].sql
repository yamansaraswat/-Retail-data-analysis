use [DB_APR21_WEEKEND]

/********q1**********************/

select(
select count(*)
from [dbo].[Customer] ) as total_customers,
(select count(*) from [dbo].[prod_cat_info]) as total_prod_cat,
(select count(*) from [dbo].[Transactions]) as total_transactions;


/**********************************/
alter table [dbo].[Transactions]
alter column total_amt float;


select*from [dbo].[Transactions]


/*Q2*/
select count(transaction_id) as total_return from  [dbo].[Transactions]
where total_amt<0



/*********q3******/

ALTER TABLE [dbo].[Transactions]
ALTER COLUMN tran_date DATETIME;

/***************q4**************/

SELECT DATEDIFF(DAY, min(tran_date),max(tran_date))  ,
DATEDIFF(month, min(tran_date),max(tran_date)) ,
DATEDIFF(year, min(tran_date),max(tran_date))
from [dbo].[Transactions];


/*********q4*************/
SELECT DATEDIFF(DAY, MIN(CONVERT(DATE, TRAN_DATE, 105)), MAX(CONVERT(DATE, TRAN_DATE, 105))), 
DATEDIFF(MONTH, MIN(CONVERT(DATE, TRAN_DATE, 105)), MAX(CONVERT(DATE, TRAN_DATE, 105))),  
DATEDIFF(YEAR, MIN(CONVERT(DATE, TRAN_DATE, 105)), MAX(CONVERT(DATE, TRAN_DATE, 105))) 
FROM Transactions;







/***********Q5***********/


select prod_cat from [dbo].[prod_cat_info]
where prod_subcat = 'DIY';


/*********DATA ANALYSIS************/
/***********Q1***********/

SELECT top 1  store_type,  COUNT(store_type) as value_occurance
from  [dbo].[Transactions]
GROUP BY store_type
ORDER BY value_occurance DESC;

/*****Q2*****/
SELECT * FROM [dbo].[Customer]


SELECT top 2  GENDER , COUNT(GENDER) as count_gender
FROM [dbo].[Customer]
GROUP BY GENDER
order by gender desc;




/******q3******/




select top 1 city_code , count(city_code) as count_of_customers
from [dbo].[Customer]
group by city_code
order by city_code desc;



/********q4**********/




select prod_cat , count(prod_sub_cat_code) as count_of_subcategory
from [dbo].[prod_cat_info]
where prod_cat = 'books'
group by prod_cat;


/**********q5**************/

select * from [dbo].[prod_cat_info]
select * from [dbo].[Transactions]


select top 1 prod_cat_code , count(qty) as quantity
from [dbo].[Transactions]
group by prod_cat_code
order by quantity desc;



/***********q6***********/




select prod_cat,sum(total_amt) as total_revenue from [dbo].[prod_cat_info] as A  inner join [dbo].[Transactions] as B 
ON A.prod_cat_code = B.prod_cat_code and   prod_sub_cat_code=prod_subcat_code
where prod_cat in ('books' , 'electronics')
group by prod_cat;


/*********q7**********/




select customer_id,count(transaction_id) as no_of_trans from [dbo].[Customer] as A inner join [dbo].[Transactions] as B 
ON A.CUSTOMER_ID = B.cust_id
group by customer_id
having count(transaction_id)>10


/**q8*****/



select prod_cat,store_type , sum(total_amt) as total_revenue from [dbo].[prod_cat_info] as A  inner join [dbo].[Transactions] as B 
ON A.prod_cat_code = B.prod_cat_code and A.prod_sub_cat_code = b.prod_subcat_code
where prod_cat in ('clothing' , 'electronics') and store_type  like '[flagship]%'
group by prod_cat,store_type;






/**********q9***********/



select a.prod_sub_cat_code, sum(total_amt) as total_revenue from [dbo].[prod_cat_info] as A  left join  [dbo].[Transactions] as B 
ON A.prod_cat_code = B.prod_cat_code and A.prod_sub_cat_code = b.prod_subcat_code inner join [dbo].[Customer] as c on c.customer_id = b.cust_id
where prod_cat in ('electronics') and gender = 'm'
group by prod_sub_cat_code;


/**********q10**************/



select * from [dbo].[prod_cat_info]
select * from [dbo].[Transactions]
select* from [dbo].[Customer]


select top 5 prod_subcat, sum(total_amt)/(select sum(total_amt) from [dbo].[Transactions]) * 100 as percet_of_sales
from[dbo].[prod_cat_info] as A inner join [dbo].[Transactions] as B on A.prod_cat_code=B.prod_cat_code and prod_sub_cat_code=prod_subcat_code
group by prod_subcat
order by percet_of_sales desc;


/**************Q11START***************/
ALTER TABLE customer
ALTER COLUMN DOB datetime;



SELECT 
sum(total_amt) as total_revenue
from [dbo].[Customer] inner join [dbo].[Transactions] on customer_id=cust_id
where datediff(yy,dob,tran_date) between 25 and 35 AND tran_date between (select dateadd(day,-30,max(tran_date)) from [dbo].[Transactions] and (select max(tran_date) from Transactions);



/*************q11************/




/**************q12start**************/


select top 1 
prod_cat , sum(total_amt) from [dbo].[prod_cat_info] as A inner join  [dbo].[Transactions] as B on A.prod_cat_code=B.prod_cat_code and prod_sub_cat_code=prod_subcat_code
where qty<0 and tran_date between (select dateadd(month,-3,max(tran_date)) from Transactions) and (select max(tran_date) from Transactions)
group by prod_cat


/************q12end***************/


alter table [dbo].[Transactions]
alter column QTY float;

/***************Q13START**************/




SELECT ' SALES AMOUNT' AS [SALES OF MAX PRODUCTS], * FROM (
select top 1 
store_type 
from [dbo].[Transactions]
group by store_type
order by sum(total_amt)desc) AS T1
UNION ALL
SELECT ' QTY SOLD' AS [SALES OF MAX PRODUCTS], * FROM 
(SELECT TOP 1 STORE_TYPE 
FROM [dbo].[Transactions]
GROUP BY STORE_TYPE
ORDER BY SUM(QTY) DESC) AS T2

/************Q13END***************/



/*************Q14START******************/

Select prod_cat , avg(total_amt) as avg_sales
from [dbo].[prod_cat_info] as A inner join [dbo].[Transactions] AS B on A.prod_cat_code =B.prod_cat_code and prod_sub_cat_code =prod_subcat_code
group by prod_cat
having avg(total_amt) > (select avg(total_amt)from [dbo].[Transactions]);


/************q14end**************/




/***********q15start************/
select prod_subcat, avg(total_amt) as avg_revenue, sum (total_amt) as total_revenue
from [dbo].[prod_cat_info] as A inner join [dbo].[Transactions] as B on A.prod_cat_code=B.Prod_cat_code and prod_sub_cat_code =prod_subcat_code
where prod_cat IN ( select top 5 prod_cat 
from [dbo].[prod_cat_info] as A inner join [dbo].[Transactions] as B on A.prod_cat_code=B.Prod_cat_code and prod_sub_cat_code =prod_subcat_code
group by prod_cat order by sum(qty)desc) group by prod_subcat;






























































































 






















































    












































select GETDATE() as sysdate1 from [dbo].[Transactions















/*********/
SELECT CAST ( TRAN_DATE AS DATE) AS NEW_DATE FROM [dbo].[Transactions];

















