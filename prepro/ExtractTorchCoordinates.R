library(tidygeocoder)
library(dplyr)

torch_dat <- read.delim("data/torch_route.csv", sep = ",")

# A few places require manual fixes for as complete route as possible
torch_dat[torch_dat$title == "Vienne", ]$city <- "Chasseneuil-du-Poitou"
torch_dat[torch_dat$title == "French Polynesia", ]$city <- "Papeete"
torch_dat[grepl("Paris", torch_dat$title), ]$city <- "Paris"
torch_dat[torch_dat$title == "Hauts-de-Seine", ]$city <- "Paris"
# no detailed information on this part of the relay
torch_dat <- torch_dat[torch_dat$title != "Relay in Greece", ]


# Add states for clarity
torch_dat <- torch_dat |> 
  mutate(state = case_when(
    city %in% c("Olympia", "Athens") ~ "Greece",
    city == "Papeete" ~ "French Polynesia",
    city == "Baie-Mahault" ~ "Guadeloupe",
    title == "Martinique" ~ "Martinique",
    title == "French Guiana" ~ "French Guiana",
    title == "New Caledonia" ~ "New Caledonia",
    title == "Réunion" ~ "Reunion",
    TRUE ~ "France"
  ))

# From city/location/state names, get coordinates for plotting
torch_coord <- torch_dat  |> 
  geocode(city = city, state = state, method = "osm")

# Add first two stages in Greece
torch_coord <- torch_coord |> 
  mutate(stage_number = case_when(
    city == "Olympia" ~ 1,
    city == "Athens" ~ 2,
    TRUE ~ stage_number + 2
  ))

# add missing coordinates
torch_coord[torch_coord$city == "Athens", ]$lat <- 37.984167 
torch_coord[torch_coord$city == "Athens", ]$long <- 23.728056

torch_coord[torch_coord$city == "Olympia", ]$lat <- 37.638333
torch_coord[torch_coord$city == "Olympia", ]$long <- 21.63

torch_coord[torch_coord$city == "Parc Georges-Valbon", ]$lat <- 48.943487439975016
torch_coord[torch_coord$city == "Parc Georges-Valbon", ]$long <- 2.3987462549502676

torch_coord[torch_coord$city == "Lens-Liévin", ]$lat <- 50.43419023121203
torch_coord[torch_coord$city == "Lens-Liévin", ]$long <- 2.80411044537625

torch_coord$stage_number <- as.factor(torch_coord$stage_number)

save(torch_coord, file = "data/torch_route_coordinates.RData")
