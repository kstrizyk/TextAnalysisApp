# load necessary functions
source('src/twitter/funs_twitter.R')

# load users choice
users_choice = fread(config::get('path-file')[['users-choice']])

# get users data from Twitter
dt_users = get_user_data(users_choice[['Username']])

# add column with time of last update
dt_users[, lastUpdate := Sys.time()]

# save file
fwrite(dt_users, config::get('path-file')[['users']])

# clean namespace
rm(users_choice, dt_users)
