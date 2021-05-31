library(httr)
library(jsonlite)
library(tidyverse)

# sample date for query
date_req <- "2021-04-18"

# urls for accessing
sites_url <- "https://api.data.tii.ie/traffic//v1/sites/available"
token_url <- "https://api.data.tii.ie/traffic/v1/token"

# store token details as character strings
token_access <- "token-access-key-here"
token_secret <- "token-secret-key-here"

# POST request for token
token <- content(
    POST(
        token_url,
        body = list( 'accessKey'= token_access, 
                     'secretKey'= token_secret, 
                     'content-type' = 'application/json;',
                     'transfer-encoding' = 'chunked'),
        encode = "json"
    )
)


# Get a list of all sites -------------------------------------------------

sites <- content(
    GET(sites_url, add_headers(Authorization = paste("Bearer", token)))
)

# Get daily data and convert to dataframe ---------------------------------

daily_traffic_url <- paste0("https://api.data.tii.ie/traffic/v1/aggregations/", 
                            date_req, 
                            "/dailytotalsbysite")

daily_traffic <- content(
    GET(daily_traffic_url, add_headers(Authorization = paste("Bearer", token)))
)

daily_traffic_df <- map_dfr(daily_traffic$rows, as_tibble) %>% 
    mutate(date = as.Date(date))

# Get daily classified data and convert to dataframe ----------------------

daily_classified <- content(
    GET(daily_classified_url,
        add_headers(Authorization = paste("Bearer", token))
    )
)

daily_classified_df <- map_dfr(daily_classified$rows, as_tibble) %>% 
    mutate(date = as.Date(date))


# Get hourly data and convert to dataframe ---------------------------------

sample_site <- sites$sites[10]

hourly_traffic_url <- paste0("https://api.data.tii.ie/traffic//v1/aggregations/",
                             sample_site,
                             "/",
                             date_req,
                             "/hourlytotalsbysite")

hourly_traffic <- content(
    GET(hourly_traffic_url, add_headers(Authorization = paste("Bearer", token)))
)


hourly_traffic_df <- map_dfr(hourly_traffic$rows, as_tibble) %>% 
    mutate(date = as.Date(date))

# Get hourly classified data and convert to dataframe ---------------------

hourly_classified_url <- paste0("https://api.data.tii.ie/traffic/v1/aggregations/",
                                sample_site,
                                "/",
                                date_req,
                                "/hourlytotalsbysitevehicleclass")

hourly_classified <- content(
    GET(
        hourly_classified_url,
        add_headers(Authorization = paste("Bearer", token))
    )
)

hourly_classified_df <- map_dfr(hourly_classified$rows, as_tibble) %>% 
    mutate(date = as.Date(date))
