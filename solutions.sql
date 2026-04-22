-- netflix project
drop table if exists netflix;
create table netflix(
 show_id varchar(6),
 type varchar(10),
 title varchar(150),
 director varchar(208),
 casts varchar(1000),
 country varchar(150),
 date_added varchar(50),
 released_year int,
 rating varchar(10),
 duration varchar(15),
 listed_in varchar(100),
 description varchar(250)
);

select * from netflix;

-- 14 business problems for netflix project

--1. Count the number of movies vs TV shows

select
type,
count (*) as total_number
from netflix
group by type;


--2. Find the most common rating for movies and TV shows

select
type,
rating,
count (*) as total_number
from netflix
group by 1,2
order by 1,3 desc;


--3. List all movies released in specific year(e.g. 2020)

select * from netflix
where
type= 'Movie'
and
released_year = 2020;

--4. Find the top 5 countries with the most content on netflix.

select
Unnest(String_To_Array(country,',')) as new_country,
count(show_id) as new_id
from netflix
group by 1
order by 2 desc
limit 5

--5. Identify the longest movie?

select * from netflix
where
	type = 'Movie'
	and
	duration = (select max(duration) from netflix)

--6. Find content added in last 5 years.

select 
*
from netflix
where
	To_Date(date_added,'Month DD, YYYY') >= current_date - interval '5 years'

--7. Find all the movies and Tv shows by director 'Rajiv Chilaka'.

select * from netflix
where director Ilike '%Rajiv Chilaka%'

--8. List all Tv shows with more than 5 seasons.

select * 
from netflix
where
type='TV Show'
and
split_part(duration,' ',1)::numeric > 5 

--9. Count the number of content items in each genre.

select
unnest(String_to_Array(listed_in,',')) as genre,
count(show_id) as total_content
from netflix
group by 1

--10. Find each year and the average numbers of content release in india on netflix. return top 5 year
--highest avg content release !

select
extract(year from to_date(date_added, 'Month DD, YYYY')) as year,
count(*) as yearly_content,
round(
count(*)::numeric/(select count(*) from netflix where country='India')::numeric*100
,2)as avg_content_per_year
from netflix
where country='India'
group by 1

--11. List all movies that are documentaries.

Select *
from netflix
where
listed_in ilike '%documentaries%'

--12. Find all the content without the director.

Select *
from netflix
where
	director is null


--13. Find how many movies actor 'salman khan' appeared in last 10 years !

select * from netflix
where
casts ilike '%salman khan%'
and
released_year> extract(year from current_date)-10

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select
unnest(string_to_array(casts, ',')) as actors,
count(*) as total_content
from netflix
where country ilike '%india%'
group by 1
order by 2 desc
limit 10