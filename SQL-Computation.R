
# Load necessary packages
library(RSQLite)
library(dplyr)

# Specify the path to the Sakila database file
db_file <- "sakila_master.db"  # Replace with your actual file path

# Connect to the SQLite database
con <- dbConnect(SQLite(), dbname = db_file)

# Ensure the connection is successful
if (is.null(con)) {
  stop("Failed to connect to the database.")
}

# SQL query to get genre and movie counts
genre_query <- "
SELECT category.name AS genre, COUNT(*) AS movie_count 
FROM film 
JOIN film_category ON film.film_id = film_category.film_id 
JOIN category ON film_category.category_id = category.category_id 
GROUP BY category.name;"

# Fetch data into a dataframe
genre_df <- dbGetQuery(con, genre_query)

# Check for errors in fetching data
if (is.null(genre_df) || nrow(genre_df) == 0) {
  stop("Failed to retrieve genre data.")
}

# Find the least common genre in R
least_common_genre <- genre_df[which.min(genre_df$movie_count), ]
print(least_common_genre)

# Disconnect from the database
dbDisconnect(con)
