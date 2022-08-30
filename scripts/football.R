# descomentar si no están instalados.
# Fuentes usadas:
# https://github.com/Dato-Futbol/passing-networks
# https://github.com/statsbomb/StatsBombR
# https://github.com/FCrSTATS/StatsBomb_WomensData
# https://github.com/JoGall/soccermatics
# https://ryo-n7.github.io/2019-08-21-visualize-soccer-statsbomb-part-1/
# https://biscuitchaserfc.substack.com/p/getting-started-with-statsbomb-data

# Datos obtenidos de: https://github.com/statsbomb/open-data
#
#install.packages("devtools", dependencies=TRUE)
#devtools::install_github("statsbomb/SDMTools")
#devtools::install_github("statsbomb/StatsBombR")
# devtools::install_github("FCrSTATS/SBpitch") # to plot a pitch
#install.packages("dplyr")
#install.packages("tidyverse")
#install.packages("igraph", dependencies=TRUE)
# devtools::install_github("FCrSTATS/SBpitch") # to plot a pitch

library(SBpitch)
library(StatsBombR)
library(igraph)
library(tidyverse)
library(dplyr)

comps <- FreeCompetitions()

# nos quedamos con la UEFA Women's Euro 2022, que
# tiene competition_id 53 y season_id 106
comp <- FreeCompetitions() %>%
  filter(competition_id == 53, season_id == 106)

# cargar partidos disponibles para UEFA Women's Euro
matches <- FreeMatches(Competitions = comp)
view(matches)
# vemos que para filtrar por país, tendremos que usar la
# columna home_team.country.name o away_team.country.name

# para obtener los datos de eventos disponibles y limpiar
all_data <- free_allevents(MatchesDF = matches) %>% allclean()

# nos quedamos con las columnas que nos interesan
data <- all_data %>% select(match_id, home_score,
away_score, match_status_360, match_week, home_team.country.name,
away_team.country.name, competition_stage.name)

#guardamos los partidos en los que jugó Noruega
noruega <- data %>% 
filter(home_team.country.name == "Norway" | away_team.country.name == "Norway")

#guardamos los partidos en los que jugó Inglaterra
inglaterra <- data %>% 
filter(home_team.country.name == "England" | away_team.country.name == "England")

