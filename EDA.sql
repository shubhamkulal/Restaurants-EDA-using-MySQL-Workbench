-- How many restaurants are there in the dataset?
SELECT count(Restaurant) AS Restaurant_Count
FROM restaurants;

-- What is the average rating of all restaurants?
SELECT AVG(rating) AS average_rating
FROM restaurants;

-- What is the range of the average cost for two people across all restaurants?
SELECT MAX(`Average Cost for two`) AS max_cost, MIN(`Average Cost for two`) AS min_cost
FROM restaurants;

-- How many restaurants are there in each city?
SELECT city, COUNT(restaurant) AS restaurant_count
FROM restaurants
GROUP BY city;

-- Which restaurant has the highest average cost for two people?
SELECT restaurant,MAX(`Average Cost for two`) AS max_cost
FROM restaurants
GROUP BY restaurant
LIMIT 1;

-- What is the average rating for Indian cuisine?
SELECT AVG(rating) AS average_rating
FROM restaurants
WHERE Cuisines = 'Indian';

-- How many restaurants offer table booking?
SELECT COUNT(restaurant) AS table_booking
FROM restaurants
WHERE `Table booking` = 'YES';

-- How many restaurants provide online delivery?
SELECT COUNT(restaurant) AS onl_delv
FROM restaurants
WHERE `Online delivery` = 'YES';

-- What is the average rating for restaurants that offer table booking?
SELECT AVG(rating) AS avg_rating
FROM restaurants
WHERE `Table booking` = 'YES';

-- How many restaurants are currently delivering?
SELECT COUNT(*) AS curr_delivering
FROM restaurants
WHERE `delivering now` = "YES";

-- What is the average cost for two people in New Delhi?
SELECT AVG(`Average Cost for two`) AS avg_cost
FROM restaurants
WHERE City = 'New Delhi';


-- How many restaurants have a rating higher than 4?
SELECT COUNT(*) AS high_rating
FROM restaurants
WHERE rating > 4;

-- Which restaurant has the highest number of votes?
SELECT Restaurant, Votes
FROM restaurants
ORDER BY Votes DESC
LIMIT 1;

-- What is the average number of votes received by restaurants?
SELECT AVG(Votes) AS avg_num_votes
FROM restaurants;

-- Is there any relationship between the average cost for two people and the rating of a restaurant?
SELECT 
    (COUNT(*) * SUM(`Average Cost for two` * rating) - SUM(`Average Cost for two`) * SUM(rating)) / 
    SQRT((COUNT(*) * SUM(`Average Cost for two` * `Average Cost for two`) - SUM(`Average Cost for two`) * SUM(`Average Cost for two`)) * 
         (COUNT(*) * SUM(rating * rating) - SUM(rating) * SUM(rating)))
    AS correlation_coefficient
FROM restaurants;

-- Use a window function to rank restaurants based on their average cost for two people within each city:
SELECT Restaurant, City, `Average Cost for two`, RANK() OVER (PARTITION BY CITY ORDER BY `Average Cost for two`) AS cost
FROM restaurants
WHERE `Average Cost for two` > 0;

-- Create a view that displays restaurants offering both table booking and online delivery:
CREATE VIEW restaurantsofferingbookings AS
SELECT *
FROM restaurants
WHERE `Table booking` = 'YES' AND `Online delivery` = 'YES';

-- See created view
SELECT *
FROM restaurantsofferingbookings;

-- Use a CTE to calculate the average rating for each cuisine:
WITH CuisineRating AS (
    SELECT Cuisines, AVG(rating) AS average_rating
    FROM restaurants
    GROUP BY Cuisines
    ORDER BY average_rating DESC
)
SELECT *
FROM CuisineRating;

-- Use a CTE to find restaurants delivering:
WITH Restaurantdelivering AS (
	SELECT Restaurant, `delivering now`
    FROM restaurants
    WHERE `delivering now` = 'YES'
)
SELECT *
FROM Restaurantdelivering    

-- Use a window function to find the top-rated restaurant in each city:
SELECT Restaurant, City, rating
FROM (
    SELECT Restaurant, City, rating, ROW_NUMBER() OVER (PARTITION BY City ORDER BY rating DESC) AS rn
    FROM restaurants
) AS ranked_restaurants
WHERE rn = 1;

-- Use a window function to find the top-Voted restaurant in each city with there respective rating:
SELECT Restaurant, City, Votes,rating
FROM (
	SELECT Restaurant, City, Votes,rating, ROW_NUMBER() OVER (PARTITION BY CITY ORDER BY VOTES DESC) AS rs
    FROM restaurants
    ) AS max_votes
WHERE rs = 1

