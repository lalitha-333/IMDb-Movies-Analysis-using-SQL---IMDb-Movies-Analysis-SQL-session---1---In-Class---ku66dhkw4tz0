create database movie_project;
###### SEGMENT-1########

##QUESTION-1 -	What are the different tables in the database and how are they connected to each other in the database?

SELECT * FROM DIRECTOR_MAPPING;
SELECT * FROM genre;
SELECT * FROM MOVIES;
SELECT * FROM names;
SELECT * FROM ratings;
SELECT * FROM ROLE_MAPPING;

## movies ,director_mapping,genre, names, ratings, role_mapping are the different 
tables all are except names connect by movie_id and names table connected with 
rol_mapping with the name_id##


#####QUESTION-2####  Find the total number of rows in each table of the schema.
SELECT count(*) FROM DIRECTOR_MAPPING;
SELECT  count(*)  FROM genre;
SELECT count(*) FROM MOVIES;
SELECT count(*) FROM names;
SELECT count(*) FROM ratings;
SELECT count(*) FROM ROLE_MAPPING;

## in director_mapping table  there are 3867 rows 
   in director_mapping table there are 3867 rows 
   in genre table there are 14662 rows 
   in movies table there are 7997 rows 
   in names table there are 25735 rows 
   in rating table there are 7997 rows 
   in role_mapping table there are 15615 rows. 
   


##QUESTION-3 -	Identify which columns in the movie table have null values.

select * from movies;
select  count(*) from movies where id is null;
select  count(*) from movies where title is null;
select  count(*) from movies where year is null;
select  count(*) from movies where date_published is null;
select  count(*)  from movies where  duration is null;
select  count(*) from movies where country is null;
select count(*) from movies where worlwide_gross_income is null;
select  count(*) from movies where languages is null;
select  count(*) from movies where production_company is null;


###########SEGMENT-2#########

####QUESTION --1-	Determine the total number of movies released each year and analyse the month-wise trend.

SELECt year, month (date_published) as month, count(*) as number_of_movies 
 from movies group by year, month (date_published)
order by  month(date_published);

######QUESTION -2 	Calculate the number of movies produced in the USA or India in the year 2019.

select  count(*) as movies_2019  from movies where year =2019 and  lower(country) like '%USA%' OR LOWER(COUNTRY) LIKE '%INDIA%'; 


 ## 1818 movies produced in 2019##
 
 
###########SEGMENT-3##############: Production Statistics and Genre Analysis3#######

##QUESTION-1  :-	Retrieve the unique list of genres present in the dataset.

SELECT distinct GENRE FROM GENRE;
The diffenrent genres are
thriller, fantacy, drama, comedy, horror,romance,family,adventure, sci_fi, 
action,mystry,crime  and in the catogory of others 

##QUESTION-2 - -	Identify the genre with the highest number of movies produced overall.

SELECT * FROM MOVIES;
select genre,count(movie_id) from genre
group by genre order by count(movie_id) desc limit 1;

there is genre called Drama, in this genre there are highest no of movies produced.

##QUESTION - 3 -	Determine the count of movies that belong to only one genre.

select count(*)  from
(SELECT  Movie_id, count(genre) as no_of_genre  from genre group by movie_id 
having no_of_genre=1) t;
 
## there are 3289 movies belonging to only one genre 
 
 
##QUESTION--4  -	-	Calculate the average duration of movies in each genre.

SELECT  genre, AVG(duration) as avg_duration from movies m
right join genre g on m.id=g.movie_id 
group by genre;

## avge_duration  in between 92 to 112 ##

##QUESTION--5 -	Find the rank of the 'thriller' genre among all genres in terms of the number of movies produced.

select genre,count(movie_id) as movie_count,
RANK() over (order by count(movie_id))
from genre 
group by genre order by movie_count 

***rank of thriller genre is 11**


SET SQL_SAFE_UPDATES = 0;
update movies set id = null where id = '' ;

update movies set title = null where title = '' ;

update movies set year = null where year = '' ;


update movies set duration = null where duration = '' ;

update movies set country = null where country = '' ;

update movies set worlwide_gross_income = null where worlwide_gross_income = '' ;

update movies set languages = null where languages = '' ;

update movies set production_company = null where production_company = '' ;

update genre set movie_id = null where movie_id = '' ;

update genre set genre = null where genre = '' ;

update director_mapping set movie_id = null where movie_id = '' ;

update director_mapping set name_id = null where name_id = '' ;

update role_mapping set movie_id = null where movie_id = '' ;

update role_mapping set name_id = null where name_id = '' ;

update role_mapping set category = null where category = '' ;

update names set id = null where id = '' ;

update names set name = null where name = '' ;

update names set height = null where height = '' ;

update names set date_of_birth = null where date_of_birth = '' ;

update names set known_for_movies = null where known_for_movies = '' ;

update ratings set movie_id = null where movie_id = '' ;

update ratings set avg_rating = null where avg_rating = '' ;

update ratings set total_votes = null where total_votes = '' ;

update ratings set median_rating = null where median_rating = '' ;


#################SWGMENT-4 ###################

##QUESTION -1 


SELect * from ratings;

select max(avg_rating) as max_rating ,min(avg_rating) as min_rating from ratings;
select max(total_votes) as max_votes ,min(total_votes) as min_votes from ratings;
select max(median_rating) as max_median_rating ,min(median_rating) as min_median_rating from ratings;
 
 
**                max          min
**   avg_rating    10           1
**   total_votes   725138       100
**   median_rating  10           1


####QUESTION-2  -	Identify the top 10 movies based on average rating.

SELECT m.id,title from movies m
right join ratings r on m.id = r.movie_id
order by avg_rating desc limit 10;

****love in Kilnerryy is top movie**

######QUESTION-3 -	Summarise the ratings table based on movie counts by median ratings.

select median_rating, count(movie_id) as movie_count

from ratings

group by median_rating

order by median_rating;

** only 345 movies got median rating 10 and 1 movie got 9 rating 
almost 94 movies got 1 rating***

###QUESTION-4  -	Identify the production house that has produced the most number of hit movies (average rating > 8).
select * from 
(SELECT production_company, count(id) as total_no_movies,  
rank() over(order by count(id) desc) AS cnt from movies m
left join ratingS r on m.id=r.movie_id 
where avg_rating > 8 and production_company is not null
group by production_company order by total_no_movies desc) t
where cnt =1;

##**dream in warrior Picture and National Theatre Live are top most production housses
###question 5  -	Determine the number of movies released in each genre during March 2017 in the USA with more than 1,000 votes.

select genre,count(g.movie_id) as movie_count from genre g 
inner join movies m on m.id = g.movie_id 
inner join ratings r  on r.movie_id =g.movie_id
where year =2017 and month(date_published) = 3
and lower(country) like '%usa%' and total_votes >1000 group by genre  order by movie_count desc;

#**in 2017 In USA for more than 1000 votes drama genre has 24 movies released which is the 
  ##hishest one 

##QUESTION 6-	Retrieve movies of each genre starting with the word 'The' and having an average rating > 8.

SELECT genre,title, avg_rating  from movies m
INNER join genre g on g.movie_id = m.id
inner join ratings r on r.movie_id =m.id
where avg_rating >8 and lower(title) like 'The%';

 #**  there are 15 movies in who have average_rating more than 8 in different genres.
 
################SEGMENT--5###############

###QUESTION -1 -	Identify the columns in the names table that have null values.
select count(*) as id_null from names where id is null;
select count(*)as name_null from names where name is null;
select count(*)as height_null from names where height is null;
select count(*) as date_of_birth_null from names where date_of-birth is null;
select count(* ) as known_for_movies from names where known_for_movies is null;


#####QUESTION_-2 -	Determine  top three directors in the top three genres with movies having an average rating > 8.

with top_genres as
(select genre from genre g  
inner join ratings r on r.movie_id = g.movie_id 
where avg_rating >8  group by genre order by count( g.movie_id) desc limit 3)

select n.name as top_director, count(n.id) as  movie_count
from names n 
inner join role_mapping rm on rm.namE_ID =n.id
inner join director_mapping dm on rm.movie_id=dm.movie_id
inner join movies m on m.id = dm.movie_id 
inner join genre g on g.movie_id = m.id 
inner join ratings r on r.movie_id = m.id
where avg_rating >8
 group by 1 order by movie_count desc  limit 3;
 
 ##** Chiris Hemsworth, Robert Downey , CHiris evans are the top three directors 
          in top genres with movie count 12 #  
 
 ###QUESTION 3 -	Find the top two actors whose movies have a median rating >= 8
 
select  n.name as top_actor,count(m.id) as movie_count  from  names n 
inner join role_mapping rm on rm.name_id = n.id 
inner join movies m on  m.id=rm.movie_id
inner join ratings r on r.movie_id=m.id
where r.median_rating >= 8
and  lower(category) like '%actor%'
group by top_actor order by movie_count desc limit 2;

#** Mommootty and Mohanlal are the top two actors with mdedian_ rating more than 8##


#####question-4   -	Identify the top three production houses based on the number of votes received by their movies

select production_company as top_production, sum(total_votes) as votes from movies m
 inner join ratings r on r.movie_id = m.id
 where production_company is not null
 group by 1 order by votes desc limit 3;
 
 ##** Marvel Studios , Twentieth Century Fox 
 and Warner Bros are the top three production houses###
 
 ##### quedtion--5  ---	Rank actors based on their average ratings in Indian movies released in India.
 
 with  actr_avg_rating as 
( SELECT 
n.name as actor_name, 
sum(r.total_votes) as total_votes,
count(m.id) as movie_count,
round(sum(r.avg_rating * r.total_votes) /
       sum(r.total_votes),2) 
       as actor_avg_rating 
       from names n 
       inner join role_mapping rm on n.id = rm.name_id
       inner join movies m on m.id =rm.movie_id
       inner join ratings r on r.movie_id = m.id
       where category = 'actor' and  lower(country) like '%india%'
       group by actor_name )
 
 select * ,rank() over ( order by actor_avg_rating desc, total_votes desc)as actor_rank
  from actr_avg_rating
  where movie_count >= 5
 limit 1;
 
 ****vijay Sethupathi has ranked number one********
 
###question 6----	Identify the top five actresses in Hindi movies released in India based on their average ratings


 with  actr_avg_rating as 
( SELECT 
n.name as actress_name, 
sum(r.total_votes) as total_votes,
count(m.id) as movie_count,
round(sum(r.avg_rating * r.total_votes) /
       sum(r.total_votes),2) 
       as actress_avg_rating 
       from names n 
       inner join role_mapping rm on n.id = rm.name_id
       inner join movies m on m.id =rm.movie_id
       inner join ratings r on r.movie_id = m.id
       where category = 'actress' 
       and lower(languages) like '%hindi%'
       group by actress_name )
 
 select * ,rank() over ( order by actress_avg_rating desc, total_votes desc)as actor_rank
  from actr_avg_rating
  where movie_count >= 3;
  
  ****taapsee pannu , kriti sanon, divya dutta, Sradda Kapoor,
  Krithi karbanda ***
  
  #########SEGMENT--6 -##########

##QUESTION--1-- -	Classify thriller movies based on average ratings into different categories.
 
 SELECT title as movie_name, avg_rating as rating,
 case
 when avg_rating > 8 then 'Super_hit'
 when avg_rating  between 7 and 8 then  'hit'
 when avg_rating between 5 and 7 then 'one_time_watch'
 else 'flop'
 end as genre_cetagory
 FROM movies m
 inner join genre g on m.id = g.movie_id
 inner join ratings r on r.movie_id = m.id 
 where lower(genre) like '%thriller%' and total_votes >25000
 order by rating desc;
 
 ##** thiriller movies are classified into four catagories superhit,hit , one_time watch
  and flop##**
 
 ####QUESTION--2  -	analyse the genre-wise running total and moving average of the average movie duration.
 
 with genre_summary as 
 (select genre, avg(duration) as avg_duration from genre g
 left join movies m on g.movie_id = m.id
 group by genre)
 
 select genre, avg_duration,
 sum(avg_duration) over (order by avg_duration desc ) as running_total,
 avg(avg_duration) over (order by avg_duration desc) as moving_average
 from genre_summary;
 
 
### QUESTION ---3 -	Identify the five highest-grossing movies of each year that belong to the top three genres
 
 with top_genre as 
 (select genre, count(m.id) as movie_count 
 from genre g left join movies m on g.movie_id =m.id
 group by  genre 
 order by movie_count desc limit 3)
 
 select * from 
 ( select genre,year ,m.title as movie_name,
 worlwide_gross_income,
 rank() over ( partition by genre ,year order by 
 cast(replace(trim(worlwide_gross_income),"$"," ")as unsigned)
 desc) as movie_rank from 
 movies m inner join genre g on g.movie_id =m.id
 where g.genre in ( select genre from top_genre)) t 
 where movie_rank <=5;
  

 ####QUESTION  4 -	Determine the top two production houses that have produced the highest number of hits among multilingual movies
 
 select production_company from
 (
 select production_company, count(m.id) as movie_count,
 row_number() over ( order by count(m.id) desc ) as prd_rnk
 from movies m 
 inner join ratings r on r.movie_id = m.id
 where median_rating >8 and 
 production_company is  not null and
 lower( languages) like '%,%' 
 group by 1 ) t
 where prd_rnk <=2;
 
 ##** Star cinema and Ave Fenix Pictures are top production houses give 
 ### more number of hits ###
 
 
 
 
 #####QUESTION 5-- -	Identify the top three actresses based on the number of Super Hit movies (average rating > 8) in the drama genre.
 
 with  actr_avg_rating as 
( SELECT 
n.name as actress_name, 
sum(r.total_votes) as total_votes,
count(m.id) as movie_count,
round(sum(r.avg_rating * r.total_votes) /
       sum(r.total_votes),2) 
       as actress_avg_rating 
       from names n 
       inner join role_mapping rm on n.id = rm.name_id
       inner join movies m on m.id =rm.movie_id
       inner join ratings r on r.movie_id = m.id
       inner join genre g on g.movie_id = m.id
       where category = 'actress' and  lower(genre) like '%drama%'
       and avg_rating >8 
       group by actress_name )
       
       select * , row_number () over ( order by actress_avg_rating desc,
       total_votes desc) as actress_rank from actr_avg_rating limit 3;
  
 ###***SANGEETHA Bhat , fatmire sahiti ,
      ###Adriyana matoshi are top three actresses***

######QUESTION - 5 -	Retrieve details for the top nine directors based on the number of movies, including average inter-movie duration, ratings, and more.

with top_directors as 
( select director_id,director_name
from (select n.id as director_id ,n.name as director_name,
count(m.id)as movie_count,
row_number() over (order by count(m.id)desc ) as director_rank
from names n
inner join director_mapping d on id=d.name_id
inner join movies m on m.id =  d.movie_id
group by 1,2) t
where director_rank <=9),


 movie_summary as 
(select n.id as director_id, n.name as director_name,
m.id as movie_id,
r.avg_rating ,
r.total_votes,
m.duration,
m.date_published,
lead(date_published) over (partition by n.id order by m.date_published) as next_date_published,
datediff(lead(date_published) over (partition by n.id order by m.date_published),
m.date_published) as INTER_MOVIE_DAYS
from  names n
inner join director_mapping d on n.id = d.name_id 
inner join movies m on m.id = d.movie_id 
inner join ratings r on r.movie_id = m.id
where n.id in (select director_id from top_directors) 
)


select 
director_id , 
director_name ,
count(distinct movie_id) as number_of_movies,
avg(inter_movie_days) as avg_inter_movie_days,
round(sum(avg_rating*total_votes)/sum(total_votes),2)
AS directors_avg_rating,
sum(total_votes) as total_votes,
max(avg_rating) as max_rating,
sum(duration)as total_movie_duration from
movie_summary
group by 1,2 
order by number_of_movies desc,
directors_avg_rating desc ;

###**A.L vijay is top director ****

########SEGMENT --7##########
#### QUESTION -	Based on the analysis, provide recommendations for the types of content Bolly movies should focus on producing.

AS THE PER MY ANALYSIS I CAME ACROSS A.L. VIJAY IS THE TOP DIRECTOR AS PER 
PUBLIC RATING  IF THE BOLLY MOVIES WANTS HITS BY PUBLIC PULSE THEY SHOULD 
AQUIRE KNOWLEDGE ON CONTENT ON  VIJAY MOVIES.Chiris Hemsworth, Robert Downey ,
 CHiris evans are the top three directors in top genres with movie count 12 
 
#>>COMINING TO PRODUCTION HOUSES Star cinema and Ave Fenix Pictures 
GAVE MORE HITS CAMPARE TO  THE OTHERS AS THEY ARE TOP PRODUCTION HOUSES 
IN MULTILANGAL SO THAT THEY WILL INTERSSTED IN PRODUCING  MORE
BOLLY MOVIES.

#>>IF BOLLY MOVIES COME UP WITH ACTION ,DRAMA,
 COMEDY GENRE  IT WILL DEFINITELY ENTERTAIN AS THEY 
 ARE TOP GENRES PEOPLE ARE MORE INTERESTED IN THESE
 GENRES COMPARATIVELY BEFORE 

 #>> IN HINDI MOVIES TOP ACTRESSES WHO HITS OR
 ENTERTAIN PEOPLE BY THEIR PERFORMANCE ARE taapsee pannu , kriti sanon, divya dutta, Sradda Kapoor,
  Krithi karbanda. WITH ANY OF THOSE ACTRESSES WILL HIT SOON THE INDUSTRY.
  
  ##>>> IN INDIAN MOVIES VIJAY SEYHUPAYHI RANKED AS NUMBER ONE 
       AND ALSO MOHAN LAL AND MAMMOTTY ARE ALSO TOP ACTORS BASED ON THEIR
       MEDIAN RATINGS . WE CAN CONSIDER THESE ACTORS WILL BOX OFFICES IN BOLLY MOVIES
       
#####>><<**FINALLY I CAME INTO MY CONCLUSION
       COBMINATION OF ABOVE ACTORS AND ACTRESESS AND DIRECTORS AND PRODUCTION HOUSES IN 
       TOP GENRES WILL ENTERTAIN MORE 
A

 



