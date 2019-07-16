-- 1
select payment.amount, payment.payment_date 
from payment 
inner join customer using(customer_id) 
where payment.amount > 6 and customer.email = 'dana.hart@sakilacustomer.org';
-- 2
select language.name as language 
from film 
inner join language using(language_id) 
group by language.name;
-- 3
select concat(actor.first_name, ' ', actor.last_name) as actor_name 
from actor 
inner join film_actor using(actor_id) 
inner join film using(film_id) 
where film.title = 'Dozen Lion' 
group by actor.actor_id 
order by actor_name desc;
-- 4
select film.title, film.description 
from film 
inner join film_category using(film_id) 
inner join category using(category_id) 
where category.name = 'Horror' 
offset 3 
fetch first 5 rows only;
-- 5
select film.title, language.name as language 
from film 
inner join film_category using(film_id) 
inner join category using(category_id) 
inner join language using(language_id) 
where language.name not like 'Japanese' and category.name not like 'Horror';
-- 6
select first_name, last_name, email, country from (select 'customer' as table_name, first_name, last_name, email, address_id 
from customer 
union 
select 'staff' as table_name, first_name, last_name, email, address_id
from staff) 
as people 
inner join address using(address_id) 
inner join city using(city_id) 
inner join country using(country_id)
where (country = 'Algeria' and table_name = 'customer') or (country = 'Cameroon' and table_name='staff');
-- 7
-- Da³em varchar(length) = 3, poniewa¿ nie ma równych 4 :)
select film_id, title, 
COALESCE(release_year, 0) as release_year, 
COALESCE(length, 0) as length, special_features 
from film 
where length(cast(release_year as varchar)) = 4 
and length(cast(length as varchar)) = 3 
and cast(special_features as varchar) like '{"% %","% %"}';
-- 8
select rating, count(rating) 
from film 
group by rating 
having count(rating) between 200 and 300;
-- 9
select payment_date, 
extract(hour from payment_date) as hour, 
extract(minute from payment_date) as minute, 
round(extract(second from payment_date)) as second, 
round(extract(millisecond from payment_date)) as milisecond,
extract(day from payment_date) as day,	
extract(month from payment_date) as month,	
extract(year from payment_date) as year
from payment;
--10 
select 
concat(first_name, ' ', last_name) as staff_name,
md5(email) as email, 
upper(city) as city,
concat('[', split_part(email, '@', 1), ']-', length(md5(email))) as identifier
from staff 
inner join address using (address_id) 
inner join city using(city_id) 
where email like 'M%@%com';
-- 11
select payment.customer_id, payment.payment_id, max_table.payment_date 
from payment 
left join (select max(payment_date) as payment_date, customer_id 
from payment group by customer_id) as max_table using(customer_id, payment_date) 
order by payment.customer_id desc;
-- 12
select customer_id, round(sum(amount), 2) as amount_sum, round(avg(amount), 2) as amount_avg, 
round(coalesce(var_pop(amount), 0), 2) as amount_var 
from payment 
where payment_date < '2007-02-15' 
group by customer_id  
having sum(amount) > 5 and avg(amount) > 3 and var_pop(amount) < 5;												
-- 13
select row_number() over (), title, concat(first_name, ' ', last_name) as actor 
from film 
inner join film_actor using(film_id) 
inner join actor using(actor_id) 
left join inventory using(film_id)
where inventory_id is null offset 49 fetch first 51 rows only;
--14
select typname as enum_name, enumlabel as enum_value, rating from pg_enum inner join pg_type on pg_type.oid = pg_enum.enumtypid left join (select rating from film group by rating) as ratings on(cast(ratings.rating as varchar) = pg_enum.enumlabel) where ratings.rating is null;

												
														
														
														
														
														
														
														 