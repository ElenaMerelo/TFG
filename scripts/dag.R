library(igraph)

data <- read.csv("../data/dag-data.csv",header=FALSE)
a.graph <- graph.data.frame(data.frame(data$V1,data$V2))
png(filename="../doc/dag.png")
plot(a.graph)
dev.off()
