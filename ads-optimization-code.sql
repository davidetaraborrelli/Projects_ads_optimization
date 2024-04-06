SELECT *
  FROM videoadcampaign;

-- Data cleaning: check for missing value --

SELECT date, count(*) AS date_count
  FROM videoadcampaign
 GROUP BY date
 ORDER BY date;
 
-- Data cleaning: check for inconsistent values between ad_id --

SELECT ad_id, COUNT(*) AS ad_id_count
  FROM videoadcampaign
 GROUP BY ad_id
 ORDER BY ad_id ASC;
 
-- Data cleaning: check for inconsistent values between control flow values --
 
SELECT clicked
  FROM videoadcampaign
 WHERE clicked <> 'TRUE' AND clicked <> 'FALSE';
 
SELECT signed_up
  FROM videoadcampaign
 WHERE signed_up <> 'TRUE' AND signed_up <> 'FALSE';
 
SELECT subscribed
  FROM videoadcampaign
 WHERE subscribed <> 'TRUE' AND subscribed <> 'FALSE';
 
-- Data cleaning: check for dates malformed values --

SELECT LENGTH(date), COUNT(*) AS length_count
FROM videoadcampaign
GROUP BY length(date)
ORDER BY length(date) ASC;

-- Number of Impressions --

SELECT ad_id, count(*) as impressions
  FROM videoadcampaign
 GROUP BY ad_id
 ORDER BY count(*) DESC;

-- Best performing ad (overall) --

SELECT ad_id, COUNT(subscribed) AS subscribed
  FROM videoadcampaign
 WHERE subscribed = 'TRUE'
 GROUP BY ad_id
 ORDER BY count(subscribed) DESC;
 
-- Most engaging ad (overall) --

SELECT ad_id, COUNT(clicked) AS clicks
  FROM videoadcampaign
 WHERE clicked = 'TRUE'
 GROUP BY ad_id
 ORDER BY count(clicked) DESC;
 
-- Ad that generated the most number of leads --

SELECT ad_id, COUNT(signed_up) AS sign_up
  FROM videoadcampaign
 WHERE signed_up = 'TRUE'
 GROUP BY ad_id
 ORDER BY count(signed_up) DESC;

-- Frequency rate --

SELECT ad_id, count(cast(person_id AS FLOAT)) / count(cast(ad_id AS FLOAT)) as frequency
  FROM videoadcampaign
 GROUP BY ad_id;

-- CTR for each ad --

SELECT ad_id,
       (SUM(CASE WHEN clicked = 'TRUE' THEN 1.0 ELSE 0 END) /
       COUNT(person_id)
       ) AS CTR
FROM  videoadcampaign
GROUP BY ad_id
ORDER BY CTR DESC;

-- Conversion rate for each ad --

SELECT ad_id,
       (SUM(CASE WHEN signed_up = 'TRUE' THEN 1.0 ELSE 0 END) /
       COUNT(person_id)
       ) AS conversion_rate
FROM  videoadcampaign
GROUP BY ad_id
ORDER BY conversion_rate DESC;

-- Activation Rate of Each Ad --

SELECT ad_id,
       (SUM(CASE WHEN subscribed = 'TRUE' THEN 1.0 ELSE 0 END) /
        SUM(CASE WHEN clicked = 'TRUE' THEN 1 ELSE 0 END)
       ) as activation_rate
FROM  videoadcampaign
GROUP BY ad_id
ORDER BY activation_rate DESC;

-- Impressions by day --

SELECT date, count(*) as impressions
  FROM videoadcampaign
 GROUP BY date
 ORDER BY date ASC;
 
-- Clicks by day --

SELECT date, COUNT(clicked) AS clicks
  FROM videoadcampaign
 WHERE clicked = 'TRUE'
 GROUP BY date
 ORDER BY date ASC;
 
-- Signups by day --

SELECT date, COUNT(signed_up) AS signed_up
  FROM videoadcampaign
 WHERE signed_up = 'TRUE'
 GROUP BY date
 ORDER BY date ASC;
 
-- Subscriptions by day --

SELECT date, COUNT(subscribed) AS subscribed
  FROM videoadcampaign
 WHERE subscribed = 'TRUE'
 GROUP BY date
 ORDER BY date ASC;

-- Best performing day --

SELECT date, COUNT(subscribed) AS subscribed, ad_id
  FROM videoadcampaign
 WHERE subscribed = 'TRUE'
 GROUP BY date
 ORDER BY count(subscribed) DESC;

-- AVG impressions per day (grouped by date) --

SELECT date, 1.0 * COUNT(*) / SUM(COUNT(*)) OVER () AS avg_impressions
FROM videoadcampaign 
GROUP BY date

-- CTR (grouped by date) --

SELECT date,
       AVG(CASE WHEN clicked = 'TRUE' THEN 1.0 ELSE 0 END) as click_to_impressions
FROM  videoadcampaign
GROUP BY date;

-- Investigating April 23 as 0 clicks --

SELECT date, (SUM(CASE WHEN clicked = 'TRUE' THEN 1.0 ELSE 0 END)) as clicks
 FRom videoadcampaign
 GROUP BY date;
 
-- Possible tracking malfunction --

SELECT date,
       (SUM(CASE WHEN clicked = 'TRUE' THEN 1.0 ELSE 0 END)) as clicks,
       (SUM(CASE WHEN signed_up = 'TRUE' THEN 1.0 ELSE 0 END)) as signups,
       (SUM(CASE WHEN subscribed = 'TRUE' THEN 1.0 ELSE 0 END)) as subscription
FROM videoadcampaign
WHERE date = '2021-04-23'
GROUP BY date;

-- What is the magnitude of this data missing? Margin of error --

SELECT (SUM(CASE WHEN date = '2021-04-23' THEN 1.0 ELSE 0 END)) as missed_records,
        count(*) as total,
       (SUM(CASE WHEN date = '2021-04-23' THEN 1.0 ELSE 0 END) /
       COUNT(person_id)
       ) AS missed_records_percentage
FROM videoadcampaign;

-- Conversion Rate (grouped by date) --

SELECT date, AVG(signed_up = 'TRUE') AS signup_day
FROM  videoadcampaign
GROUP BY date;

-- Activation Rate (grouped by date) --

SELECT date, AVG(subscribed = 'TRUE') AS subs_day
FROM  videoadcampaign
GROUP BY date;

-- Customers every 100 impressions --

SELECT date,
       (SUM(CASE WHEN subscribed = 'TRUE' THEN 1.0 ELSE 0 END) /
       COUNT(person_id)
       * 100) AS subs_per_100
FROM  videoadcampaign
GROUP BY date
ORDER BY date ASC;
