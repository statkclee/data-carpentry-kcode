##==========================================================================================
## 00. 환경설정  
##==========================================================================================
#install.packages(c("httr", "XML"))
library("httr")
library("XML")
library("ggplot2")
setwd("C:/Users/KwangChun/Dropbox/01_data_science/data-carpentry-ai")

##==========================================================================================
## 01. 마이크로소프트 API 설정  
##==========================================================================================

# 적용할 마이크로소프트 API 지정
URL.emoface = 'https://api.projectoxford.ai/emotion/v1.0/recognize'

# 접속 인증키 설정
# emotionKEY = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
source("03_code/private-keys.R") 

##==========================================================================================
## 02. 감정분석할 이미지 지정 및 호출
##==========================================================================================

emotion_fn <- function(img.url){
    mybody = list(url = img.url)
    
    # 마이크로소프트에 API 호출 및 데이터 요청
    faceEMO  <-  POST(
      url = URL.emoface,
      content_type('application/json'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = emotionKEY)),
      body = mybody,
      encode = 'json'
    )
    
    # 결과값 출력, Status=200 이면 모든 것이 OK!!!
    return(faceEMO)
}

# 이미지 지정
angry_face_pic <- 'https://raw.githubusercontent.com/statkclee/2016-11-06-sogang/gh-pages/figure/angry-face.jpg'
angry_face <- emotion_fn(angry_face_pic)

baby_face_pic <- 'https://raw.githubusercontent.com/statkclee/2016-11-06-sogang/gh-pages/figure/baby_face.jpg'
# baby_face_pic <- 'http://i.imgur.com/QKVtbPX.png'
baby_face <- emotion_fn(baby_face_pic)

##==========================================================================================
## 03. 감정분석결과 추가분석 (Angry Face)
##==========================================================================================
# 얼굴 분석결과
angry_face_lst <-  httr::content(angry_face)[[1]]

# 분석결과 시각화를 위해 결과값을 데이터프레임으로 변환
angry_face_df <-as.data.frame(as.matrix(angry_face_lst$scores))

angry_face_df$V1 <- lapply(strsplit(as.character(angry_face_df$V1), "e"), "[", 1)
angry_face_df$V1 <- as.numeric(angry_face_df$V1)
colnames(angry_face_df)[1] <- "Level"

angry_face_df$Emotion <- rownames(angry_face_df)

# 시각화
ggplot(angry_face_df, aes(x=Emotion, y=Level)) +   
  geom_bar(stat="identity")

##==========================================================================================
## 03. 감정분석결과 추가분석 (Baby Face)
##==========================================================================================
# 얼굴 분석결과
baby_face_lst <-  httr::content(baby_face)[[1]]

# 분석결과 시각화를 위해 결과값을 데이터프레임으로 변환
baby_face_df <-as.data.frame(as.matrix(baby_face_lst$scores))

baby_face_df$V1 <- lapply(strsplit(as.character(baby_face_df$V1), "e"), "[", 1)
baby_face_df$V1 <- as.numeric(baby_face_df$V1)
colnames(baby_face_df)[1] <- "Level"

baby_face_df$Emotion <- rownames(baby_face_df)

# 시각화

ggplot(baby_face_df, aes(x=Emotion, y=Level)) +   
  geom_bar(stat="identity")

