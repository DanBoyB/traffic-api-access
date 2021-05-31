import requests
import pandas as pd
import json

# sample date for query
date_req = "2021-04-18"

# urls for accessing
sites_url = "https://api.data.tii.ie/traffic//v1/sites/available"
token_url = "https://api.data.tii.ie/traffic/v1/token"

# store token details as character strings and acces data as dictionary
token_access = "token-access-key-here"
token_secret = "token-secret-key-here"
access_data = {'accessKey':token_access, 'secretKey':token_secret}

# POST request for token
token_req = requests.post(token_url, json = access_data)

# Get a list of all sites
sites = requests.get(sites_url, headers = {"Authorization": "Bearer " + token_req.text})
sites = json.loads(sites.text)
sites = sites['sites']

# Get daily data and convert to dataframe
daily_traffic_url = "https://api.data.tii.ie/traffic/v1/aggregations/" + date_req + "/dailytotalsbysite"
daily_traffic = requests.get(daily_traffic_url, headers = {"Authorization": "Bearer " + token_req.text})
daily_traffic_json = json.loads(daily_traffic.text)
daily_traffic_df = pd.DataFrame(daily_traffic_json['rows'])

# Get daily classified data and convert to dataframe
daily_classified_url = "https://api.data.tii.ie/traffic/v1/aggregations/" + date_req + "/dailytotalsbysitevehicleclass"
daily_classified = requests.get(daily_classified_url, headers = {"Authorization": "Bearer " + token_req.text})
daily_classified_json = json.loads(daily_classified.text)
daily_classified_df = pd.DataFrame(daily_classified_json['rows'])

# Get hourly data and convert to dataframe
sample_site = sites[10]
hourly_traffic_url = "https://api.data.tii.ie/traffic//v1/aggregations/" + sample_site + "/" + date_req + "/hourlytotalsbysite"
hourly_traffic = requests.get(hourly_traffic_url, headers = {"Authorization": "Bearer " + token_req.text})
hourly_traffic_json = json.loads(hourly_traffic.text)
hourly_traffic_df = pd.DataFrame(hourly_traffic_json['rows'])

# Get hourly classified data and convert to dataframe
hourly_classified_url = "https://api.data.tii.ie/traffic//v1/aggregations/" + sample_site + "/" + date_req + "/hourlytotalsbysitevehicleclass"
hourly_classified = requests.get(hourly_classified_url, headers = {"Authorization": "Bearer " + token_req.text})
hourly_classified_json = json.loads(hourly_classified.text)
hourly_classified_df = pd.DataFrame(hourly_classified_json['rows'])

