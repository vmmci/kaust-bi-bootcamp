install.packages("tidyverse")
install.packages("corrr")
install.packages("factoextra")
install.packages("pheatmap")

library(tidyverse)
library(corrr)
library(factoextra)
library(pheatmap)
setwd("C:/Users/vmcii/OneDrive/Desktop/ProjectR")
getwd()
dir()

#2) Load the data and initial exploration

ds4 <- read.csv('DATA_FSB_SET_4A.csv', row.names = 1)
any(!complete.cases(ds4))
ds4 <- as.matrix(ds4)
head(ds4)
#3) Investigating the distribution of the data
hist(ds4, xlab = "nominal expression values")
ds4.lg <- log1p(ds4)
hist(ds4.lg, xlab = "log scale expression values with pseudocount 1")
data <- ds4.lg %>% 
  as.data.frame %>%
  pivot_longer(names_to = "patient", values_to = "expression", cols = 1:ncol(ds4))
data$planet <- 'Venus'
data$planet[grep('Earth', data$patient)] <- 'Earth'

plt <- data %>% 
  ggplot() + 
  geom_histogram(aes(x = expression, y = ..density.., fill = planet), 
                 binwidth = .5, alpha=.6) +
  xlab("Expression [log1p]") 
plt

#3 – 3B) Distribution per gene (normality)
venus.idx <- grep("Venus",colnames(ds4.lg))
earth.idx <- grep("Earth",colnames(ds4.lg))

qqnorm(ds4.lg[3,venus.idx])
qqline(ds4.lg[3,venus.idx], col = "steelblue", lwd = 2)
shapiro.test(ds4.lg[3,venus.idx])
shapiro.test(ds4.lg[3,earth.idx])


#4) Investigating the distribution of the "samples" (PCA)
ds4.lg.pca <- prcomp(t(ds4.lg), scale = FALSE, center = FALSE)


plot(ds4.lg.pca, xlab = "Dimension", main = 'Scree plot')


cp <- cumsum(ds4.lg.pca$sdev^2 / sum(ds4.lg.pca$sdev^2))
plot(cp, 
     xlab = "PC #", 
     ylab = "Amount of explained variance", 
     main = "Cumulative variance plot")


col.by.planet <- rep('Earth', ncol(ds4.lg)) 
col.by.planet[grep('Venus', colnames(ds4.lg))] <- 'Venus'

library("factoextra")
fviz_pca_ind(ds4.lg.pca,
             axes = c(1, 2),
             geom = c("point"),
             col.ind = col.by.planet)
#5) Differential analysis: single gene
venus.idx <- grep('Venus', colnames(ds4))
earth.idx <- grep('Earth', colnames(ds4))

t.test(ds4.lg['Gene1',venus.idx], ds4.lg['Gene1',earth.idx])

#6) Differential analysis: all genes
p.vals <- sapply(1:nrow(ds4.lg), 
                 function(i) 
                   t.test(ds4.lg[i, earth.idx],ds4.lg[i, venus.idx])[c("p.value")]
)
table(p.vals < 0.05)


#7) Heatmaps (significant genes)

library(pheatmap)
de.idx <- p.vals < 0.05

pheatmap(ds4.lg[de.idx,])



#7 – Variability in genes + Volcano plot

plot(apply(ds4.lg[,earth.idx], 1, mean), apply(ds4.lg[,earth.idx], 1, var), 
     xlab = 'Mean expression [log]',
     ylab = 'Expression variance [log]', 
     main = 'Expression Mean vs. Variance for Earth samples',
     pch = 19)


fc.log <- -log10(apply(ds4.lg[,venus.idx], 1, mean) / apply(ds4.lg[,earth.idx], 1, mean))
col.fc <- rep('black', nrow(ds4.lg))
col.fc[p.vals < 0.01 & fc.log < 0] <- 'red'
col.fc[p.vals < 0.01 & fc.log > 0] <- 'green'

plot(fc.log, -log10(unlist(p.vals)), 
     main = 'Volcano plot',
     xlab = 'mean log expression',
     ylab = 'sd log expression',
     col = col.fc,
     pch = 19)
abline(h = -log10(0.01), v = 0)



