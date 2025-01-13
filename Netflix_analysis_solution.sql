
select * from netflix;

select count (*) as total_content from netflix;

select distinct type from netflix;

select * from netflix;

-- 15 Business Problems
-- 1. Count the number of movies vs TV shows
select type,
       count (*) as total_content
 from netflix group by type;
-- 2.Find the most common rating for moives and TV shows
select type,
	rating
	from 
	(
select type,
	rating,
	count(*),
	RANK() OVER(partition by type order by count(*) desc) as ranking
	from netflix
group by 1,2) as t1
where ranking=1;

-- 3 . list all the moives released in sprcific year (eg 2020)
-- fliter 2020
-- moives

select * from netflix 
	where type = 'Movie'
	AND
    release_year = 2020;

-- 4 find the top 5 countries with most content on netflix

select 
	unnest(string_to_array(country,',')) as new_country,
	count( show_id)as total_content
	from netflix group by 1 
	order by 2 desc
	limit 5;

-- 5 identify the longext movie?

select * from 
	netflix 
	where 
	type = 'Movie'
	AND 
	duration = (select MAX(duration) from netflix);

--6 find content added in last 5 years

select *
	from netflix 
where  
	to_date(data_added,'Month DD,YYYY') >= current_date - interval '5 years';

--7 Find all the movies/TV shows by director 'Rajiv Chilaka'

 select * from netflix 
where 
director LIKE '%Rajiv Chilaka%';

--8 List all TV shows with more than 5 seasons

select * 
	from netflix
where 
	type = 'TV Show'
	and
	split_part(duration,' ',1):: numeric > 5 ;

-- 9 Count the number of content items in each genre

select UNNEST(string_to_array(listed_in,',')) as genre,
count(show_id) as total_content
from netflix
group by 1;

--10 find each year and the average numbers of content release by india on netflix, return top 5 years with highest avg content release


select 
	extract(year from to_date(data_added, 'Month DD, YYYY')) as year,
	count(*) ,
	round(
	count(*):: numeric/(select count(*) from netflix where country = 'India'):: numeric * 100 ,2)as avg_content_per_year
	from netflix 
	where country = 'India'
	group by 1;

--11 list all moives that are documentaries 
select * from netflix where listed_in ILIKE '%documentaries%';

--12 find all content without a director 

select * from netflix where director is null;

--13 find how many movies actor 'Salman Khan' appeared in last 10 years 
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

--14 find the top 10 actors who have  appeared in the highest number of produced in India

SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country ILIKE '%India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;

--15Categorize Content Based on the Presence of 'Kill' and 'Violence' 
--in description field . label content 
--	containing these keywords as 'Bad' 
--	and all other content as ' Good' , 
--	count how many items fall into each category

SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad_content'
            ELSE 'Good_content'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;



