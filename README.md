# Spotify Advanced SQL Project and Query Optimization P-6
Project Category: Advanced
[Click Here to get Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

![Spotify Logo](https://github.com/najirh/najirh-Spotify-Data-Analysis-using-SQL/blob/main/spotify_logo.jpg)

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

```sql
-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
```
## Project Steps

### 1. Data Exploration
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.

### 4. Querying the Data
After the data is inserted, various SQL queries can be written to explore and analyze the data. Queries are categorized into **easy**, **medium**, and **advanced** levels to help progressively develop SQL proficiency.

#### Easy Queries
- Simple data retrieval, filtering, and basic aggregations.
  
#### Medium Queries
- More complex queries involving grouping, aggregation functions, and joins.
  
#### Advanced Queries
- Nested subqueries, window functions, CTEs, and performance optimization.

### 5. Query Optimization
In advanced stages, the focus shifts to improving query performance. Some optimization strategies include:
- **Indexing**: Adding indexes on frequently queried columns.
- **Query Execution Plan**: Using `EXPLAIN ANALYZE` to review and refine query performance.
  
---
## 60 SQL problems solved

- Q1. Retrieve the names of all tracks that have more than 1 billion streams  
- Q2. List all albums along with their respective artists  
- Q3. Get the total number of comments for tracks where licensed = TRUE  
- Q4. Find all tracks that belong to the album type single  
- Q5. Count the total number of tracks by each artist  
- Q6. Calculate the average danceability of tracks in each album  
- Q7. Find the top 5 tracks with the highest energy values  
- Q8. List all tracks along with their views and likes where official_video = TRUE  
- Q9. For each album, calculate the total views of all associated tracks  
- Q10. Retrieve the track names that have been streamed on Spotify more than YouTube  
- Q11. Find the top 3 most-viewed tracks for each artist using window functions  
- Q12. Write a query to find tracks where the liveness score is above the average  
- Q13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album  
- Q14. Find tracks where the energy-to-liveness ratio is greater than 1.2  
- Q15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions  
- Q16. Find the top 5 albums with the highest average danceability across their tracks  
- Q17. Identify the artist(s) whose tracks collectively have the longest total duration (in minutes)  
- Q18. List tracks where the energy is above the artist’s average energy (use a window function)  
- Q19. Find the track(s) with maximum tempo for each album  
- Q20. Calculate the like-to-view ratio for each track and rank tracks per artist by this ratio  
- Q21. Identify the artist with the most distinct albums in the dataset  
- Q22. Find the top 3 tracks per album with the highest valence scores (window + partition)  
- Q23. For each artist, calculate the average loudness of their tracks and rank the artists by this value  
- Q24. Find the artist(s) who have both the highest and lowest tempo track in the dataset  
- Q25. For each album, calculate the difference between the track with the highest and lowest loudness  
- Q26. Rank all tracks by views per artist, and return the top 2 per artist  
- Q27. For each album, calculate the cumulative sum of streams ordered by track duration  
- Q28. Find tracks where the valence is in the top 10% of all tracks (use NTILE())  
- Q29. Identify the top 5 most “energetic” artists based on the average energy × danceability score across all their tracks  
- Q30. Divide all tracks into quartiles (4 groups) based on their number of views. Return track name, artist, views, and quartile number  
- Q31. Split all tracks into 5 groups by likes-to-views ratio. Return track, ratio, and bucket number  
- Q32. Least popular track (least views) per artist using LAST_VALUE  
- Q33. Most viewed track per artist using FIRST_VALUE  
- Q34. Third most viewed track per artist using NTH_VALUE  
- Q35. Cumulative distribution of views per artist  
- Q36. Find overall top 10% tracks by views using CUME_DIST  
- Q37. Create a stored procedure that takes an artist_name and N as input, and returns the top N tracks by views for that artist  
- Q38. Create a stored procedure increaseLikesAndNotify that increases likes of a track by X% and prints how many rows updated  
- Q39. Create a procedure that deletes tracks older than a given release year and prints how many rows deleted  
- Q40. Create a procedure that copies top N tracks by streams into a track_archive table if not already there, and logs inserted count  
- Q41. Write a stored function that takes a track_name and returns likes-to-views ratio as numeric  
- Q42. Write a function that returns the most commented track in the database (track, artist, comments)  
- Q43. Write a function that returns top N tracks of an artist by views (input: artist_name, N)  
- Q44. Write a function to find the artist with the most total streams (output: artist, total_streams)  
- Q45. Return top track per album (album, track, max_views) using DISTINCT ON or ROW_NUMBER()  
- Q46. Write a function with input artist_name that ranks all their tracks by likes-to-views ratio using RANK() with PARTITION  
- Q47. Write a procedure album_update that increases duration_min of all tracks of a given artist by X%  
- Q48. Write a procedure that logs how many tracks of a given artist were updated when adjusting duration_min  
- Q49. Write a function to return all tracks with valence > global average valence  
- Q50. Write a query to calculate running total of streams ordered by release_date  
- Q51. Write a function that returns track(s) with maximum danceability for each artist  
- Q52. Write a query that finds the top 5 tracks with the highest like-to-comment ratio  
- Q53. Write a function to return for each album the track with the minimum liveness score  
- Q54. Write a query that finds tracks where tempo is above the 90th percentile across dataset  
- Q55. Write a function that returns top N tracks globally ranked by views (no artist filter)  
- Q56. Write a function that returns top track per album (album, track, max_views)  






## Query Optimization Technique 

To improve query performance, we carried out the following optimization process:

- **Initial Query Performance Analysis Using `EXPLAIN`**
    - We began by analyzing the performance of a query using the `EXPLAIN` function.
    - The query retrieved tracks based on the `artist` column, and the performance metrics were as follows:
        - Execution time (E.T.): **7 ms**
        - Planning time (P.T.): **0.17 ms**
    - Below is the **screenshot** of the `EXPLAIN` result before optimization:
      ![EXPLAIN Before Index](https://github.com/najirh/najirh-Spotify-Data-Analysis-using-SQL/blob/main/spotify_explain_before_index.png)

- **Index Creation on the `artist` Column**
    - To optimize the query performance, we created an index on the `artist` column. This ensures faster retrieval of rows where the artist is queried.
    - **SQL command** for creating the index:
      ```sql
      CREATE INDEX idx_artist ON spotify_tracks(artist);
      ```

- **Performance Analysis After Index Creation**
    - After creating the index, we ran the same query again and observed significant improvements in performance:
        - Execution time (E.T.): **0.153 ms**
        - Planning time (P.T.): **0.152 ms**
    - Below is the **screenshot** of the `EXPLAIN` result after index creation:
      ![EXPLAIN After Index](https://github.com/najirh/najirh-Spotify-Data-Analysis-using-SQL/blob/main/spotify_explain_after_index.png)

- **Graphical Performance Comparison**
    - A graph illustrating the comparison between the initial query execution time and the optimized query execution time after index creation.
    - **Graph view** shows the significant drop in both execution and planning times:
      ![Performance Graph](https://github.com/najirh/najirh-Spotify-Data-Analysis-using-SQL/blob/main/spotify_graphical%20view%203.png)
      ![Performance Graph](https://github.com/najirh/najirh-Spotify-Data-Analysis-using-SQL/blob/main/spotify_graphical%20view%202.png)
      ![Performance Graph](https://github.com/najirh/najirh-Spotify-Data-Analysis-using-SQL/blob/main/spotify_graphical%20view%201.png)

This optimization shows how indexing can drastically reduce query time, improving the overall performance of our database operations in the Spotify project.
---

## Technology Stack
- **Database**: PostgreSQL
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions
- **Tools**: pgAdmin 4 (or any SQL editor), PostgreSQL (via Homebrew, Docker, or direct installation)

## How to Run the Project
1. Install PostgreSQL and pgAdmin (if not already installed).
2. Set up the database schema and tables using the provided normalization structure.
3. Insert the sample data into the respective tables.
4. Execute SQL queries to solve the listed problems.
5. Explore query optimization techniques for large datasets.

---

## Next Steps
- **Visualize the Data**: Use a data visualization tool like **Tableau** or **Power BI** to create dashboards based on the query results.
- **Expand Dataset**: Add more rows to the dataset for broader analysis and scalability testing.
- **Advanced Querying**: Dive deeper into query optimization and explore the performance of SQL queries on larger datasets.

---

## Contributing
If you would like to contribute to this project, feel free to fork the repository, submit pull requests, or raise issues.

---


