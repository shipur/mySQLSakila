/*************Homework Assignment***********/

use sakila;
/*1a. Display the first and last names of all actors from the table `actor`.*/
SELECT first_name, last_name FROM actor;

/*1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.*/
SELECT UPPER(CONCAT(first_name,' ', last_name)) AS 'Actor Name' FROM actor;

/*2a. You need to find the ID number, first name, and last name of an actor,
 of whom you know only the first name, "Joe." What is one query would you use to obtain this information?*/
 SELECT actor_id, first_name, last_name FROM actor where first_name = "Joe";
 
 /*2b. Find all actors whose last name contain the letters `GEN`: */
 SELECT * FROM actor where last_name LIKE "%GEN%";
 
 /*2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:*/
 SELECT last_name, first_name FROM actor where last_name LIKE "%LI%";
 
 /*2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:*/
 SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
  -- SELECT * FROM country;
 /*3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.*/
ALTER TABLE actor
    ADD COLUMN middle_name VARCHAR(25) AFTER first_name;
SELECT * FROM actor;

/*3b. You realize that some of these actors have tremendously long last names. 
Change the data type of the `middle_name` column to `blobs`. */
ALTER TABLE actor
MODIFY middle_name  blob; 

/* 3c.Now delete the `middle_name` column.  DO THIS-----*/ 

/*4a. List the last names of actors, as well as how many actors have that last name. */
SELECT last_name, COUNT(last_name) AS 'Number of Actors' FROM actor GROUP BY  last_name;
SELECT * FROM actor;

/*4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors  */
SELECT last_name, COUNT(last_name) AS 'Number of Actors' FROM actor GROUP BY  last_name HAVING COUNT(last_name) >= 2;

/*Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, 
the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.*/
UPDATE actor set first_name = "HARPO" WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";

/*In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. 
Otherwise, change the first name to `MUCHO GROUCHO`
BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! 
(Hint: update the record using a unique identifier.)
*/
UPDATE actor 
    SET first_name =
		CASE
			WHEN first_name = 'HARPO' THEN  'GROUCHO'
			ELSE "MUCHO GROUCHO"
		END
	WHERE actor_id = 172;

/*5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it? */
SHOW CREATE TABLE address;

/*6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`*/
SELECT first_name, last_name, address
FROM staff AS s
JOIN address AS a
ON (s.address_id = a.address_id);

/*6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.*/
SELECT * FROM staff;
SELECT * FROM payment;

SELECT p.staff_id, s.first_name, s.last_name, COUNT(p.staff_id) AS 'NUMBER RUNG'
FROM payment AS p
JOIN staff AS s
ON (s.staff_id = p.staff_id)
GROUP BY p.staff_id;

/*6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join. ????????*/
SELECT * FROM film_actor WHERE film_id=1;
SELECT * FROM film;


SELECT f.title, COUNT(fa.actor_id) AS 'Number Actors'
FROM film_actor AS fa
INNER JOIN film AS f
ON (f.film_id = fa.film_id)
GROUP BY title;

/*6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?*/
SELECT * FROM inventory;
SELECT * FROM film;

SELECT COUNT(i.film_id) AS 'Copies'
FROM inventory AS i
JOIN film AS f
ON(i.film_id = f.film_id)
WHERE f.title = 'Hunchback Impossible'
GROUP BY i.film_id ;

/*6e. Using the tables `payment` and `customer` and the `JOIN` command, 
 list the total paid by each customer. List the customers alphabetically by last name */
 SELECT * FROM payment;
SELECT * FROM customer;
 
 SELECT c.first_name, c.last_name, SUM(p.amount)
 FROM payment AS p
 JOIN customer AS c
 ON(p.customer_id = c.customer_id)
 GROUP BY p.customer_id
 ORDER BY c.last_name;
 
 /*7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
 As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
 Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.*/
 SELECT * FROM film;
 SELECT * FROM language;
 
 /*Using Join-----
 SELECT f.title, l.name
 FROM film AS f
 JOIN language AS l
 ON(f.language_id = l.language_id)
 WHERE l.name = 'English' AND f.title LIKE 'K%' OR f.title LIKE  'Q%'; */
 
 SELECT title FROM film
 WHERE ((title LIKE 'K%' OR title LIKE  'Q%')  AND language_id IN
	(SELECT language_id FROM language
		WHERE name = 'English'));
        
 /*7b. Use subqueries to display all actors who appear in the film `Alone Trip`.*/
 SELECT * FROM film_actor;
SELECT * FROM film;

SELECT actor_id 
FROM film_actor
WHERE film_id IN 
	(SELECT film_id FROM film WHERE title = 'Alone Trip');
    
/* Using Join----
SELECT fa.actor_id 
FROM film_actor AS fa
JOIN film AS f
ON ( fa.film_id = f.film_id)
WHERE f.title = 'Alone Trip'; */

/*7c. You want to run an email marketing campaign in Canada, 
for which you will need the names and email addresses of all Canadian customers. 
Use joins to retrieve this information.*/
SELECT * FROM customer; 
SELECT * FROM address;
SELECT * FROM city;
SELECT * FROM country;

SELECT cust.first_name, cust.last_name, cust.email, ctry.country
FROM customer AS cust
JOIN address AS a
ON ( cust.address_id = a.address_id)
JOIN city AS ci
ON (a.city_id = ci.city_id)
JOIN country AS ctry
ON(ci.country_id = ctry.country_id)
WHERE ctry.country = 'Canada';

/*7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
Identify all movies categorized as family films.*/
SELECT * FROM film_category;
SELECT * FROM film;
SELECT * FROM category;

SELECT f.title, c.name AS 'Category Name'  FROM film AS f
JOIN film_category AS fc
ON(f.film_id = fc.film_id)
JOIN category AS c
ON(fc.category_id = c.category_id)
WHERE c.name = 'Family';

/*7e. Display the most frequently rented movies in descending order.*/
SELECT * FROM film;
SELECT * FROM rental;

SELECT title, rental_duration
FROM film ORDER BY rental_duration DESC;

/*7f. Write a query to display how much business, in dollars, each store brought in*/
SELECT * FROM store;
SELECT * FROM inventory;
SELECT * FROM rental;
SELECT * FROM payment;

SELECT s.store_id, SUM(p.amount) AS 'Amount'  FROM store as s
JOIN inventory AS i
ON(s.store_id = i.store_id)
JOIN rental AS r
ON(i.inventory_id = r.inventory_id)
JOIN payment AS p
ON(r.rental_id = p.rental_id)
GROUP BY s.store_id;

/*7g. Write a query to display for each store its store ID, city, and country.*/

SELECT s.store_id, ci.city, ctry.country
FROM store AS s
JOIN address AS a
ON(s.address_id = a.address_id)
JOIN city AS ci
ON(a.city_id = ci.city_id)
JOIN country AS ctry
ON(ci.country_id = ctry.country_id);

/** 7h. List the top five genres in gross revenue in descending order. 
(**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.) */
SELECT * FROM film_category;
SELECT * FROM category;
SELECT * FROM inventory;
SELECT * FROM rental;
SELECT * FROM payment;

SELECT c.name, SUM(p.amount) AS 'Total Amount' FROM category AS c
JOIN film_category AS fc
ON(c.category_id = fc.category_id)
JOIN inventory AS i
ON(i.film_id = fc.film_id)
JOIN rental AS r
ON(i.inventory_id = r.inventory_id)
JOIN payment AS p
ON(r.rental_id = p.rental_id)
GROUP BY c.name
ORDER BY SUM(p.amount)  DESC LIMIT 5;

/*8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
Use the solution from the problem above to create a view.*/

CREATE VIEW `top_five_genres` AS 
SELECT c.name, SUM(p.amount) AS 'Total Amount' FROM category AS c
JOIN film_category AS fc
ON(c.category_id = fc.category_id)
JOIN inventory AS i
ON(i.film_id = fc.film_id)
JOIN rental AS r
ON(i.inventory_id = r.inventory_id)
JOIN payment AS p
ON(r.rental_id = p.rental_id)
GROUP BY c.name
ORDER BY SUM(p.amount) DESC LIMIT 5;

/*8b. How would you display the view that you created in 8a? */

SELECT * FROM top_five_genres;

/* 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it. */
DROP VIEW  top_five_genres;

/*************************************************/




