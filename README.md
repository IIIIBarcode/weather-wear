# 프로젝트 소개 : WEATHER WEAR

## WEATHER WEAR의 의미

국내날씨를 기반으로 날씨에 맞는 옷차림을 추천에 주는 어플리케이션

## 필수 구현 8가지

1. **사용자 위치 지정**
   - NAVER OPEN API를 활용하여 사용자의 위치를 지정

2. **날씨 데이터**
   - NAVER API에서 받은 위치 출력값을 기반으로 OpenWeather API에서 날씨 정보를 출력

3. **사용자 입력**
   - 사용자가 위치를 검색하면 해당 위치에 대한 날씨 정보를 제공

4. **날씨 표시**
   - 현재날씨: 상단에 아이콘과 배경화면으로 표현
   - 시간별 날씨와 주간날씨: 날씨 조건을 나타내는 아이콘을 사용

5. **단위 변환**
   - 섭씨와 화씨 사이를 전환하는 옵션을 제공

6. **사용자 친화적인 인터페이스**
   - 위치검색의 오타 변환 기능을 제공

7. **데이터 새로 고침**
   - 사용자가 화면을 아래로 당겨(당겨 새로 고침) 날씨 데이터를 수동으로 새로 고침 가능

8. **배경 이미지**
   - 현재 기상 조건에 맞춰 배경화면이 변경됨으로써 보다 생동감 있게 날씨 정보를 제공

## 추가 기능구현: 

### 1. 사용자 맞춤 정보제공을 위한 피드백 기능 구현

   1) 오늘 추천 옷차림에 대한 사용자의 만족도 설문조사
   
   2) 해당날씨에 대해 사용자가 생각하는 적합한 옷차림을 고를 수 있는 기능
   
   3) 사용자 답변을 기반으로 맟춤 옷차림 추천 정보 데이터를 제공

### 2. 예보 기능
   - 5일간의 날씨 정보를 제공

### 3. MVVM기능 
   - MVVM(Model-View-ViewModel) 패턴을 활용하여 UI로직 처리를 효율화
