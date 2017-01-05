## 1. Lena 이미지

library(dplyr)
library(ggplot2)
# install.packages("png")
# install.packages("grid")
library(png)
library(grid)

par(mar=c(0,0,0,0))
plot.new()

lena <- readPNG("02_data/lena.png")
rasterImage(lena,0,0,1,1)

