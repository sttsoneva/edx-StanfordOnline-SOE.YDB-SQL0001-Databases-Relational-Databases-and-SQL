
/*SQL Movie-Rating Query Exercises

Movie ( mID, title, year, director )
English: There is a movie with ID number mID, a title, a release year, and a director.

Reviewer ( rID, name )
English: The reviewer with ID number rID has a certain name.

Rating ( rID, mID, stars, ratingDate )
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate.*/


/*Task 1: Find the titles of all movies directed by Steven Spielberg.*/

select title from Movie
where director like 'Steven Spielberg';

/*Task 2: Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.*/

select distinct year
from Movie, Rating
where Movie.mID = Rating.mID
and (stars = 4 or stars = 5)
order by year asc;

/*Task 3: Find the titles of all movies that have no ratings.*/

select title
from Movie
where not exists (select * from Rating
where Movie.mID = Rating.mID);

/*Task 4: Some reviewers did not provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.*/

select Reviewer.name
from Reviewer, Rating
where Reviewer.rID = Rating.rID and 
ratingDate is null;

/*Task 5: Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.*/

select Re.name as 'Reviwer name', M.title as 'Movie Title', Ra.stars as 'Stars', Ra.ratingDate 
from Movie as M, Reviewer as Re, Rating as Ra
where M.mID = Ra.mID and Ra.rID = Re.rID
order by Re.name, M.title, Ra.stars;

/*Task 6: For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.*/

select Reviewer.name, Movie.title
from Reviewer, Movie, Rating as R1, Rating as R2
where Movie.mID = R1.mID and Reviewer.rID = R1.rID and R1.rID = R2.rID and R1.mID = R2.mID and R1.ratingDate < R2;

/*Task 7: For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.*/

select title, max(stars) from Movie, Rating
where Movie.mID = Rating.mID
group by (title);

/*Task 8: For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.*/

select title, (max(stars) - min(stars))
from Movie join Rating 
on Movie.mID = Rating.mID
group by Movie.title
order by (max(stars) - min(stars)) desc, title asc;

/*Task 9: Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
(Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. 
Don't just calculate the overall average rating before and after 1980.)*/

select avg(Before) - avg(After)
from (
    select avg(stars) as Before from Movie, Rating
    where Movie.mID = Rating.mID and Movie.year < 1980
    group by Movie.mID
    ),
    (select avg(stars) as After from Movie, Rating
    where Movie.mID = Rating.mID and Movie.year > 1980
    group by Movie.mID
    );