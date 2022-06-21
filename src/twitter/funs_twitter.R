library(httr)
library(jsonlite)
library(data.table)

# function returning header with authorization 
authorization_header = function() {
  # read bearer token from environmental variables
  bearer_token = Sys.getenv('BEARER_TOKEN')
  
  # make header in a required form
  header <- c(`Authorization` = sprintf('Bearer %s', bearer_token))
  
  # return
  header
}

# function retrieving user data from Twitter
get_user_data = function(usernames) {
  # specify requested data
  params = list('user.fields' = paste(config::get('twitter-params')[['user-fields']],
                                      collapse = ','))
  
  # set url to an endpoint
  url = sprintf('https://api.twitter.com/2/users/by?usernames=%s',
                paste(usernames, collapse = ','))
  
  # get response from Twitter
  response =
    httr::GET(url = url,
              httr::add_headers(.headers = authorization_header()),
              query = params)

  # reformat response to data table
  response_content = httr::content(response, as = "text")
  dt_users = as.data.table(fromJSON(response_content, flatten = TRUE))
  
  # return data
  dt_users
}


# function retrieving users Tweets. It returns the whole response object,
# not just data table with content, as in get_user_data
get_user_tweets_response = function(user_id,
                                    start_time,
                                    end_time,
                                    since_id = NULL,
                                    until_id = NULL,
                                    next_token = NULL) {
  
  # specify request parameters
  params = list('tweet.fields' = paste(config::get('twitter-params')[['tweet-fields']],
                                       collapse = ','),
                'start_time' = start_time,
                'end_time' = end_time,
                'max_results' = 100)
  
  # add optional request parameters
  if (!is.null(next_token)) {
    params['pagination_token'] = next_token
  }
  
  if (!is.null(since_id)) {
    params['since_id'] = since_id
  }
  
  if (!is.null(until_id)) {
    params['until_id'] = until_id
  }
  
  # specify request url
  url = sprintf('https://api.twitter.com/2/users/%s/tweets', user_id)
  
  response = httr::GET(url = url,
                       httr::add_headers(.headers = authorization_header()),
                       query = params)
  
  response
}
