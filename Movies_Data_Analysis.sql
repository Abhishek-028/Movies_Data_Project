select * from MoviesData

SELECT COUNT(*) AS total_records FROM MoviesData;

 
--DUPLICATE COUNT
SELECT id, COUNT(*) AS duplicate_count
FROM MoviesData
GROUP BY id
HAVING COUNT(*) > 1;



--DESCRIPTIVE STATISTICS
SELECT AVG(runtimeMinutes) AS avg_runtime
FROM MoviesData;

SELECT AVG(averagerating) AS avg_rating
FROM MoviesData;


--GENRE ANALYSIS
SELECT genres, COUNT(*) AS genre_count
FROM MoviesData
GROUP BY genres;

--MOST POPULAR GENRE
SELECT TOP 1 genres, SUM(numvotes) AS total_votes
FROM MoviesData
GROUP BY genres
ORDER BY total_votes DESC



--BUDGET AND GROSS ANALYSIS
SELECT SUM(budget) AS total_budget, SUM(gross) AS total_gross
FROM MoviesData;

 --PROFIT FOR EACH MOVIE
 SELECT id, primaryTitle, (gross - budget) AS profit
FROM MoviesData
order by profit desc;




--RELEASE DATE ANALYSIS
SELECT YEAR(release_date) AS release_year, COUNT(*) AS movie_count
FROM MoviesData
GROUP BY YEAR(release_date)
ORDER BY release_year;

--MONTH WITH MOST MOVIES 
SELECT TOP 1 MONTH(release_date) AS release_month, COUNT(*) AS movie_count
FROM MoviesData
GROUP BY MONTH(release_date)
ORDER BY movie_count DESC




--DIRECTOR ANALYSIS
SELECT TOP 5 directors, AVG(averagerating) AS avg_rating
FROM MoviesData
GROUP BY directors
ORDER BY avg_rating DESC

--DIRECTOR WITH MOST MOVIES
SELECT TOP 5 directors, COUNT(*) AS movie_count
FROM MoviesData
GROUP BY directors
ORDER BY movie_count DESC




--TOP 5 PROFITABLE MOVIES USING CTE
WITH Profit_CTE AS (
    SELECT 
        primaryTitle , (gross - budget) AS profit
    FROM MoviesData
)
SELECT TOP 5
    primaryTitle , profit
FROM  Profit_CTE
ORDER BY  profit DESC;



--VIEW TO LIST MOVIES WITH THEIR DIRECTORS AND PROFIT
CREATE VIEW MovieProfits AS
SELECT 
    id,
    primaryTitle,
    directors,
    (gross - budget) AS profit
FROM 
    MoviesData;

SELECT *  FROM MovieProfits
WHERE profit > 1000000; 



--STORED PROCEDURE TO GET MOVIES BY GENRE AND MINIMUM RATING
CREATE PROCEDURE sp_GetMoviesByGenreAndRating
    @Genre NVARCHAR(50),
    @MinimumRating FLOAT
AS
BEGIN
    SELECT 
        primaryTitle,
        genres,
        averagerating
    FROM 
        MoviesData
    WHERE 
        genres LIKE '%' + @Genre + '%' AND averagerating >= @MinimumRating
    ORDER BY 
        averagerating DESC;
END;

--TO EXECUTE THE ABOVE STORED PROCEDURE
EXEC sp_GetMoviesByGenreAndRating @Genre = 'Drama', @MinimumRating = 8.0;




