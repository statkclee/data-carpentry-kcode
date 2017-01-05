# 0. 환경설정--------------------------------------------------
library(httr)
library(XML)
library(ggplot2)
library(png)
library(grid)
library(jsonlite)
library(dplyr)

# 1. 데이터 불러오기 ----------------------------------------------

img_list <- list.files("02_data/")

# 2. 얼굴인식 API 호출 ------------------------------------------------

face_api_url <- "https://api.projectoxford.ai/face/v1.0/detect?returnFaceAttributes=age,gender"

# faceKEY <- '53xxxxxxxxxxxxxxxxxx'
source("03_code/private-keys.R")

img_bucket <- list()

for(lst in seq_along(img_list)){
  img_name <- paste0("02_data/", img_list[lst])
  img <- httr::upload_file(img_name)
  
  result <- POST(url = face_api_url,
                 body = img,
                 add_headers(.headers = c('Content-Type' = 'application/octet-stream',
                                          'Ocp-Apim-Subscription-Key' = faceKEY))
  )
  
  img_bucket[[lst]] <- as.data.frame(content(result))[,c("faceAttributes.gender", "faceAttributes.age")]
}

# 3. 데이터 정리-------------------------------------

img_buckets <- do.call(rbind, img_bucket)

img_buckets <- data.frame(idate=img_list, img_buckets)
img_buckets <- img_buckets %>% 
  rename(gender = faceAttributes.gender, age=faceAttributes.age)

img_buckets


