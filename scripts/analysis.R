library(SBpitch)
library(StatsBombR)
library(igraph)
library(tidyverse)
library(dplyr)

# extraemos los eventos

events_eng <- readRDS("scripts/data_england.Rds")
events_norw <- readRDS("scripts/data_norway.Rds")

#quitamos NA
events_eng$pass.outcome.name <- ifelse(is.na(events_eng$pass.outcome.name), 
"Complete", as.character(events_eng$pass.outcome.name))
events_eng$pass.type.name <- ifelse(is.na(events_eng$pass.type.name),
"-", as.character(events_eng$pass.type.name))

# me quedo con los pases, que tienen id 30
events_eng <- events_eng %>% filter(type.id == 30, 
possession_team.name == "England Women's")

#quitamos lo que no son estrictamente pases, o no tengan éxito
passes_eng <- events_eng %>% filter(pass.type.name != "Goal Kick" &
pass.type.name != "Corner" & pass.type.name != "Throw-in" &
pass.type.name != "Free Kick" & pass.type.name != "Kick Off" &
pass.outcome.name == "Complete")

# análogo para Noruega

events_norw$pass.outcome.name <- ifelse(is.na(events_norw$pass.outcome.name),
"Complete", as.character(events_norw$pass.outcome.name))
events_norw$pass.type.name <- ifelse(is.na(events_norw$pass.type.name),
"-", as.character(events_norw$pass.type.name))

events_norw <- events_norw %>% filter(type.id == 30, 
possession_team.name == "Norway Women's")

passes_norw <- events_norw %>% filter(pass.type.name != "Goal Kick" &
pass.type.name != "Corner" & pass.type.name != "Throw-in" &
pass.type.name != "Free Kick" & pass.type.name != "Kick Off" &
pass.outcome.name == "Complete")

## reduzco las tablas
#passes_eng <- passes_eng %>% select(timestamp, location, player.name,
#pass.length, pass.angle, pass.end_location, pass.recipient.name,
#location.x, location.y, pass.end_location.x, pass.end_location.y)

#view(passes_eng)

# me quedo solo con quién pasa y quién recibe, localización
passes_eng <- passes_eng %>% select(player.name, pass.recipient.name)

#passes_norw <- passes_norw %>% select(timestamp, location, player.name,
#pass.length, pass.angle, pass.end_location, pass.recipient.name,
#location.x, location.y, pass.end_location.x, pass.end_location.y)
#view(passes_norw)
passes_norw <- passes_norw %>% select(player.name, pass.recipient.name)

# creamos el campo
p <- create_Pitch(grass_colour = "#224C56",
line_colour =  "#B3CED9",
background_colour = "#224C56",
goal_colour = "#15393D")

england <- graph.data.frame(data.frame(passes_eng$player.name,
passes_eng$pass.recipient.name), directed = TRUE)
plot(england)
