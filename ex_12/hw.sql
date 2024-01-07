-- 1) Написать запрос суммы очков с группировкой и сортировкой по годам.
SELECT year_game, sum(points) FROM public.statistic s GROUP BY year_game ORDER BY year_game;
-- |year_game|sum   |
-- |---------|------|
-- |2018     |92.00 |
-- |2019     |98.00 |
-- |2020     |110.00|


-- 2) Написать cte показывающее тоже самое.
WITH cte AS (
	SELECT 
		year_game, 
		sum(points) as sum_points
	FROM public.statistic 
	GROUP BY year_game
	ORDER BY year_game)
SELECT 
	year_game, 
	sum_points
FROM cte;
-- |year_game|sum_points|
-- |---------|----------|
-- |2018     |92.00     |
-- |2019     |98.00     |
-- |2020     |110.00    |


-- 3) Используя функцию LAG вывести кол-во очков по всем игрокам за текущий код и за предыдущий.
-- Надеюсь я правильно понял суть запроса.
WITH cte AS (
	SELECT 
		 player_id, 
		 points,
		 year_game,
		 lag(points) OVER(PARTITION BY player_id ORDER BY year_game) AS points_prev_year_game
	FROM public.statistic s)
SELECT 
	player_id,
	points,
	year_game,
	points + points_prev_year_game AS sum_points_for_2_year
FROM cte;
-- |player_id|points|year_game|sum_points_for_2_year|
-- |---------|------|---------|---------------------|
-- |1        |18.00 |2018     |                     |
-- |1        |16.00 |2019     |34.00                |
-- |1        |19.00 |2020     |35.00                |
-- |2        |14.00 |2018     |                     |
-- |2        |14.00 |2019     |28.00                |
-- |2        |17.00 |2020     |31.00                |
-- |3        |30.00 |2018     |                     |
-- |3        |15.00 |2019     |45.00                |
-- |3        |18.00 |2020     |33.00                |
-- |4        |30.00 |2018     |                     |
-- |4        |28.00 |2019     |58.00                |
-- |4        |29.00 |2020     |57.00                |
-- |5        |25.00 |2019     |                     |
-- |5        |27.00 |2020     |52.00                |