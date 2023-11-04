SELECT *
FROM sqlite_master
WHERE type='table';

 
SELECT *
FROM Country;


SELECT *
FROM League
JOIN Country ON Country.id = League.country_id;


SELECT *
FROM Team
ORDER BY team_long_name
LIMIT 10;


SELECT Match.id, Country.name AS country_name, League.name AS league_name, season, stage, date, HT.team_long_name AS home_team, AT.team_long_name AS away_team, home_team_goal, away_team_goal
FROM Match
JOIN Country ON Country.id = Match.country_id
JOIN League ON League.id = Match.league_id
LEFT JOIN Team AS HT ON HT.team_api_id = Match.home_team_api_id
LEFT JOIN Team AS AT ON AT.team_api_id = Match.away_team_api_id
WHERE country_name = 'Spain'
ORDER BY date
LIMIT 10;


SELECT Country.name AS country_name, League.name AS league_name, season, count(distinct stage) AS number_of_stages, count(distinct HT.team_long_name) AS number_of_teams, avg(home_team_goal) AS avg_home_team_scores, avg(away_team_goal) AS avg_away_team_goals, avg(home_team_goal-away_team_goal) AS avg_goal_dif, avg(home_team_goal+away_team_goal) AS avg_goals, sum(home_team_goal+away_team_goal) AS total_goals
FROM Match
JOIN Country ON Country.id = Match.country_id
JOIN League ON League.id = Match.league_id
LEFT JOIN Team AS HT ON HT.team_api_id = Match.home_team_api_id
LEFT JOIN Team AS AT ON AT.team_api_id = Match.away_team_api_id
WHERE country_name IN ('Spain', 'Germany', 'France', 'Italy', 'England')
GROUP BY Country.name, League.name, season
HAVING count(distinct stage) > 10
ORDER BY Country.name, League.name, season DESC;


SELECT 
    CASE
        WHEN ROUND(height) < 165 THEN 165
        WHEN ROUND(height) > 195 THEN 195
        ELSE ROUND(height)
    END AS calc_height, 
    COUNT(height) AS distribution, 
    (avg(PA_Grouped.avg_overall_rating)) AS avg_overall_rating,
    (avg(PA_Grouped.avg_potential)) AS avg_potential,
    AVG(weight) AS avg_weight 
FROM PLAYER
LEFT JOIN (
    SELECT 
        Player_Attributes.player_api_id, 
        avg(Player_Attributes.overall_rating) AS avg_overall_rating,
        avg(Player_Attributes.potential) AS avg_potential  
    FROM Player_Attributes
    GROUP BY Player_Attributes.player_api_id
) AS PA_Grouped 
ON PLAYER.player_api_id = PA_Grouped.player_api_id
GROUP BY calc_height
ORDER BY calc_height;
