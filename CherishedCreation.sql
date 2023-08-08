/*Gsearch seems to be the biggest driver of our busienss. 
Could you pull monthly trends for gsearch sessions and orders so that we can showcase the growth there?*/
SELECT
  CONCAT((DATE_PART('month', website_sessions.created_at)),'-',
  (DATE_PART('year', website_sessions.created_at)))as Month_Year,
  COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
  COUNT(DISTINCT order_id) AS orders,
  ROUND((COUNT(DISTINCT order_id)*100.0)/
    (COUNT(DISTINCT website_sessions.website_session_id)),2) AS conversion_rate
FROM website_sessions
  LEFT JOIN orders
  ON website_sessions.website_session_id = orders.website_session_id
WHERE utm_source = 'gsearch' and website_sessions.created_at BETWEEN '2014-01-01' and '2015-01-01'
GROUP BY 1;


/*Next, it would be great to see a similar trend for gsearch, but this time splitting out nonbrand
and brand campaigns separately. I am wondering if brand is picking up at all. If so, this is a good story to tell.*/
SELECT
  CONCAT((DATE_PART('month', website_sessions.created_at)),'-',
  (DATE_PART('year', website_sessions.created_at)))as Month_Year,
  COUNT(DISTINCT CASE WHEN utm_campaign='brand' THEN website_sessions.website_session_id ELSE NULL END) as brand_sessions,
  COUNT(DISTINCT CASE WHEN utm_campaign='brand' THEN orders.order_id ELSE NULL END) AS brand_orders,
   ROUND((COUNT(DISTINCT CASE WHEN utm_campaign='brand' THEN orders.order_id ELSE NULL END)*100.0)/
    (COUNT(DISTINCT CASE WHEN utm_campaign='brand' THEN website_sessions.website_session_id ELSE NULL END)),2) AS brand_cvr,
  COUNT(DISTINCT CASE WHEN utm_campaign='nonbrand' THEN website_sessions.website_session_id ELSE NULL END) as nonbrand_sessions,
  COUNT(DISTINCT CASE WHEN utm_campaign='nonbrand' THEN orders.order_id ELSE NULL END) AS nonbrand_orders,
  ROUND((COUNT(DISTINCT CASE WHEN utm_campaign='nonbrand' THEN orders.order_id ELSE NULL END)*100.0)/
    (COUNT(DISTINCT CASE WHEN utm_campaign='nonbrand' THEN website_sessions.website_session_id ELSE NULL END)),2) AS nonbrand_cvr
FROM website_sessions
  LEFT JOIN orders
  ON website_sessions.website_session_id = orders.website_session_id
WHERE utm_source = 'gsearch' and website_sessions.created_at BETWEEN '2014-01-01' and '2015-01-01'
GROUP BY 1;

/*While we're on gsearch, could you dive into nonbrand,
and pull monthly sessions and orders split by device type? 
I want to flex our analytical muscles a little and show the board we really know our traffic sources.*/
SELECT
  CONCAT((DATE_PART('month', website_sessions.created_at)),'-',
  (DATE_PART('year', website_sessions.created_at)))as Month_Year,
  COUNT(DISTINCT CASE WHEN device_type='desktop'  THEN website_sessions.website_session_id ELSE NULL END) as desktop_sessions,
  COUNT(DISTINCT CASE WHEN device_type='desktop' THEN orders.order_id ELSE NULL END) AS desktop_orders,
   ROUND((COUNT(DISTINCT CASE WHEN device_type='desktop' THEN orders.order_id ELSE NULL END)*100.0)/
    (COUNT(DISTINCT CASE WHEN device_type='desktop' THEN website_sessions.website_session_id ELSE NULL END)),2) AS desktop_cvr,
  COUNT(DISTINCT CASE WHEN device_type='mobile' THEN website_sessions.website_session_id ELSE NULL END) as mobile_sessions,
  COUNT(DISTINCT CASE WHEN device_type='mobile' THEN orders.order_id ELSE NULL END) AS mobile_orders,
  ROUND((COUNT(DISTINCT CASE WHEN device_type='mobile' THEN orders.order_id ELSE NULL END)*100.0)/
    (COUNT(DISTINCT CASE WHEN device_type='mobile' THEN website_sessions.website_session_id ELSE NULL END)),2) AS mobile_cvr
FROM website_sessions
  LEFT JOIN orders
  ON website_sessions.website_session_id = orders.website_session_id
WHERE utm_source = 'gsearch' 
AND utm_campaign='nonbrand'
and website_sessions.created_at BETWEEN '2014-01-01' and '2015-01-01'
GROUP BY 1;


/*I'm worried that one of our more pessimistic board members may be concerned
about the large % of traffic from gsearch. Can you pull monthly trends for gsearch,
alongside monthly trends for each of our other channels?*/
SELECT utm_source,utm_campaign,HTTP_referer,COUNT(*) FROM website_sessions
WHERE website_sessions.created_at BETWEEN '2012-01-01' and '2013-01-01'
GROUP BY utm_source,utm_campaign,HTTP_referer;

SELECT
  CONCAT((DATE_PART('month', website_sessions.created_at)),'-',
  (DATE_PART('year', website_sessions.created_at)))as Month_Year,COUNT(website_sessions.website_session_id) AS sessions,
  COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND http_referer IS NOT NULL THEN website_sessions.website_session_id ELSE NULL END) AS gsearch_paid_sessions,
  COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND http_referer IS NOT NULL THEN website_sessions.website_session_id ELSE NULL END) AS bsearch_paid_sessions,
  COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN website_sessions.website_session_id ELSE NULL END) AS organic_search_sessions,
  COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN website_sessions.website_session_id ELSE NULL END) AS direct_type_sessions
FROM website_sessions
  LEFT JOIN orders
    ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at BETWEEN '2014-01-01' and '2015-01-01'
GROUP BY 1;

/*I'd like to tell the story of our website performance improvements
over the course of the first 8 months. Could you pull session to order conversion rates, by month?*/
SELECT
  CONCAT((DATE_PART('month', website_sessions.created_at)),'-',
  (DATE_PART('year', website_sessions.created_at)))as Month_Year,
  COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
  COUNT(DISTINCT order_id) AS orders,
  ROUND((COUNT(DISTINCT order_id)*100.0)/
    (COUNT(DISTINCT website_sessions.website_session_id)),2) AS conversion_rate
FROM website_sessions
  LEFT JOIN orders
  ON website_sessions.website_session_id = orders.website_session_id
WHERE utm_source = 'gsearch' and website_sessions.created_at BETWEEN '2012-03-01' AND '2012-11-01'
GROUP BY 1;

/*For the gsearch lander test, please estimate the revenue that test earned us
(Hint: Look at the increase in CVR from the test (JUn 19 - Jul 28),
and use nonbrand sessions and revenue since then to calculate incremental value)*/
SELECT
  MIN(website_pageview_id) AS first_test_pv
FROM website_pageviews
WHERE pageview_url = '/lander-1';

SELECT
  website_pageviews.pageview_url AS landing_page,
  COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
  COUNT(DISTINCT orders.order_id) AS orders,
  ROUND(COUNT(DISTINCT orders.order_id)*100.0/
    COUNT(DISTINCT website_sessions.website_session_id),2) AS conversion_rate
FROM website_sessions
INNER JOIN website_pageviews
  ON website_sessions.website_session_id = website_pageviews.website_session_id
LEFT JOIN orders
  ON website_sessions.website_session_id = orders.website_session_id
WHERE website_pageviews.website_pageview_id >= 23504
  AND website_sessions.created_at BETWEEN '2012-06-19' AND '2012-07-28'
  AND website_sessions.utm_source = 'gsearch'
  AND website_sessions.utm_campaign = 'nonbrand'
  AND website_pageviews.pageview_url IN ('/home', '/lander-1')
GROUP BY website_pageviews.pageview_url;

SELECT
  MAX(website_sessions.website_session_id) AS most_recent_gsearch_nonbrand_home_pageview
FROM website_sessions
  LEFT JOIN website_pageviews
  ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE utm_source = 'gsearch'
  AND utm_campaign = 'nonbrand'
  AND pageview_url = '/home' -- Home landing page
  AND website_sessions.created_at < '2012-11-27';
  
SELECT
  COUNT(website_session_id) AS sessions_since_test
FROM website_sessions
WHERE
  created_at < '2012-11-27'
  AND website_session_id >= 17145 -- last home session
  AND utm_source = 'gsearch'
  AND utm_campaign = 'nonbrand';

/*For the landing page test you analyzed previously, 
it would be great to shows a full conversion funnel from each of the two pages to orders.
You can use the same time period you analyzed last time (Jun 19 - Jul 28).*/
SELECT
  MIN(website_pageview_id) AS first_test_pv
FROM website_pageviews
WHERE pageview_url = '/lander-1';

-- First test lander-1 pageviews is 23504

SELECT
  website_sessions.website_session_id,
  website_pageviews.pageview_url,
  website_pageviews.created_at AS pageview_created_at,
  CASE WHEN pageview_url = '/home' THEN 1 ELSE 0 END AS home_page,
  CASE WHEN pageview_url = '/lander-1' THEN 1 ELSE 0 END AS lander1_page,
  CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS product_page,
  CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
  CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
  CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
  CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
  CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM website_sessions
  LEFT JOIN website_pageviews
    ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE
  website_sessions.utm_source = 'gsearch'
  AND website_sessions.utm_campaign = 'nonbrand'
  AND website_pageview_id >= 23504
  AND website_pageviews.created_at < '2012-07-28'
  AND website_pageviews.pageview_url IN ('/home', '/lander-1', '/products', '/the-original-mr-fuzzy', '/cart', '/shipping', '/billing', '/thank-you-for-your-order')
ORDER BY
  website_sessions.website_session_id,
  website_pageviews.created_at
;

-- next we will put the previous query inside a subquery (similar to temporary tables)
-- we will group by website_session_id, and take the MAX() of each of the flags
-- this MAX() becomes a made it flag for that session, to show the session made it there


SELECT
  CASE
    WHEN saw_homepage = 1 THEN 'saw_homepage'
    WHEN saw_custom_lander = 1 THEN 'saw_custom_lander'
    ELSE 'uh oh... check logic'
    END AS segment,
  COUNT(DISTINCT website_session_id) AS sessions,
  COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS to_products,
  COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
  COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart,
  COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
  COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing,
  COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
FROM
(SELECT
  website_session_id,
  MAX(homepage) AS saw_homepage,
  MAX(custom_lander) AS saw_custom_lander,
  MAX(product_page) AS product_made_it,
  MAX(mrfuzzy_page) AS mrfuzzy_made_it,
  MAX(cart_page) AS cart_made_it,
  MAX(shipping_page) AS shipping_made_it,
  MAX(billing_page) AS billing_made_it,
  MAX(thankyou_page) AS thankyou_made_it
FROM(
SELECT
  website_sessions.website_session_id,
  website_pageviews.pageview_url,
  website_pageviews.created_at AS pageview_created_at,
  CASE WHEN pageview_url = '/home' THEN 1 ELSE 0 END AS homepage,
  CASE WHEN pageview_url = '/lander-1' THEN 1 ELSE 0 END AS custom_lander,
  CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS product_page,
  CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
  CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
  CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
  CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
  CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM website_sessions
  LEFT JOIN website_pageviews
    ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE
  website_sessions.utm_source = 'gsearch'
  AND website_sessions.utm_campaign = 'nonbrand'
  AND website_pageviews.created_at < '2012-07-28'
  AND website_pageviews.created_at > '2012-06-19'
ORDER BY
  website_sessions.website_session_id,
  website_pageviews.created_at
) AS pageview_level
GROUP BY 1) AS session_level_made_it_flags
GROUP BY 1;

-- then this is the final output part 2, click rates or conversion rates
-- click rates or conversion rates is percentage of click rate from certain page divided by total sessions

SELECT
  CASE
    WHEN saw_homepage = 1 THEN 'saw_homepage'
    WHEN saw_custom_lander = 1 THEN 'saw_custom_lander'
    ELSE 'uh oh... check logic'
    END AS segment,
  ROUND(COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END)*100 /
    COUNT(DISTINCT website_session_id), 2) AS products_click_rt,
  ROUND(COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END)*100 /
    COUNT(DISTINCT website_session_id), 2) AS mrfuzzy_click_rt,
  ROUND(COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) * 100.0 /
    COUNT(DISTINCT website_session_id), 2) AS cart_click_rt,
  ROUND(COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END)* 100.0 /
    COUNT(DISTINCT website_session_id), 2) AS shipping_click_rt,
  ROUND(COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END)* 100.0 /
    COUNT(DISTINCT website_session_id), 2) AS billing_click_rt,
  ROUND(COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) * 100.0/
    COUNT(DISTINCT website_session_id), 2) AS thankyou_click_rt
FROM
  (SELECT
  website_session_id,
  MAX(homepage) AS saw_homepage,
  MAX(custom_lander) AS saw_custom_lander,
  MAX(product_page) AS product_made_it,
  MAX(mrfuzzy_page) AS mrfuzzy_made_it,
  MAX(cart_page) AS cart_made_it,
  MAX(shipping_page) AS shipping_made_it,
  MAX(billing_page) AS billing_made_it,
  MAX(thankyou_page) AS thankyou_made_it
FROM(
SELECT
  website_sessions.website_session_id,
  website_pageviews.pageview_url,
  website_pageviews.created_at AS pageview_created_at,
  CASE WHEN pageview_url = '/home' THEN 1 ELSE 0 END AS homepage,
  CASE WHEN pageview_url = '/lander-1' THEN 1 ELSE 0 END AS custom_lander,
  CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS product_page,
  CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
  CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
  CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
  CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
  CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM website_sessions
  LEFT JOIN website_pageviews
    ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE
  website_sessions.utm_source = 'gsearch'
  AND website_sessions.utm_campaign = 'nonbrand'
  AND website_pageviews.created_at < '2012-07-28'
  AND website_pageviews.created_at > '2012-06-19'
ORDER BY
  website_sessions.website_session_id,
  website_pageviews.created_at
) AS pageview_level
GROUP BY 1) AS session_level_made_it_flags
GROUP BY 1;

/*I'd love for you to quantify the impact of our billing test, as well.
Please analyze the lift generated from the test (Sep 10 - Nov 10), 
in terms of revenue per billing page sessions, and then pull the number of billing page
sessions for the past month to understand monthly impact.*/

SELECT
  billing_version_seen,
  COUNT(DISTINCT website_session_id) AS sessions,
  ROUND(SUM(price_usd) / COUNT(DISTINCT website_session_id), 2) AS revenue_per_session
FROM
(
SELECT
  website_pageviews.website_session_id,
  website_pageviews.pageview_url AS billing_version_seen,
  orders.order_id,
  orders.price_usd
FROM website_pageviews
  LEFT JOIN orders
    ON website_pageviews.website_session_id = orders.website_session_id
WHERE
  website_pageviews.created_at BETWEEN '2012-09-10' and '2012-11-10'
  AND website_pageviews.pageview_url IN ('/billing', '/billing-2')
) AS billing_pageviews_and_order_data
GROUP BY 1;


SELECT
  COUNT(website_session_id) AS billing_sessions_past_month
FROM website_pageviews
WHERE created_at BETWEEN '2012-10-27' AND '2012-11-27'
  AND pageview_url IN ('/billing', '/billing-2');