## 1. Lena 이미지

library(dplyr)
library(ggplot2)
library(png)
library(grid)
library(httr)

par(mar=c(0,0,0,0))
plot.new()

lena <- readPNG("02_data/lena.png")
rasterImage(lena,0,0,1,1, interpolate = TRUE)
# rasterGrob(lena, interpolate=TRUE)

## 2. 얼굴 위치 파악

img <- httr::upload_file("02_data/lena.png")

face_api_url = "https://api.projectoxford.ai/face/v1.0/detect?returnFaceLandmarks=true&returnFaceAttributes=age,gender,headPose,smile,facialHair,glasses"

faceKEY <- '53xxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
source("03_code/private-keys.R")

result <- POST(url = face_api_url,
               body = img,
               add_headers(.headers = c('Content-Type' = 'application/octet-stream',
                                        'Ocp-Apim-Subscription-Key' = faceKEY))
)

face_df <- as.data.frame(content(result))


## 3. 얼굴 위치 사각형 표시

# View(t(face_df))
dim(lena)
rect <- data.frame(x1 = face_df$faceRectangle.left,
                   x2 = face_df$faceRectangle.left + face_df$faceRectangle.width,
                   y1 = dim(lena)[1] - face_df$faceRectangle.top,
                   y2 = dim(lena)[1] - face_df$faceRectangle.top - face_df$faceRectangle.height)

df <- data.frame(0:dim(lena)[2], 0:dim(lena)[1])

# Placehold Image

g <- rasterGrob(lena, interpolate=TRUE)

# png(filename="04_output/lena_face_location.png", width = 1280, height = 800, units = "px", pointsize = 12, bg = "white", res = 120, restoreConsole = TRUE)
ggplot(df) +  
  scale_x_continuous(limits = c(0, 512)) +
  scale_y_continuous(limits = c(0, 512)) +
  annotation_custom(g, xmin=0, xmax=dim(lena)[2], ymin=0, ymax=dim(lena)[1]) +
  geom_rect(data=rect, mapping=aes(xmin=x1, xmax=x2, ymin=y1, ymax=y2), color="blue", alpha=0.0) +
  coord_fixed()
# dev.off()
