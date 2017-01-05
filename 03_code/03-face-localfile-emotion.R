## 00. 환경설정  ========================================================================================== 
library("httr")
library("XML")
library("ggplot2")

## 01. 마이크로소프트 API 설정 ==========================================================================================

# 적용할 마이크로소프트 API 지정
URL.emoface <- 'https://api.projectoxford.ai/emotion/v1.0/recognize'

# 접속 인증키 설정
# emotionKEY = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
source("03_code/private-keys.R") 

## 02. 감정분석할 이미지 지정 및 호출 ==========================================================================================

img <- httr::upload_file("02_data/suji.jpg")
emotion_api_url = "https://api.projectoxford.ai/emotion/v1.0/recognize"

suji_face <- POST(url = emotion_api_url,
            body = img,
            add_headers(.headers = c('Content-Type' = 'application/octet-stream',
                        'Ocp-Apim-Subscription-Key' = emotionKEY))
)

## 03. 감정분석결과 추가분석 (Suji Face) ==========================================================================================
# 얼굴 분석결과
suji_face_lst <- httr::content(suji_face)[[1]]
suji_face_df <- as.data.frame(suji_face_lst[2]) %>% t %>% as.data.frame

suji_face_df$V1 <- lapply(strsplit(as.character(suji_face_df$V1), "e"), "[", 1)
suji_face_df$V1 <- as.numeric(suji_face_df$V1)
colnames(suji_face_df)[1] <- "Level"

suji_face_df$Emotion <- sub("scores.", "", rownames(suji_face_df))

# 시각화
ggplot(suji_face_df, aes(x=Emotion, y=Level)) +   
  geom_bar(stat="identity")

suji_face_df
