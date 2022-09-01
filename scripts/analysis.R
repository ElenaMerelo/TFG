library(ggplot2)
library(fmsb)
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
team.name == "England Women's")

#quitamos lo que no son estrictamente pases, o no tengan éxito
passes_eng <- events_eng %>% filter(pass.type.name == "-" &
pass.outcome.name == "Complete")

# partido eng-norw, desde eng
#match_eng <- passes_eng %>% filter(match_id == 3835327)
# análogo para Noruega
events_norw$pass.outcome.name <- ifelse(is.na(events_norw$pass.outcome.name),
"Complete", as.character(events_norw$pass.outcome.name))
events_norw$pass.type.name <- ifelse(is.na(events_norw$pass.type.name),
"-", as.character(events_norw$pass.type.name))

events_norw <- events_norw %>% filter(type.id == 30,
team.name == "Norway Women's")

passes_norw <- events_norw %>% filter(pass.type.name == "-" &
pass.outcome.name == "Complete")

# partido eng -norw, desde norw
# match_norw <- passes_norw %>% filter(match_id == 3835327)
# me quedo solo con quién pasa y quién recibe, localización
passes_eng <- passes_eng %>% select(player.name, pass.recipient.name)
passes_norw <- passes_norw %>% select(player.name, pass.recipient.name)


# calculamos entropía total de eng en euro 2022
england <- graph.data.frame(data.frame(passes_eng$player.name,
passes_eng$pass.recipient.name), directed = FALSE)
png(filename = "scripts/plot_england")
plot(england)
dev.off()
england.simplified <- england
E(england.simplified)$weight <- 1
england.simplified <- simplify(england.simplified, edge.attr.comb=list(weight="sum"))


england.simplified$diversity <- diversity(england.simplified)
png(filename = "scripts/plot_england_simpl")
plot(england.simplified,
     vertex.size=england.simplified$diversity*10,
     edge.width=E(england.simplified)$weight/5)
dev.off()
view(england.simplified$diversity)


# análogo para noruega
dev.off()
norway <- graph.data.frame(data.frame(passes_norw$player.name,
passes_norw$pass.recipient.name), directed = FALSE)
png(filename = "scripts/plot_norw")
plot(norway)
norway.simplified <- norway
E(norway.simplified)$weight <- 1
norway.simplified <- simplify(norway.simplified, edge.attr.comb=list(weight="sum"))
dev.off()

norway.simplified$diversity <- diversity(norway.simplified)
png(filename = "scripts/plot_norw_simpl")
plot(norway.simplified,
     vertex.size=norway.simplified$diversity*10,
     edge.width=E(norway.simplified)$weight/5)
dev.off()
view(norway.simplified$diversity)

norway.simplified.df <- data.frame(matrix(unlist(norway.simplified$diversity), 
nrow=length(norway.simplified$diversity), byrow = TRUE))
view(norway.simplified.df)

radarchart(norway.simplified.df)

england.simplified.df <- data.frame(matrix(unlist(england.simplified$diversity), 
nrow=length(england.simplified$diversity), byrow = TRUE))
radarchart(england.simplified.df)
