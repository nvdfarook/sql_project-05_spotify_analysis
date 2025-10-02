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

select count(*) from spotify

-- EDA 
select count(*) from spotify

select min(duration_min) from spotify

delete from spotify 
where duration_min = 0

select distinct  album_type from spotify

select distinct  album from spotify

select distinct track from spotify

-- Bussiness Problems

-- Task 1 Retrieve the names of all tracks that have more than 1 billion streams

select *
from spotify 
where stream > 1000000000

-- Task 2 List all albums along with their respective artists.

select album, artist 
from spotify

-- Task 3 Get the total number of comments for tracks where licensed = TRUE

select sum(comments) as total_comments 
from spotify 
where licensed = TRUE

-- Task 4 Find all tracks that belong to the album type single.

select * from spotify
where album_type ='single'

-- Task 5 Count the total number of tracks by each artist.

select artist , count(*) as total_tracks
from spotify
group by 1
order by 2 desc

/* Medium Level */ 

-- Task 6 Calculate the average danceability of tracks in each album

select most_played_on from spotify

select album , avg(danceability) as avgDanc
from spotify 
group by 1
order by 2 desc

-- Task 7 Find the top 5 tracks with the highest energy values.

select track,energy 
from spotify 
order by 2 desc
limit 5

-- Task 8 List all tracks along with their views and likes where official_video = TRUE.

select track , views , likes 
from spotify
where official_video = TRUE

-- Task 9 For each album, calculate the total views of all associated tracks.

select album, sum(views) as total_views
from spotify 
group by 1
order by 2 desc

-- Task 10 Retrieve the track names that have been streamed on Spotify more than YouTube

select * from(
		select track,
		coalesce(sum(case when most_played_on = 'Youtube' then stream end),0) as streamed_on_ytb,
		coalesce(sum(case when most_played_on = 'Spotify' then stream  end),0) as streamed_on_sptfy
		from spotify 
		group by 1)t 
where streamed_on_sptfy > streamed_on_ytb
and streamed_on_ytb <> 0

-- Task 11 Find the top 3 most-viewed tracks for each artist using window functions.

with art as (

	select artist , track ,views, rank() over(partition by artist order by views desc) as most_views
	from spotify 
	
	
)

select artist, track,views,most_views
from art 
where most_views <=3



select * from spotify

-- Task 12 Write a query to find tracks where the liveness score is above the average.

select track , artist , liveness
from spotify 
where liveness > (select avg(liveness) from spotify)



-- Task 13 Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

with aaa as (

	select album , min(energy) as lowest_energy ,max(energy) as highest_energy
	from spotify 
	group by 1
)

select album, highest_energy - lowest_energy as diff
from aaa
order by 2 desc

-- Task 14  Find tracks where the energy-to-liveness ratio is greater than 1.2.

select album , track ,artist ,
(energy / nullif(liveness,0)) as energy_to_liveness_ratio
from spotify
where (energy / nullif(liveness,0)) > 1.2


-- Task 15 Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

 

select track ,album , views , likes, 
sum(likes)  over(order by views desc) as total_views
from spotify 
order by views desc


-- Task 16 Find the top 5 albums with the highest average danceability across their tracks.

select album , avg(danceability) as avgd
from spotify 
group by 1
order by 2 desc
limit 5

-- Task 17 Identify the artist(s) whose tracks collectively have the longest total duration (in minutes).

select * from spotify

select artist, sum(duration_min) as minutes
from spotify 
group by 1 
order by 2 desc
limit 5 


-- Task 18 List tracks where the energy is above the artist’s average energy (use a window function).


with en as (

select artist,energy,avg(energy) over(partition by artist)as eng
from spotify 

)

select artist,eng ,energy
from en 
where energy > eng

-- Task 19 Find the track(s) with maximum tempo for each album.


with tem as (

select artist , album , track ,
rank() over(partition by album order by tempo desc) as rn
from spotify

)

select * 
from tem
where rn = 1


-- Task 20 Calculate the like-to-view ratio for each track and rank tracks per artist by this ratio.


with tr as (

select likes, views ,track,artist,
(likes/nullif(views,0) *100) as ratio
from spotify 
	

)

select artist,track,likes, views ,ratio, rank() over(partition by artist order by ratio desc) as rnk
from tr 


-- Task 21 Identify the artist with the most distinct albums in the dataset.

select artist, count(distinct album) as albm
from spotify
group by 1
order by 2 desc
limit 1

-- Task 22 Find the top 3 tracks per album with the highest valence scores (window + partition).

with val as (
	select album , track ,artist,valence,
	rank() over(partition by album order by valence desc) as rn
	from spotify 
		
)

select album,track ,artist,valence,rn
from val
where rn <= 3


-- Task 23 For each artist, calculate the average loudness of their tracks and rank the artists by this value.

with avg_loud as (
    select artist,
           avg(loudness) as avg_loudness
    from spotify
    group by artist
)
select artist,
       avg_loudness,
       rank() over(order by avg_loudness desc) as rnk
from avg_loud
order by rnk;

-- Task 24 Find the artist(s) who have both the highest and lowest tempo track in the dataset.


 SELECT artist
FROM spotify
WHERE tempo = (SELECT MAX(tempo) FROM spotify)
   OR tempo = (SELECT MIN(tempo) FROM spotify)
GROUP BY artist
HAVING COUNT(DISTINCT tempo) = 2;

-- Task 25 For each album, calculate the difference between the track with the highest and lowest loudness.


	select album,min(loudness) as minloud,
	max(loudness) as maxloud,
	max(loudness) - min(loudness) as diff
	from spotify
	group by 1

-- Task 26 Rank all tracks by views per artist, and return the top 2 per artist.

select * from (
select album,track,artist,views,
rank() over(partition by artist order by views desc) as rn
from spotify 
)t 
where rn <=2


-- Task 27 For each album, calculate the cumulative sum of streams ordered by track duration.

select album ,artist,track ,stream,
sum(stream) over(partition by album order by duration_min ) as cum_sum
from spotify

-- Task 28 Find tracks where the valence is in the top 10% of all tracks (use NTILE()).


select  artist,track,album , valence  from (
select artist,track,album , valence ,
ntile(10) over(order by valence desc) as buc
from spotify )t
where buc =1
order by valence desc

-- Task 29 Identify the top 5 most “energetic” artists based on the average energy × danceability score across all their tracks.

with aaaa as (
	select artist,album , energy , danceability,
	energy * danceability as energetic
	from spotify

)

select artist, avg(energetic) as energetic_rate
from aaaa
group by 1 
order by 2 desc
limit 5


-- Task 30  Divide all tracks into quartiles (4 groups) based on their number of views.
--  Return track name, artist, views, and quartile number.


with buu as (

	select track , artist, views, ntile(4) over(order by views desc ) as buc
	from spotify 
)

select track , artist, views,
case
	when buc = 1 then 'top25%'
	when buc = 2 then 'top50%'
	when buc = 3 then 'top75%'
	else 'bottom20%'
end as quartile, buc
from buu

-- Task 31 Split all tracks into 5 groups by likes-to-views ratio. Return track, ratio, and bucket number.

with ct as (

	select artist,track , likes,views,
	likes/(nullif(views,0)*100) as lv_ratio,
	ntile(5) over(order by likes/(nullif(views,0)*100) desc) as buc
	from spotify
)

select artist,track , likes,views,lv_ratio,
case
	when buc = 1 then 'top20%'
	when buc = 2 then 'top40%'
	when buc = 3 then 'top60%'
	when buc = 3 then 'top80%'
	else 'bottom20%'
end as quartile, buc
from ct


-- Task 32 Least popular track (least views) per artist using lastvalue

select 
artist,track,
last_value(track) over(partition by artist order by views desc
rows between unbounded preceding and unbounded following
) as least_popular_track
from spotify

-- Task 33 most viewd track per artist using fistValue

SELECT
    artist,
    track,
    views,
    FIRST_VALUE(track) OVER (
        PARTITION BY artist
        ORDER BY views DESC
    ) AS most_viewed_track
FROM spotify;


-- Task 34 third most viewed track per artist using window function 

select artist, track ,views,
nth_value(track,3) over(partition by artist order by views desc
rows between unbounded preceding and unbounded following) as third_most_viewed
from spotify

-- Task 35 Cumulative distribution of views per artist

select artist,track ,cume_dist() over(partition by artist order by views desc)*100 as cm
from spotify
order by 3 asc

-- Task 36 find Overall top 10% tracks by views using cum_dist

select * from(
select artist,track,
round(
cume_dist() over(order by views desc)::numeric * 100,2) as cm
from spotify)t 
where cm <= 10

-- Task 37 Create a stored procedure that takes an artist_name and N as input, 
-- and returns the top N tracks by views for that artist.
-- Inputs: artist_name, N
-- Outputs: track, views, likes, comments


CREATE OR REPLACE FUNCTION top_n_tracks(
    p_artist_name TEXT,
    p_n INT
)
RETURNS TABLE(
    track TEXT,
    views INT,
    likes INT,
    comments INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT s.track::text,
           s.views::int,
           s.likes::int,
           s.comments::int
    FROM spotify s 
    WHERE artist = p_artist_name
    ORDER BY views DESC
    LIMIT p_n;
END;
$$;

SELECT * 
FROM top_n_tracks('Gorillaz', 5);


-- Task 38 Create a stored procedure named increaseLikesAndNotify that:
-- Takes track_name and increment_value as input.
-- Updates the likes column of that track by adding the increment.
-- Prints a notice before and after the update, showing the track name and the old/new number of likes.

DROP PROCEDURE IF EXISTS increaseLikesAndNotify(text, int);
create or replace PROCEDURE increaseLikesAndNotify (
p_track text 
, p_incre_value int )

language plpgsql
as $$
declare
	old_likes int;

begin
	
	
	select likes into
	old_likes
	from spotify 
	where track = p_track;

	if old_likes is null then
		raise notice 'there is no track named % ',p_track;
	else 
		update spotify 
		set likes = old_likes + p_incre_value
		where track = p_track;

		raise notice 'old likes % | increment % | new likes % ', old_likes,p_incre_value,old_likes + p_incre_value;
	end if;


end;
$$;

call increaseLikesAndNotify('Hello',200);


-- Task 39 Create a stored procedure deleteLowViewTracks that:

-- Takes an integer threshold as input.
-- Deletes all tracks from the spotify table where views are below the threshold.
-- Before deleting, prints how many tracks will be removed using RAISE NOTICE.
-- After deletion, prints confirmation.


create or replace PROCEDURE deleteLowViewTracks(
p_threshold int
)
language plpgsql
as $$
declare 
	del_count int ;
begin  
	select count(*) into 
	del_count
	from spotify
	where views < p_threshold;
	
	if del_count = 0 then 
		raise notice ' there is no track under views %',p_threshold;
	else 
		RAISE NOTICE 'Deleting % track(s) with views below %', del_count, p_threshold;
		
		delete from spotify 
		where views < p_threshold;

		RAISE NOTICE 'Deletion complete.';
	end if;

end;
$$;



call deleteLowViewTracks(10000)


-- Task 40 Q:
-- Create a stored procedure that takes an album name as input 
-- and increases the streams of all tracks in that album by 10%.
-- Input: album_name
-- Output: A message showing how many rows were updated.


create or replace procedure add_stream (
p_album text 
)
language plpgsql
as $$
declare 
	v_streams int;
	updated_count int;

begin
	select stream into
	v_streams 
	from spotify 
	where album = p_album;

	update spotify 
	set stream = v_streams *1.10                -- actually this v_stream isnt needed , just mult by stream
	where album = p_album;

	get diagnostics updated_count = row_count;

	if updated_count = 0 then 
		raise notice 'no albums available with the name %',p_album;
	else 
		raise notice 'total % rows were updated',updated_count;
	end if;
	
	

	
end;
$$;

call add_stream('Demon Days')

select stream from spotify
where album ='Demon Days'


-- Task 41 Create a stored procedure logTopTracks that:

-- Takes an integer N as input.
-- Finds the top N tracks by views from the spotify table.
-- Inserts those tracks (track name, artist, views, likes, comments) into a new table called top_tracks_log.
-- Prints how many rows were inserted with RAISE NOTICE.


create or replace procedure logTopTracks(
N int 
)
language plpgsql
as $$
declare 
	inserted_count int;

begin 
	create table if not exists toptrack (
				track text,
				artist text ,
				views bigint,
                likes bigint,
                comments bigint

	);
	
	insert into toptrack (track , artist, views, likes, comments)
	select track, artist, views, likes, comments
	from spotify 
	order by views desc
	limit N;

	get diagnostics inserted_count = row_count;

	if inserted_count = 0 then 
		raise notice 'No tracks returned,empty set';
	else 
		raise notice ' total of % rows inserted into the log table',inserted_count;
	end if;

end ;
$$;

call logTopTracks(8)

select * from toptrack


-- Task 42 Create a stored procedure increaseCommentsByPercentage that:

-- Takes artist name (p_artist) and percentage (p_percent) as input.
-- Increases the comments of all tracks by that artist by the given percentage.
-- Prints how many tracks were updated and shows highest viewed track using RAISE NOTICE.
-- Inputs:
-- p_artist (text)
-- p_percent (numeric, e.g., 10 for 10%)
-- Outputs (via console):
-- Number of tracks updated
-- For highest viewed  track: Track: <track_name> | Old Comments: <old> | New Comments: <new>

create or replace procedure increaseCommentsByPercentage(
p_artist text ,
percentage int 
)
language plpgsql 
as $$
declare 
	updated_count int ;
	v_track text ;
	old_comments bigint;

begin 
	select track,comments into 
	v_track,old_comments
	from spotify 
	where artist = p_artist
	order by views desc
	limit 1;

	
	update spotify 
	set comments = old_comments * (1+percentage::numeric/100)
	where artist = p_artist;

	get diagnostics updated_count = row_count;

	if updated_count = 0 then 
		raise notice 'No artist in the name %',p_artist;
	else 
		raise notice 'No of tracks Updated: %',updated_count ;
		raise notice 'track % | old comments % | new comments % ',v_track,old_comments,round(old_comments * (1+percentage::numeric/100),0);
	end if;
end;
$$;

call increaseCommentsByPercentage('Gorillaz',10)




-- Task 43 Create a stored procedure increaseCommentsByPercentage that:

-- Takes artist name (p_artist) and percentage (p_percent) as input.
-- Increases the comments of all tracks by that artist by the given percentage.
-- Prints how many tracks were updated and shows a sample message for each updated track using RAISE NOTICE.
-- Inputs:
-- p_artist (text)
-- p_percent (numeric, e.g., 10 for 10%)
-- Outputs (via console):
-- Number of tracks updated
-- For each track: Track: <track_name> | Old Comments: <old> | New Comments: <new>



CREATE OR REPLACE PROCEDURE increaseCommentsByPercentageLoop1(
    p_artist TEXT,
    p_percent NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
    updated_count INT := 0;
    new_comments BIGINT;
BEGIN
    FOR rec IN
        SELECT track, comments
        FROM spotify
        WHERE artist = p_artist
    LOOP
        new_comments := rec.comments * (1 + p_percent / 100);

        UPDATE spotify
        SET comments = new_comments
        WHERE track = rec.track;

        RAISE NOTICE 'Track: % | Old Comments: % | New Comments: %', rec.track, rec.comments, new_comments;

        updated_count := updated_count + 1;
    END LOOP;

    IF updated_count = 0 THEN
        RAISE NOTICE 'No tracks found for artist %', p_artist;
    ELSE
        RAISE NOTICE 'Total tracks updated: %', updated_count;
    END IF;
END;
$$;

call increaseCommentsByPercentageLoop1('Gorillaz',12)


-- Task 44 Create a stored procedure that

-- increases the likes of all tracks in a given album by a fixed number.
-- Inputs: album name, increment value
-- Output: number of tracks updated + the album name in a NOTICE

create or replace procedure increaselikes(
p_album text,
incre_value int
)
language plpgsql
as $$
declare 
	old_likes int ;
	

begin 
	select likes into
	old_likes 
	from spotify 
	where album = p_album
	order by likes desc;

	update spotify 
	set likes = old_likes + incre_value
	where album = p_album ;

	if old_likes is null then 
	raise notice 'No data';

	else
		raise notice 'album % | old-likes % | newlikes %',p_album,old_likes,old_likes+incre_value;
	end if;
end;
$$;


call increaselikes('Demon Days',1000);

select likes from spotify
where album='Demon Days'

-- Task 45 top N by Ratio
-- Create a stored procedure that takes an artist name and N as input,
-- and logs the top N tracks by likes-to-views ratio into a separate table called artist_top_ratio.


create or replace procedure topNratio(
p_artist text,
N int
)
language plpgsql
as $$
declare 
	lv_ratio int;
	updated_count int;

begin
	select likes/nullif(views,0)*100 as like_view_ratio into 
	lv_ratio
	from spotify 
	where artist = p_artist;

	
	create table if not exists artist_top_ratio(artist text ,track text,like_view_ratio bigint);

	insert into artist_top_ratio(artist,track,like_view_ratio)
	select artist,track,(likes::numeric/nullif(views,0)*100 ) as lv_ratio
	from spotify
	where artist = p_artist
	order by lv_ratio desc 
	limit N;

	get diagnostics updated_count = row_count;

	if updated_count = 0 then 
		raise notice 'No artist by the name % in data',p_artist;
	else

		RAISE NOTICE 'Top % tracks inserted for artist %', N, p_artist;
	end if ;
	
	
end;
$$;

call topNratio('Goril',10)

select * from artist_top_ratio


-- Task 46 Album Duration Update
-- Write a procedure that increases the duration of all tracks in a given album by a percentage (simulating a remastered version).
-- Print the album name and number of tracks updated.


create or replace procedure album_update(
p_artist text,
perct int
)
language plpgsql
as $$
declare
	v_duration int;
	up_cnt int;
begin	
	

		update spotify
		set duration_min = duration_min * (1+perct::numeric/100)
		where artist = p_artist;

		get diagnostics up_cnt = row_count;


		
	if up_cnt is null then 
		raise notice 'No artist by the name % in data',p_artsit;
	else 

		raise notice 'total % updated of artist %',up_cnt,p_artist;
	end if;


end;
$$;

call album_update('Coldplay',5)

select duration_min from spotify
where artist = 'Coldplay'



-- Task 47 Copy Top Tracks to Archive
-- Make a procedure that takes N as input and copies the top N tracks by streams into a new table track_archive
-- (only if not already there).
-- Print how many were inserted.

create or replace procedure toptrack1(
N int
)
language plpgsql
as $$
declare
	inserted_cnt int;
begin
	DROP TABLE IF EXISTS track_archive; 
	create table track_archive(artist text,track text,stream bigint,views bigint);

	insert into track_archive(artist ,track ,stream ,views )
	select s.artist::text ,s.track::text ,s.stream::bigint ,s.views::bigint
	from spotify s
	where not exists(
		select 1
		from track_archive t
		where s.track::text = t.track::text and s.artist::text = t.artist::text
	)
	
-- this not exists is used for preventing duplicate addition 
-- instead of this not exists - use on conflict do nothing after adding constraint - uniquq
	
	order by stream::bigint desc
	limit N;

	get diagnostics inserted_cnt = row_count;

	if inserted_cnt =0 then
		raise notice 'no tracks added';
	else 
		raise notice '% tracks copied and added to log table',inserted_cnt;
	end if;
end;
$$;



call toptrack1(10)


			
select * from track_archive

-- Task 48 Write a stored procedure that:

-- Takes an album name and an integer N as input.
-- Finds the top N tracks with the highest danceability from that album.
-- Inserts them into a table called album_top_tracks(album text, track text, danceability numeric).
-- If no tracks are found for the given album, raise a notice.


create or replace procedure update_streams (p_album text,N int)
language plpgsql
as $$
declare 
	   inserted_cnt int ;	
begin 	

	alter table album_top_tracks
	add constraint album_track unique (album,track);


	
	create table if not exists album_top_tracks(album text, track text, danceability numeric);
	insert into album_top_tracks(album,track,danceability)
	select album,track,danceability
	from spotify
	where album = p_album
	order by danceability desc
	limit N
	on conflict do nothing;

	get diagnostics inserted_cnt = row_count;

	if inserted_cnt=0 then
		raise notice 'No album found';
	else 
		raise notice 'total of % albums added ',inserted_cnt;
	end if;
	
end;
$$;

call update_streams('The Massacre',5)

select * from album_top_tracks


select * from spotify

-- Task 49 Write a stored procedure deleteLowStreamTracks that:

-- Takes two inputs:
-- p_artist (artist name)
-- p_min_streams (minimum number of streams allowed)
-- Deletes all tracks by that artist whose stream count is less than p_min_streams.
-- After deletion, display a notice with the number of deleted tracks.
-- If no tracks were deleted, raise a notice saying "No tracks found below threshold for artist <name>".


create or replace procedure deleteLowStreamTracks(p_artist text,p_min int)
language plpgsql
as $$
declare
	dlt_cnt int ;
begin 
	select count(*) into dlt_cnt
	from spotify
	where stream < p_min;

	delete from spotify
	where stream < p_min;

	get diagnostics dlt_cnt = row_count;

	if dlt_cnt = 0 then 
		raise notice 'no tracks founf below this';
	else 
		raise notice ' found and delated % tracks',dlt_cnt;
	end if ;

end;
$$;


call deleteLowStreamTracks('50 Cent',1000)

select * from spotify
where track='Candy Shop'
order by stream asc



-- Task 50 Create a stored procedure updatePopularity that:

-- Takes one input parameter: p_track (track name).
-- Updates the column popularity in the spotify table for that track using this formula:
-- popularity = ((likes + comments) / nullif(views,0)) * 100
-- After updating, display a notice with:
-- The track name
-- Old popularity
-- New popularity
-- If the track does not exist, raise a notice like:

create or replace procedure updatePopularity(p_track text)
language plpgsql
as $$
declare 
	upt_cnt int;
	old_popularity int;
begin 
	select ((likes + comments) / nullif(views,0)) * 100
	into old_popularity
	from spotify
	where track = p_track;

	get diagnostics upt_cnt = row_count;

	if upt_cnt = 0 then 
		raise notice 'no tracks found ';
	else 
		raise notice ' total of  % tracks updated',upt_cnt;
	end if ;

	

end;
$$;

call updatePopularity('Candy Shop')

#######################################################################
--stored FUNCTIONS


-- Task 51 Return total views for a given artist | Input: artist_name ,Output: total_view


create or REPLACE function total_view (p_artist text)
returns bigint
language plpgsql
as $$
declare 
	totalviews int;
begin
	select sum(views)
	into totalviews
	from spotify
	where artist = p_artist;

	if totalviews is null then 
		return 0;
	else
		return totalviews;
	end if;

end;
$$;

select total_view('Gorillaz')

-- Task 52 Return the top N tracks of an artist by views

-- Input: artist_name, N

-- Output: setof (track, views)


create or replace function topNtrackbyviews(p_artist text,N int)
returns table(track text, views bigint)
language plpgsql
as $$
begin 
	return query
	select s.track::text,s.views::bigint
	from spotify s
	where s.artist = p_artist
	order by views desc
	limit N;
end;
$$;

	
select * from topNtrackbyviews('Gorillaz',3)

-- Task 53 Return likes-to-views ratio for a given track

-- Input: track_name
-- Output: ratio (numeric)


create or replace function likestovie(p_track text)
returns numeric
language plpgsql
as $$
declare ratio numeric;
begin 
	select likes::numeric/nullif(views,0)*100 
	into ratio
	from spotify
	where track = p_track;

	if ratio = 0 then 
		raise notice 'no track by the name %',p_track;
	else 
		return ratio;
	end if;
	

end;
$$;

select * from likestovie('Feel Gooc.')

-- Task 54 Return the most commented track in the database

-- No input
-- Output: track, artist, comments

create or replace function mostcomm()
returns table(track text,artist text,comments bigint)
language plpgsql
as $$
begin
	return query
	select s.track,s.artist,s.comments
	from spotify
	order by 3 desc
	limit 1;


end;
$$;

-- Task 55 Find Artist with the Most Total Streams

-- No input
-- Output: (artist, total_streams)
-- Uses: GROUP BY + ORDER BY DESC.

CREATE OR REPLACE FUNCTION artist_with_most_streams()
RETURNS TABLE (
    artist TEXT,
    total_streams BIGINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT s.artist,
           SUM(s.views)::BIGINT AS total_streams
    FROM spotify s
    GROUP BY s.artist
    ORDER BY total_streams DESC
    LIMIT 1;
END;
$$;

-- Task 56 Return Top Track per Album

-- No input
-- Output: (album, track, max_views)
-- Uses: DISTINCT ON or ROW_NUMBER() OVER(PARTITION BY album).

create or replace function toptperalb()
returns table(album text,track text,max_views bigint)
language plpgsql
as $$
begin 
	return query
	select distinct on (album)
			s.album::text,
			s.track::text, s.views as max_views
	from spotify s 
	order by views desc;
			
end;
$$;


-----or 

CREATE OR REPLACE FUNCTION top_track_per_album()
RETURNS TABLE (
    album TEXT,
    track TEXT,
    max_views BIGINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT album, track, views AS max_views
    FROM (
        SELECT s.album,
               s.track,
               s.views,
               ROW_NUMBER() OVER (PARTITION BY s.album ORDER BY s.views DESC) AS rn
        FROM spotify s
    ) ranked
    WHERE rn = 1;
END;
$$;

-- Task 57 Partition-Based Ranking Function

-- Input: artist_name
-- Output: All tracks with rank by likes-to-views ratio.
-- Uses: RANK() or DENSE_RANK() with PARTITION.


CREATE OR REPLACE FUNCTION partbasedrank3(p_artist text)
RETURNS TABLE(
    track text,
    lv_ratio double precision,
    rn bigint
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.track::text,
        ((s.likes::double precision / NULLIF(s.views::double precision,0)) * 100) AS lv_ratio,
        RANK() OVER (
            PARTITION BY s.artist 
            ORDER BY ((s.likes::double precision / NULLIF(s.views::double precision,0)) * 100) DESC
        ) AS rn
    FROM spotify s
    WHERE s.artist = p_artist;
END;
$$;


select * from partbasedrank3('Gorillaz');

select * from spotify


