library(tidyverse)

# get todays most recent download file
today_fp <- "https://ea-edubase-api-prod.azurewebsites.net/edubase/downloads/public/edubasealldata20200413.csv"

# manually adjusting the date on the csv file to pull something from 2019-01-01
# this will be a time period where we can expect to see differences
yesterday_fp <- "https://ea-edubase-api-prod.azurewebsites.net/edubase/downloads/public/edubasealldata20180101.csv"

# read the csv
estabs <- read_csv(today_fp) %>% 
  janitor::clean_names()


# programatically assignD by date
# will pin this to have one pin per day. This is bad, but only to test this out
# over the next day 
# _hopefully_ tomorrow there is a change
estab_obj_date <- glue::glue("estabs_{format(Sys.Date(), '%y%m%d')}")


# register pin board
pins::board_register_local()

# pin today's data
# get is a way to grab an object by string name from environment
pins::pin(estabs, estab_obj_date)

# fetch specs from read_csv
estab_specs <- spec(estabs)

# pass specs to vroom
# using vroom as an example to quikly read in big data
yesterday_estabs <- vroom::vroom(yesterday_fp, col_types = estab_specs) %>% 
  janitor::clean_names()

# are there new observations?
equal <- all_equal(estabs, yesterday_estabs)

# this checks to see if there are differences between data

if (isTRUE(equal)) {
  "there are no changes"
} else {
  equal
}

# after manual inspection I cannot find the difference
