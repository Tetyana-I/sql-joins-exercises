--Join the two tables so that every column and record appears, regardless of if there is not an owner_id.
SELECT * FROM owners o LEFT JOIN vehicles v ON o.id = v.owner_id; 

--Count the number of cars for each owner. Display the owners first_name, last_name and count of vehicles.
--The first_name should be ordered in ascending order.
SELECT first_name, last_name, COUNT(*) FROM owners o JOIN vehicles v ON o.id = v.owner_id GROUP BY o.id ORDER BY o.first_name;

--Count the number of cars for each owner and display the average price for each of the cars as integers.
--Display the owners first_name, last_name, average price and count of vehicles. 
--The first_name should be ordered in descending order. 
--Only display results with more than one vehicle and an average price greater than 10000. 

SELECT o.first_name, o.last_name, ROUND(AVG(v.price)) AS average_price, COUNT(*) FROM owners o JOIN vehicles v ON o.id = v.owner_id
 GROUP BY o.id HAVING COUNT(*) > 1 AND AVG(v.price) > 10000 ORDER BY o.first_name DESC;


--PART 2
--https://sqlzoo.net/wiki/The_JOIN_operation

-- 1. Show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'
SELECT matchid, player FROM goal 
  WHERE teamid = 'GER'

-- 2. Show id, stadium, team1, team2 for just game 1012 scored by Lars Bender.
SELECT id,stadium,team1,team2
  FROM game JOIN goal ON matchid = id WHERE matchid = 1012 AND player = 'Lars Bender';

--3. Modify it to show the player, teamid, stadium and mdate for every German goal.
SELECT player, teamid, stadium, mdate
  FROM game JOIN goal ON (id=matchid) WHERE teamid = 'GER';

--4. Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'
 SELECT team1, team2, player FROM game JOIN goal ON id = matchid WHERE player LIKE 'Mario%';

--5. Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10
SELECT player, teamid, coach, gtime
  FROM goal JOIN eteam ON teamid = id
 WHERE gtime<=10;

--6. List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
 SELECT mdate, teamname FROM game JOIN eteam ON team1 = eteam.id WHERE coach = 'Fernando Santos';

--7. List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
SELECT player FROM goal JOIN game ON id = matchid WHERE stadium = 'National Stadium, Warsaw';

--8. Instead show the name of all players who scored a goal against Germany.
SELECT player FROM game JOIN goal ON matchid = id
 WHERE (teamid=team1 AND team2='GER') OR (teamid=team2 AND team1='GER')
 GROUP BY player;

--9. Show teamname and the total number of goals scored.
SELECT teamname, COUNT(*)
  FROM eteam JOIN goal ON id=teamid
 GROUP BY teamname
 ORDER BY teamname

--10. Show the stadium and the number of goals scored in each stadium.
SELECT stadium, COUNT(*)
  FROM game JOIN goal ON id=matchid
 GROUP BY stadium

--11. For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT matchid, mdate, COUNT(*)
  FROM goal JOIN game ON id = matchid
 WHERE (team1 = 'POL' OR team2 = 'POL') GROUP BY matchid, mdate;

--12. For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
 SELECT matchid, mdate, COUNT(*)
  FROM goal JOIN game ON id = matchid
 WHERE teamid = 'GER' GROUP BY matchid, mdate;

 --13. List every match with the goals scored by each team as shown. 
 --This will use "CASE WHEN" which has not been explained in any previous exercises. Sort your result by mdate, matchid, team1 and team2.
 SELECT mdate,
  team1,
  SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) score1, 
  team2,
  SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) score2 
  FROM game JOIN goal ON matchid = id 
  GROUP BY mdate, matchid, team1, team2
  ORDER BY mdate, matchid, team1, team2;


--   https://sqlzoo.net/wiki/More_JOIN_operations

--1. List the films where the yr is 1962 [Show id, title]
SELECT id, title FROM movie WHERE yr=1962;

--2. When was Citizen Kane released?
SELECT yr FROM movie WHERE title = 'Citizen Kane';

--3. List all of the Star Trek movies, include the id, title and yr
-- (all of these movies include the words Star Trek in the title). Order results by year.
SELECT id, title, yr FROM movie WHERE title LIKE '%Star Trek%' ORDER BY yr;

--4. What id number does the actor 'Glenn Close' have?
SELECT id from actor WHERE name = 'Glenn Close';

--5. What is the id of the film 'Casablanca'
SELECT id from movie WHERE title = 'Casablanca';

--6. Obtain the cast list for 'Casablanca'
SELECT name FROM actor JOIN casting ON actorid = id WHERE movieid = 27; 
-- or:
SELECT name FROM actor JOIN casting ON actorid = id WHERE movieid = (SELECT id from movie WHERE title = 'Casablanca'); 

--7. Obtain the cast list for the film 'Alien'
SELECT name FROM actor JOIN casting ON actorid = id WHERE movieid = (SELECT id from movie WHERE title = 'Alien'); 

--8. List the films in which 'Harrison Ford' has appeared
SELECT title FROM
   movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
  WHERE actor.name='Harrison Ford'

--9. List the films where 'Harrison Ford' has appeared - but not in the starring role. 
--[Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
SELECT title FROM
   movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
  WHERE actor.name='Harrison Ford' AND ord > 1;

-- 10. List the films together with the leading star for all 1962 films.
 SELECT title, name FROM casting
 JOIN actor a ON actorid = a.id
 JOIN movie m ON movieid = m.id
WHERE yr = 1962 AND ord = 1; 

--11. Which were the busiest years for 'Rock Hudson', 
-- show the year and the number of movies he made each year for any year in which he made more than 2 movies.
  SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
        JOIN actor   ON actorid=actor.id
WHERE name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2;

-- 12. List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT title, name FROM
  casting JOIN movie ON movie.id=movieid
        JOIN actor ON actorid=actor.id
  WHERE movie.id IN 
       (SELECT movieid FROM casting
                WHERE actorid =
                    (SELECT id FROM actor
                        WHERE name='Julie Andrews')) AND ord = 1;

--13. Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.
SELECT name FROM casting 
  JOIN actor ON actor.id = actorid
WHERE ord = 1 GROUP BY name HAVING SUM(ord) >= 15
ORDER BY name;

--14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT title, COUNT(actorid) FROM casting
  JOIN movie ON movie.id = movieid
  WHERE movieid IN (SELECT movie.id FROM movie WHERE yr = 1978)
GROUP BY title ORDER BY COUNT(actorid) DESC, title;

--15. List all the people who have worked with 'Art Garfunkel'.
SELECT DISTINCT name FROM casting
 JOIN actor ON actor.id = actorid
 WHERE movieid IN (SELECT movieid FROM casting 
 WHERE actorid = (SELECT actor.id FROM actor WHERE name = 'Art Garfunkel'))
 AND name != 'Art Garfunkel';