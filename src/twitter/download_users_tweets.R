# load functions
source('src/twitter/funs_twitter.R')

# read data with info on users
dt_users = fread(config::get('path-file')[['users']])


# create loop sending requests to Twitter API
for (i in 1:nrow(dt_users)) {
  n = 1
  user_id = dt_users[i, data.id]
  user_name = dt_users[i, data.username]
  
  # get first response
  response = get_user_tweets_response(user_id,
                                      start_time = '2022-01-01T00:00:00Z',
                                      end_time = '2022-04-30T23:59:59Z')
  # get status code
  st_code = status_code(response)
  
  # flatten the content of response and save it to file
  object = fromJSON(httr::content(response, as = 'text'), flatten = TRUE)
  file_name = paste0(config::get('path-dir')[['data-twitter']],
                     '/',
                     user_name,
                     '_',
                     as.character(Sys.Date()),
                     '_r',
                     as.character(n))
  write_json(object, file_name)
  
  n = n + 1
  
  # get value of next token
  next_token = object[['meta']][['next_token']]
  
  while (st_code == 200 & !is.null(next_token)) {
    # get response
    response = get_user_tweets_response(user_id,
                                        start_time = '2022-01-01T00:00:00Z',
                                        end_time = '2022-04-30T23:59:59Z',
                                        next_token = next_token
                                        )
    # get status code
    st_code = status_code(response)
    
    # flatten the content of response and save it to file
    object = fromJSON(httr::content(response, as = 'text'), flatten = TRUE)
    file_name = paste0(config::get('path-dir')[['data-twitter']],
                       '/',
                       user_name,
                       '_',
                       as.character(Sys.Date()),
                       '_r',
                       as.character(n))
    write_json(object, file_name)
    
    # change response number value
    n = n + 1
    
    # get value of next token
    next_token = object[['meta']][['next_token']]
  }
}
