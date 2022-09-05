library(ggplot2)
library(fmsb)
library(StatsBombR)
library(igraph)
library(tidyverse)
library(dplyr)

# extraemos los eventos
events_eng <- readRDS("scripts/data_england.Rds")
#view(events_eng)
events_norw <- readRDS("scripts/data_norway.Rds")
#view(events_norw)
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
match_eng <- passes_eng %>% filter(match_id == 3835327)

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
match_norw <- passes_norw %>% filter(match_id == 3835327)
# me quedo solo con quién pasa y quién recibe, localización
passes_eng <- passes_eng %>% select(player.name, pass.recipient.name)
#view(passes_eng)
passes_norw <- passes_norw %>% select(player.name, pass.recipient.name)
#view(passes_norw)
#igual para el partido específico eng-norw
match_eng <- match_eng %>% select(player.name, pass.recipient.name)
match_norw <- match_norw %>% select(player.name, pass.recipient.name)
#view(match_eng)
#view(match_norw)
# calculamos entropía total de eng en euro 2022
england <- graph.data.frame(data.frame(passes_eng$player.name,
passes_eng$pass.recipient.name), directed = FALSE)
png(filename = "scripts/plot_england")
plot(england)
dev.off()
england_simplified <- england
E(england_simplified)$weight <- 1
england_simplified <- simplify(england_simplified,
edge.attr.comb = list(weight = "sum"))

england_simplified$diversity <- diversity(england_simplified)
png(filename = "scripts/plot_england_simpl")
plot(england_simplified,
     vertex.size = england_simplified$diversity * 10,
     edge.width = E(england_simplified)$weight / 5)
dev.off()

england_total_ordered <- sort(england_simplified$diversity)
view(england_total_ordered)

# calculamos entropía de eng para partido eng-norw
entropy_match_eng <- graph.data.frame(data.frame(match_eng$player.name,
match_eng$pass.recipient.name), directed = FALSE)
png(filename = "scripts/entropy_match_eng.png")
plot(entropy_match_eng)
dev.off()
entropy_match_engl_simp <- entropy_match_eng
E(entropy_match_engl_simp)$weight <- 1
entropy_match_engl_simp <- simplify(entropy_match_engl_simp, 
edge.attr.comb=list(weight="sum"))


entropy_match_engl_simp$diversity <- diversity(entropy_match_engl_simp)
png(filename = "scripts/entropy_match_engl_simpl.png")
plot(entropy_match_engl_simp,
     vertex.size = entropy_match_engl_simp$diversity * 10,
     edge.width = E(entropy_match_engl_simp)$weight / 5)
dev.off()

england_match_ordered <- sort(entropy_match_engl_simp$diversity)
view(england_match_ordered)

# análogo para noruega
norway <- graph.data.frame(data.frame(passes_norw$player.name,
passes_norw$pass.recipient.name), directed = FALSE)
png(filename = "scripts/plot_norw")
plot(norway)
norway_simplified <- norway
E(norway_simplified)$weight <- 1
norway_simplified <- simplify(norway_simplified,
edge.attr.comb = list(weight = "sum"))
dev.off()

norway_simplified$diversity <- diversity(norway_simplified)
png(filename = "scripts/plot_norw_simpl")
plot(norway_simplified,
     vertex.size = norway_simplified$diversity * 10,
     edge.width = E(norway_simplified)$weight / 5)
dev.off()

norway_total_ordered <- sort(norway_simplified$diversity)
view(norway_total_ordered)

# calculamos entropía de norw para partido eng-norw
entropy_match_norw <- graph.data.frame(data.frame(match_norw$player.name,
match_norw$pass.recipient.name), directed = FALSE)
png(filename = "scripts/entropy_match_norw.png")
plot(entropy_match_norw)
dev.off()
entropy_match_norw_simp <- entropy_match_norw
E(entropy_match_norw_simp)$weight <- 1
entropy_match_norw_simp <- simplify(entropy_match_norw_simp,
edge.attr.comb = list(weight = "sum"))

entropy_match_norw_simp$diversity <- diversity(entropy_match_norw_simp)
png(filename = "scripts/entropy_match_norw_simpl.png")
plot(entropy_match_norw_simp,
     vertex.size = entropy_match_norw_simp$diversity * 10,
     edge.width = E(entropy_match_norw_simp)$weight / 5)
dev.off()

norway_match_ordered <- sort(entropy_match_norw_simp$diversity)
view(norway_match_ordered)

norway_simplified_df <- data.frame(matrix(unlist(norway_simplified$diversity),
nrow = length(norway_simplified$diversity), byrow = TRUE))
view(norway_simplified_df)

radarchart(norway_simplified_df)

england_simplified_df <- data.frame(matrix(
     unlist(england_simplified$diversity),
nrow = length(england_simplified$diversity), byrow = TRUE))
radarchart(england_simplified_df)
